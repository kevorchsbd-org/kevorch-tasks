import 'package:flutter/material.dart';
import '../widgets/super_admin_bottom_nav_bar.dart';
import '../screens/super_admin/super_admin_dashboard_screen.dart';
import '../screens/projects/projects_screen.dart';
import '../screens/employees/employees_screen.dart';
import '../screens/tasks/tasks_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../core/session/session_roles.dart';

class SuperAdminNavigation extends StatefulWidget {
  const SuperAdminNavigation({super.key});

  @override
  State<SuperAdminNavigation> createState() => _SuperAdminNavigationState();
}

class _SuperAdminNavigationState extends State<SuperAdminNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SuperAdminDashboardScreen(onNavigateToTab: _onTabTapped),
      const ProjectsScreen(),
      const EmployeesScreen(),
      const TasksScreen(),
      const ProfileScreen(role: SessionRoles.superAdmin),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SuperAdminBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
