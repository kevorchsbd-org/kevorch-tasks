import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/projects/projects_screen.dart';
import '../screens/employees/employees_screen.dart';
import '../screens/tasks/tasks_screen.dart';

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
    final List<Widget> pages = [
      DashboardScreen(onNavigateToTab: _onTabTapped),
      const ProjectsScreen(),
      const EmployeesScreen(),
      const TasksScreen(),
    ];

    return Scaffold(
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
