import 'package:flutter/material.dart';
import '../data/models.dart';
import '../widgets/employee_bottom_nav_bar.dart';
import '../screens/employee/employee_dashboard_screen.dart';
import '../screens/employee/employee_projects_screen.dart';
import '../screens/employee/employee_tasks_screen.dart';

class EmployeeNavigation extends StatefulWidget {
  final EmployeeModel loggedInEmployee;

  const EmployeeNavigation({
    super.key,
    required this.loggedInEmployee,
  });

  @override
  State<EmployeeNavigation> createState() => _EmployeeNavigationState();
}

class _EmployeeNavigationState extends State<EmployeeNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      EmployeeDashboardScreen(
        loggedInEmployee: widget.loggedInEmployee,
        onNavigateToTab: _onTabTapped,
      ),
      EmployeeProjectsScreen(
        loggedInEmployee: widget.loggedInEmployee,
      ),
      EmployeeTasksScreen(
        loggedInEmployee: widget.loggedInEmployee,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: EmployeeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
