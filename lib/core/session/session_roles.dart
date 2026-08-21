class SessionRoles {
  static const String admin = 'ADMIN';
  static const String superAdmin = 'SUPER_ADMIN';
  static const String employee = 'EMPLOYEE';

  static const List<String> all = [admin, superAdmin, employee];

  static bool isValid(String? role) {
    if (role == null) return false;
    return all.contains(role);
  }
}
