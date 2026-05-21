import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../business/domain/entities/business.dart';
import '../../../business/domain/entities/business_type.dart';
import '../../../notifications/data/models/notification_model.dart';
import '../../../notifications/data/notification_messages.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../team/data/staff_api_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/app_user.dart';

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).watchCurrentAppUser();
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repo, this._ref) : super(const AsyncData(null));

  final AuthRepository _repo;
  final Ref _ref;

  Future<AppUser> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _repo.signIn(email: email, password: password);
      state = const AsyncData(null);
      return user;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<AppUser> register(RegisterAdminInput input) async {
    state = const AsyncLoading();
    try {
      final user = await _repo.registerAdmin(input);
      await _createNotification(NotificationMessages.welcome());
      state = const AsyncData(null);
      return user;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> switchBusiness(String businessId) async {
    state = const AsyncLoading();
    try {
      await _repo.switchActiveBusiness(businessId);
      final business =
          await _ref.read(businessRepositoryProvider).getById(businessId);
      if (business != null) {
        await _createNotification(
          NotificationMessages.businessSwitched(
            businessName: business.name,
            businessId: business.id,
          ),
        );
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Business> createBusiness({
    required String name,
    required String slug,
    required BusinessType businessType,
    String? legalName,
    String? nipt,
    String? fiscalAddress,
  }) async {
    state = const AsyncLoading();
    try {
      final business = await _repo.createAdditionalBusiness(
        name: name,
        slug: slug,
        businessType: businessType,
        legalName: legalName,
        nipt: nipt,
        fiscalAddress: fiscalAddress,
      );
      await _createNotification(
        NotificationMessages.businessCreated(
          businessName: business.name,
          businessId: business.id,
        ),
      );
      state = const AsyncData(null);
      return business;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updatePlan(BusinessPlan plan) async {
    state = const AsyncLoading();
    try {
      await _repo.updateSubscriptionPlan(plan);
      await _createNotification(
        NotificationMessages.planUpdated(planLabel: plan.title),
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<({AppUser user, String businessName})> registerStaffAndAcceptInvite({
    required RegisterStaffInput input,
    required String inviteCode,
    required StaffApiService staffApi,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _repo.registerStaff(input);
      final accept = await staffApi.acceptInvite(code: inviteCode, email: user.email);
      await _createNotification(NotificationMessages.welcome());
      state = const AsyncData(null);
      final refreshed = await _repo.getCurrentAppUser() ?? user;
      return (
        user: refreshed,
        businessName: accept['businessName'] as String? ?? '',
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }

  Future<void> _createNotification(CreateNotificationInput input) async {
    final uid = _repo.currentFirebaseUser?.uid;
    if (uid == null) return;
    try {
      await _ref.read(notificationDispatcherProvider).notifyUser(
            userId: uid,
            input: input,
          );
    } catch (_) {
      // Notifications are best-effort; do not fail the main action.
    }
  }

}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider), ref);
});

final currentBusinessIdProvider = Provider<String?>((ref) {
  final id = ref.watch(authStateProvider).valueOrNull?.businessId;
  if (id == null || id.isEmpty) return null;
  return id;
});

final hasActiveBusinessProvider = Provider<bool>((ref) {
  return ref.watch(currentBusinessIdProvider) != null;
});

final isSuperAdminProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.isSuperAdmin ?? false;
});
