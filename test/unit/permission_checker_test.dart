import 'package:flutter_test/flutter_test.dart';
import 'package:shop_sphere/core/auth/permission.dart';
import 'package:shop_sphere/core/auth/user_role.dart';

void main() {
  group('PermissionChecker', () {
    test('customer cannot access admin panel', () {
      expect(
        PermissionChecker.can(
          UserRole.customer,
          AppPermission.viewAdminPanel,
        ),
        isFalse,
      );
    });

    test('staff can view admin panel but not manage users', () {
      expect(
        PermissionChecker.can(UserRole.staff, AppPermission.viewAdminPanel),
        isTrue,
      );
      expect(
        PermissionChecker.can(UserRole.staff, AppPermission.manageUsers),
        isFalse,
      );
    });

    test('manager can manage products and orders', () {
      expect(
        PermissionChecker.can(UserRole.manager, AppPermission.manageProducts),
        isTrue,
      );
      expect(
        PermissionChecker.can(UserRole.manager, AppPermission.manageOrders),
        isTrue,
      );
    });

    test('admin has full permissions', () {
      for (final permission in AppPermission.values) {
        expect(
          PermissionChecker.can(UserRole.admin, permission),
          isTrue,
          reason: 'Admin should have $permission',
        );
      }
    });
  });

  group('UserRole', () {
    test('fromString defaults to customer for unknown roles', () {
      expect(UserRole.fromString(null), UserRole.customer);
      expect(UserRole.fromString('unknown'), UserRole.customer);
    });

    test('role levels compare correctly', () {
      expect(UserRole.admin.hasAtLeast(UserRole.staff), isTrue);
      expect(UserRole.customer.hasAtLeast(UserRole.staff), isFalse);
    });
  });
}
