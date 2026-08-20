import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_app_bar.dart';
import '../employees/employee_details_screen.dart';
import '../monitoring/monitoring_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const DashboardScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final employees = data.employees;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(
            title: "Admin Dashboard",
            showHeaderProfile: true,
            onMonitoringPressed: () {
              Navigator.of(context).push(
                AppPageRoute.create(const MonitoringScreen()),
              );
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title & Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Employee Overview",
                      style: AppTypography.sectionTitle.copyWith(fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRedLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${employees.length} Active",
                        style: AppTypography.label.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Employee Cards List
                if (employees.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Center(
                      child: Text(
                        "No employees registered",
                        style: AppTypography.bodySecondary,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: employees.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return FadeSlideTransition(
                        delay: Duration(milliseconds: 100 + (index * 60)),
                        child: _DashboardEmployeeCard(
                          employee: employee,
                          onTap: () {
                            Navigator.of(context).push(
                              AppPageRoute.create(
                                EmployeeDetailsScreen(employeeId: employee.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardEmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;

  const _DashboardEmployeeCard({
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderGray),
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
            // Profile Avatar Circle
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  employee.initials,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Employee Name, Role & Current Project
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.employeeName,
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    employee.role,
                    style: AppTypography.bodySecondary.copyWith(
                      fontSize: 11.5,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.folder_outlined,
                        size: 12,
                        color: AppColors.mediumGray,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          employee.currentProject,
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            color: AppColors.mediumGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Chevron Icon
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.mediumGray.withAlpha(150),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
