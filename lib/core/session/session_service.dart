import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static SharedPreferences? _prefs;

  // Pre-load SharedPreferences before runApp
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save session info
  static Future<void> saveSession({
    required String role,
    required String userId,
    required String email,
    String? employeeId,
  }) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('role', role);
    await prefs.setString('userId', userId);
    await prefs.setString('email', email);
    
    if (employeeId != null) {
      await prefs.setString('employeeId', employeeId);
    } else {
      await prefs.remove('employeeId');
    }
  }

  // Safe checks & getters
  static bool isLoggedIn() {
    return _prefs?.getBool('isLoggedIn') ?? false;
  }

  static String? getRole() {
    return _prefs?.getString('role');
  }

  static String? getUserId() {
    return _prefs?.getString('userId');
  }

  static String? getEmail() {
    return _prefs?.getString('email');
  }

  static String? getEmployeeId() {
    return _prefs?.getString('employeeId');
  }

  // Clear session on logout or invalid state
  static Future<void> clearSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('role');
    await prefs.remove('userId');
    await prefs.remove('email');
    await prefs.remove('employeeId');
  }
}
