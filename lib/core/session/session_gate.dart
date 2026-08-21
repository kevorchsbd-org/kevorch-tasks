import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../navigation/admin_navigation.dart';
import '../../navigation/employee_navigation.dart';
import '../../navigation/super_admin_navigation.dart';
import '../../screens/login/login_screen.dart';
import 'session_roles.dart';
import 'session_service.dart';

enum SessionGateState { checking, valid, invalidOrLoggedOut }

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  SessionGateState _state = SessionGateState.checking;
  Widget? _targetScreen;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    // Small delay to make transition smooth if desired, otherwise instant
    if (!SessionService.isLoggedIn()) {
      setState(() {
        _state = SessionGateState.invalidOrLoggedOut;
        _targetScreen = const LoginScreen();
      });
      return;
    }

    final role = SessionService.getRole();
    final userId = SessionService.getUserId();
    final email = SessionService.getEmail();

    if (userId == null || email == null || !SessionRoles.isValid(role)) {
      await SessionService.clearSession();
      setState(() {
        _state = SessionGateState.invalidOrLoggedOut;
        _targetScreen = const LoginScreen();
      });
      return;
    }

    if (role == SessionRoles.employee) {
      final employeeId = SessionService.getEmployeeId();
      if (employeeId == null) {
        await SessionService.clearSession();
        setState(() {
          _state = SessionGateState.invalidOrLoggedOut;
          _targetScreen = const LoginScreen();
        });
        return;
      }

      final provider = DummyDataProvider();
      final employee = provider.getEmployeeById(employeeId);
      if (employee == null) {
        await SessionService.clearSession();
        setState(() {
          _state = SessionGateState.invalidOrLoggedOut;
          _targetScreen = const LoginScreen();
        });
        return;
      }

      setState(() {
        _state = SessionGateState.valid;
        _targetScreen = EmployeeNavigation(loggedInEmployee: employee);
      });
    } else if (role == SessionRoles.admin) {
      setState(() {
        _state = SessionGateState.valid;
        _targetScreen = const AdminNavigation();
      });
    } else if (role == SessionRoles.superAdmin) {
      setState(() {
        _state = SessionGateState.valid;
        _targetScreen = const SuperAdminNavigation();
      });
    } else {
      await SessionService.clearSession();
      setState(() {
        _state = SessionGateState.invalidOrLoggedOut;
        _targetScreen = const LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == SessionGateState.checking || _targetScreen == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primaryRed,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _targetScreen!;
  }
}
