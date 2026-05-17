enum UserRole {
  superadmin('superadmin'),
  owner('owner'),
  admin('admin'),
  manager('manager'),
  employee('employee');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (r) => r.value == value,
      orElse: () => UserRole.employee,
    );
  }

  bool get isSuperAdmin => this == UserRole.superadmin;

  String get label => switch (this) {
        UserRole.superadmin => 'Superadmin',
        UserRole.owner => 'Owner',
        UserRole.admin => 'Admin',
        UserRole.manager => 'Manager',
        UserRole.employee => 'Employee',
      };

  bool canWriteCatalog() =>
      this == UserRole.owner ||
      this == UserRole.admin ||
      this == UserRole.manager;

  bool canManageUsers() => this == UserRole.owner || this == UserRole.admin;

  bool canManageApiKeys() => canManageUsers();
}
