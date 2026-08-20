import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/employee_card.dart';
import '../../widgets/primary_button.dart';
import 'add_employee_modal.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final filteredEmployees = data.employees.where((e) {
          final q = _searchQuery.toLowerCase();
          return e.employeeName.toLowerCase().contains(q) ||
              e.email.toLowerCase().contains(q) ||
              e.role.toLowerCase().contains(q);
        }).toList();

        return Scaffold(
          appBar: const CustomAppBar(title: "Employees"),
          floatingActionButton: SizedBox(
            height: 34,
            child: FloatingActionButton.extended(
              heroTag: 'employees_fab',
              onPressed: () => AddEmployeeModal.show(context),
              backgroundColor: AppColors.primaryRed,
              elevation: 3,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              icon: const Icon(Icons.person_add_rounded, color: AppColors.white, size: 14),
              label: Text(
                "Add Employee",
                style: AppTypography.button.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search employee name, email or role...",
                      hintStyle: AppTypography.bodySecondary,
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.mediumGray),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "All Team Members (${filteredEmployees.length})",
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredEmployees.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 56,
                                color: AppColors.lightGray,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No employees found",
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 180,
                                child: PrimaryButton(
                                  text: "Add Employee",
                                  onPressed: () => AddEmployeeModal.show(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: index * 80),
                              child: EmployeeCard(employee: employee),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
