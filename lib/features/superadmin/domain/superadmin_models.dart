class SuperAdminUserRow {
  const SuperAdminUserRow({
    required this.id,
    required this.email,
    required this.role,
    required this.businessId,
    required this.maxBusinesses,
    required this.maxProducts,
    this.displayName,
  });

  final String id;
  final String email;
  final String role;
  final String businessId;
  final int maxBusinesses;
  final int maxProducts;
  final String? displayName;
}

class SuperAdminBusinessRow {
  const SuperAdminBusinessRow({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.slug,
    required this.active,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String ownerId;
  final String? slug;
  final bool active;
  final DateTime createdAt;
}

class SuperAdminProductRow {
  const SuperAdminProductRow({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.name,
    required this.status,
    required this.updatedAt,
  });

  final String id;
  final String businessId;
  final String businessName;
  final String name;
  final String status;
  final DateTime updatedAt;
}
