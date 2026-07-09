import 'user_role.dart';

/// Scalable permission definitions for RBAC.
enum AppPermission {
  viewAdminPanel,
  manageProducts,
  manageOrders,
  manageUsers,
  managePromotions,
}

class PermissionChecker {
  const PermissionChecker._();

  static bool can(UserRole role, AppPermission permission) {
    switch (permission) {
      case AppPermission.viewAdminPanel:
        return role.hasAtLeast(UserRole.staff);
      case AppPermission.manageProducts:
        return role.hasAtLeast(UserRole.manager);
      case AppPermission.manageOrders:
        return role.hasAtLeast(UserRole.staff);
      case AppPermission.manageUsers:
        return role.hasAtLeast(UserRole.admin);
      case AppPermission.managePromotions:
        return role.hasAtLeast(UserRole.manager);
    }
  }
}
