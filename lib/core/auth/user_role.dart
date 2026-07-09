/// Role-based access control roles for ShopSphere.
enum UserRole {
  customer('customer'),
  staff('staff'),
  manager('manager'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.customer,
    );
  }

  int get level {
    switch (this) {
      case UserRole.customer:
        return 0;
      case UserRole.staff:
        return 1;
      case UserRole.manager:
        return 2;
      case UserRole.admin:
        return 3;
    }
  }

  bool hasAtLeast(UserRole required) => level >= required.level;
}
