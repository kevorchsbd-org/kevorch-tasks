import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/employee_card.dart';
import 'add_employee_modal.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String _searchQuery = "";
  String _selectedRole = "All";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final roles = ["All", "Developer", "UI/UX Designer", "Project Lead"];

        final filteredEmployees = data.employees.where((e) {
          final q = _searchQuery.toLowerCase();
          final matchesQuery = e.employeeName.toLowerCase().contains(q) ||
              e.email.toLowerCase().contains(q) ||
              e.role.toLowerCase().contains(q);
          final matchesRole = _selectedRole == "All" ||
              e.role.toLowerCase().contains(_selectedRole.toLowerCase());
          return matchesQuery && matchesRole;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: "Employees"),
          floatingActionButton: SizedBox(
            height: 40,
            child: FloatingActionButton.extended(
              heroTag: 'employees_fab',
              onPressed: () => AddEmployeeModal.show(context),
              backgroundColor: AppColors.primary,
              elevation: 4,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              icon: const Icon(Icons.person_add_rounded, color: AppColors.white, size: 18),
              label: Text(
                "Add Employee",
                style: AppTypography.button.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Badge Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people_outline_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Employees",
                            style: AppTypography.label.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                          Text(
                            "${data.employees.length}",
                            style: AppTypography.summaryNumber.copyWith(fontSize: 22, height: 1.1),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${data.employees.length} Active",
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTypography.body.copyWith(fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: "Search employee name, email or role...",
                      hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 13),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Role Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: roles.map((role) {
                      final isSelected = _selectedRole == role;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(role),
                          selected: isSelected,
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: AppColors.primary,
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                          labelStyle: AppTypography.label.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedRole = role;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // Employee List
                Expanded(
                  child: filteredEmployees.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 40,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 12),
                              Text("No employees found", style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                              const SizedBox(height: 4),
                              Text("Try adjusting your search or role filter", style: AppTypography.bodySecondary),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredEmployees.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: 40 * index),
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
