import 'package:flutter_test/flutter_test.dart';

import 'package:business_dashboard/core/auth/business_permissions.dart';
import 'package:business_dashboard/core/constants/user_roles.dart';
import 'package:business_dashboard/features/auth/domain/entities/app_user.dart';
import 'package:business_dashboard/features/business/domain/entities/business.dart';

AppUser _user(UserRole role) => AppUser(
      id: 'u1',
      email: 'a@b.com',
      businessId: 'b1',
      role: role,
      maxBusinesses: 5,
      maxProducts: 100,
    );

Business _business() => Business(
      id: 'b1',
      name: 'Test Shop',
      ownerId: 'u1',
      createdAt: DateTime(2024),
      slug: 'test-shop',
    );

BusinessPermissions _perms({
  required UserRole role,
  bool isStoreOwner = false,
}) =>
    BusinessPermissions(
      user: _user(role),
      business: _business(),
      isStoreOwner: isStoreOwner,
    );

void main() {
  group('BusinessPermissions.canAccessRoute', () {
    test('store owner can access employees and orders', () {
      final p = _perms(role: UserRole.owner, isStoreOwner: true);
      expect(p.canAccessRoute('/employees'), isTrue);
      expect(p.canAccessRoute('/orders'), isTrue);
      expect(p.canAccessRoute('/products'), isTrue);
    });

    test('employee can access products but not employees', () {
      final p = _perms(role: UserRole.employee);
      expect(p.canAccessRoute('/products'), isTrue);
      expect(p.canAccessRoute('/employees'), isFalse);
      expect(p.canAccessRoute('/orders'), isTrue);
    });

    test('employee cannot access settings or billing', () {
      final p = _perms(role: UserRole.employee);
      expect(p.canAccessRoute('/settings'), isFalse);
      expect(p.canAccessRoute('/billing'), isFalse);
    });

    test('manager can write catalog but not team-only routes', () {
      final p = _perms(role: UserRole.manager);
      expect(p.canAccessRoute('/offers'), isTrue);
      expect(p.canAccessRoute('/products'), isTrue);
      expect(p.canAccessRoute('/employees'), isFalse);
      expect(p.canAccessRoute('/custom-fields'), isFalse);
    });
  });
}
