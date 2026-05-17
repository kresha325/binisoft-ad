import 'package:equatable/equatable.dart';

import '../../../../core/constants/user_roles.dart';

class AppUser extends Equatable {
  const AppUser({
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
  /// Active business for the admin session.
  final String businessId;
  final UserRole role;
  final int maxBusinesses;
  /// Max products allowed in each business catalog.
  final int maxProducts;
  final String? displayName;

  bool get isSuperAdmin => role.isSuperAdmin;

  @override
  List<Object?> get props =>
      [id, email, businessId, role, maxBusinesses, maxProducts, displayName];
}
