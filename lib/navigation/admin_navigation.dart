import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/admin_sidebar.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/projects/projects_screen.dart';
import '../screens/employees/employees_screen.dart';
import '../screens/tasks/tasks_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../core/session/session_roles.dart';
import '../core/theme/app_colors.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    final List<Widget> pages = [
      DashboardScreen(onNavigateToTab: _onTabTapped),
      const ProjectsScreen(),
      const EmployeesScreen(),
      const TasksScreen(),
      const ProfileScreen(role: SessionRoles.admin),
    ];

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            AdminSidebar(
              currentIndex: _currentIndex,
              onTabSelected: _onTabTapped,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
