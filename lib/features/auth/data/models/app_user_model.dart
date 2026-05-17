import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/constants/user_roles.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel {
  AppUserModel({
    required this.id,
    required this.email,
    required this.businessId,
    required this.role,
    required this.maxBusinesses,
    required this.maxProducts,
    this.displayName,
  });

  final String id;
  final String email;
  final String businessId;
  final String role;
  final int maxBusinesses;
  final int maxProducts;
  final String? displayName;

  factory AppUserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final maxBusinesses = data['maxBusinesses'] as int? ?? 1;
    return AppUserModel(
      id: doc.id,
      email: data['email'] as String,
      businessId: data['businessId'] as String? ?? '',
      role: (data['role'] as String?) ?? UserRole.admin.value,
      maxBusinesses: maxBusinesses,
      maxProducts: BusinessPlan.migrateMaxProducts(
        maxProducts: data['maxProducts'] as int?,
        maxBusinesses: maxBusinesses,
      ),
      displayName: data['displayName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'businessId': businessId,
        'role': role,
        'maxBusinesses': maxBusinesses,
        'maxProducts': maxProducts,
        if (displayName != null) 'displayName': displayName,
      };

  AppUser toEntity() => AppUser(
        id: id,
        email: email,
        businessId: businessId,
        role: UserRole.fromString(role),
        maxBusinesses: maxBusinesses,
        maxProducts: maxProducts,
        displayName: displayName,
      );
}
