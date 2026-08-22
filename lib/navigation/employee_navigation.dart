import 'package:flutter/material.dart';
import '../data/models.dart';
import '../widgets/employee_bottom_nav_bar.dart';
import '../widgets/desktop_sidebar.dart';
import '../screens/employee/employee_dashboard_screen.dart';
import '../screens/employee/employee_projects_screen.dart';
import '../screens/employee/employee_tasks_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../core/session/session_roles.dart';

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
    final isDesktop = MediaQuery.of(context).size.width >= 800;

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
      ProfileScreen(
        role: SessionRoles.employee,
        employeeId: widget.loggedInEmployee.id,
      ),
    ];

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            DesktopSidebar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              loggedInEmployee: widget.loggedInEmployee,
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
