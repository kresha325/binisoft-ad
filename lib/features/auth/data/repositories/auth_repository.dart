import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/business_plans.dart';
import '../../../../core/constants/superadmin_config.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/firestore/tenant_paths.dart';
import '../../../business/data/repositories/business_repository.dart';
import '../../../products/data/repositories/product_repository.dart';
import '../../../business/domain/entities/business.dart';
import '../../domain/entities/app_user.dart';
import '../models/app_user_model.dart';

class RegisterAdminInput {
  const RegisterAdminInput({
    required this.email,
    required this.password,
    this.displayName,
  });

  final String email;
  final String password;
  final String? displayName;
}

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final TenantPaths _paths;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentFirebaseUser => _auth.currentUser;

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(firebaseAuthErrorMessage(e));
    }
    return _loadAppUser();
  }

  /// Admin account only — business is created after sign-in from the dashboard.
  Future<AppUser> registerAdmin(RegisterAdminInput input) async {
    UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: input.email.trim(),
        password: input.password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(firebaseAuthErrorMessage(e));
    }

    final uid = credential.user!.uid;
    final email = input.email.trim().toLowerCase();
    final isSuperAdmin = SuperAdminConfig.isBootstrapEmail(email);
    final role =
        isSuperAdmin ? UserRole.superadmin.value : UserRole.admin.value;

    final user = AppUserModel(
      id: uid,
      email: email,
      businessId: '',
      role: role,
      maxBusinesses: isSuperAdmin
          ? PlatformLimits.superadminMaxBusinesses
          : BusinessPlan.defaultPlan.maxBusinesses,
      maxProducts: isSuperAdmin
          ? PlatformLimits.superadminMaxProducts
          : BusinessPlan.defaultPlan.maxProducts,
      displayName: input.displayName,
    );

    try {
      await _paths.user(uid).set(user.toMap());
    } on FirebaseException catch (e) {
      await credential.user?.delete();
      if (e.code == 'permission-denied') {
        throw const FirestoreException(
          'Could not save profile. Deploy Firestore rules: '
          'firebase deploy --only firestore:rules',
        );
      }
      throw FirestoreException(e.message ?? 'Could not create account');
    }

    return user.toEntity();
  }

  Future<AppUser> _loadAppUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AuthException('Not signed in');
    try {
      final doc = await _paths.user(uid).get();
      if (!doc.exists) {
        throw const AuthException(
          'User profile not found. Complete registration or contact support.',
        );
      }
      final model = AppUserModel.fromFirestore(doc);
      final synced = await _syncBootstrapSuperAdminAccount(model);
      final resolved = await _ensureActiveBusinessOnProfile(synced);
      return resolved.toEntity();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const FirestoreException(
          'Firestore access denied. Deploy security rules: '
          'firebase deploy --only firestore:rules',
        );
      }
      throw FirestoreException(e.message ?? 'Could not load profile');
    }
  }

  Future<AppUserModel> _syncBootstrapSuperAdminAccount(AppUserModel model) async {
    final promoted = await _promoteBootstrapSuperAdminIfNeeded(model);
    return _cleanupBootstrapLegacyBusinesses(promoted);
  }

  /// Keeps [businessId] aligned with a business the user owns (fixes stale IDs).
  Future<AppUserModel> _ensureActiveBusinessOnProfile(AppUserModel model) async {
    if (_isBootstrapAccount(model)) return model;

    final repo = BusinessRepository(firestore: _firestore);
    final owned = await repo.listOwnedBy(model.id);
    if (owned.isEmpty) return model;

    final ownedIds = owned.map((b) => b.id).toSet();
    if (model.businessId.isNotEmpty && ownedIds.contains(model.businessId)) {
      return model;
    }

    final nextId = owned.first.id;
    try {
      await _paths.user(model.id).update({'businessId': nextId});
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const FirestoreException(
          'Could not sync active business. Deploy Firestore rules: '
          'firebase deploy --only firestore:rules',
        );
      }
      rethrow;
    }

    return AppUserModel(
      id: model.id,
      email: model.email,
      businessId: nextId,
      role: model.role,
      maxBusinesses: model.maxBusinesses,
      maxProducts: model.maxProducts,
      displayName: model.displayName,
    );
  }

  bool _isBootstrapAccount(AppUserModel model) {
    final authEmail = _auth.currentUser?.email;
    return SuperAdminConfig.isBootstrapEmail(model.email) ||
        (authEmail != null && SuperAdminConfig.isBootstrapEmail(authEmail));
  }

  /// Removes test businesses from bootstrap superadmin (old admin flow leftovers).
  Future<AppUserModel> _cleanupBootstrapLegacyBusinesses(AppUserModel model) async {
    if (!_isBootstrapAccount(model)) return model;

    final repo = BusinessRepository(firestore: _firestore);
    final owned = await repo.listOwnedBy(model.id);
    if (owned.isEmpty && model.businessId.isEmpty) {
      if (model.role == UserRole.superadmin.value) return model;
      return AppUserModel(
        id: model.id,
        email: model.email,
        businessId: model.businessId,
        role: UserRole.superadmin.value,
        maxBusinesses: PlatformLimits.superadminMaxBusinesses,
        maxProducts: PlatformLimits.superadminMaxProducts,
        displayName: model.displayName,
      );
    }

    for (final business in owned) {
      await repo.deleteBusiness(business.id);
    }

    final updates = <String, dynamic>{'businessId': ''};
    if (model.role != UserRole.superadmin.value) {
      updates['role'] = UserRole.superadmin.value;
      updates['maxBusinesses'] = PlatformLimits.superadminMaxBusinesses;
      updates['maxProducts'] = PlatformLimits.superadminMaxProducts;
    }
    await _paths.user(model.id).update(updates);

    return AppUserModel(
      id: model.id,
      email: model.email,
      businessId: '',
      role: UserRole.superadmin.value,
      maxBusinesses: PlatformLimits.superadminMaxBusinesses,
      maxProducts: PlatformLimits.superadminMaxProducts,
      displayName: model.displayName,
    );
  }

  /// Accounts created before superadmin existed keep role `admin` in Firestore.
  Future<AppUserModel> _promoteBootstrapSuperAdminIfNeeded(AppUserModel model) async {
    if (!_isBootstrapAccount(model)) return model;
    if (model.role == UserRole.superadmin.value &&
        model.businessId.isEmpty &&
        model.maxBusinesses >= PlatformLimits.superadminMaxBusinesses &&
        model.maxProducts >= PlatformLimits.superadminMaxProducts) {
      return model;
    }

    try {
      await _paths.user(model.id).update({
        'role': UserRole.superadmin.value,
        'maxBusinesses': PlatformLimits.superadminMaxBusinesses,
        'maxProducts': PlatformLimits.superadminMaxProducts,
        'businessId': '',
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const FirestoreException(
          'Could not apply superadmin role. Deploy Firestore rules: '
          'firebase deploy --only firestore:rules',
        );
      }
      rethrow;
    }

    return AppUserModel(
      id: model.id,
      email: model.email,
      businessId: '',
      role: UserRole.superadmin.value,
      maxBusinesses: PlatformLimits.superadminMaxBusinesses,
      maxProducts: PlatformLimits.superadminMaxProducts,
      displayName: model.displayName,
    );
  }

  Future<AppUser?> getCurrentAppUser() async {
    if (_auth.currentUser == null) return null;
    return _loadAppUser();
  }

  Stream<AppUser?> watchCurrentAppUser() {
    return authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);
      return _paths.user(user.uid).snapshots().asyncMap((doc) async {
        if (!doc.exists) return null;
        final model = AppUserModel.fromFirestore(doc);
        final synced = await _syncBootstrapSuperAdminAccount(model);
        return synced.toEntity();
      });
    });
  }

  Future<Business> createAdditionalBusiness({
    required String name,
    required String slug,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AuthException('Not signed in');

    final userDoc = await _paths.user(uid).get();
    if (!userDoc.exists) throw const AuthException('User profile not found');

    final maxBusinesses = userDoc.data()?['maxBusinesses'] as int? ?? 1;
    final repo = BusinessRepository(firestore: _firestore);
    final count = await repo.countOwnedBy(uid);
    if (count >= maxBusinesses) {
      throw AuthException(
        'Business limit reached ($maxBusinesses). Upgrade your plan to add more.',
      );
    }

    final business = await repo.create(ownerId: uid, name: name, slug: slug);
    await _paths.user(uid).update({'businessId': business.id});
    return business;
  }

  Future<void> updateSubscriptionPlan(BusinessPlan plan) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AuthException('Not signed in');

    final userDoc = await _paths.user(uid).get();
    final businessId = userDoc.data()?['businessId'] as String? ?? '';
    if (businessId.isNotEmpty) {
      final productCount =
          await ProductRepository(firestore: _firestore).count(businessId: businessId);
      if (productCount > plan.maxProducts) {
        throw AuthException(
          'This business has $productCount products. Remove '
          '${productCount - plan.maxProducts} or choose a higher plan (up to ${plan.maxProducts}).',
        );
      }
    }

    await _paths.user(uid).update({
      'maxProducts': plan.maxProducts,
      'maxBusinesses': plan.maxBusinesses,
    });
  }

  Future<void> switchActiveBusiness(String businessId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AuthException('Not signed in');

    final business = await _paths.business(businessId).get();
    if (!business.exists || business.data()?['ownerId'] != uid) {
      throw const AuthException('You do not own this business');
    }

    await _paths.user(uid).update({'businessId': businessId});
  }

  Future<void> signOut() => _auth.signOut();
}
