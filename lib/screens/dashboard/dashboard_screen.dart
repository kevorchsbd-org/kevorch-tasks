import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/primary_button.dart';
import '../employees/employee_details_screen.dart';
import '../tasks/task_details_screen.dart';
import '../monitoring/monitoring_screen.dart';
import '../projects/create_project_modal.dart';
import '../tasks/create_task_modal.dart';

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
        final projects = data.projects;
        final tasks = data.tasks;

        final activeProjectsCount = projects.length;
        final totalEmployeesCount = employees.length;
        final pendingTasksCount = tasks.where((t) => t.status.toUpperCase() != 'DONE').length;
        final tasksInReview = tasks.where((t) => t.status.toUpperCase() == 'REVIEW' || t.status.toUpperCase() == 'TESTING').toList();

        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 768;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: "Dashboard",
            showHeaderProfile: true,
            onMonitoringPressed: () {
              Navigator.of(context).push(
                AppPageRoute.create(const MonitoringScreen()),
              );
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Compact Welcome Header & Quick Action Shortcuts
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Operational Overview 👋",
                              style: AppTypography.pageTitle.copyWith(
                                fontSize: isMobile ? 17 : 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Platform status & active queue",
                              style: AppTypography.bodySecondary.copyWith(fontSize: 11.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQuickActionButton(
                            context: context,
                            icon: Icons.add_rounded,
                            label: "Task",
                            onTap: () => CreateTaskModal.show(context),
                          ),
                          const SizedBox(width: 6),
                          _buildQuickActionButton(
                            context: context,
                            icon: Icons.create_new_folder_outlined,
                            label: "Project",
                            onTap: () => CreateProjectModal.show(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Primary KPI Summary Grid
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: GridView.count(
                    crossAxisCount: isMobile ? 2 : 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isMobile ? 1.35 : 1.4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      KpiCard(
                        label: "Active Projects",
                        count: "$activeProjectsCount",
                        icon: Icons.folder_open_rounded,
                        iconColor: AppColors.primary,
                        accentBg: AppColors.primaryLight,
                        onTap: () => onNavigateToTab?.call(1),
                      ),
                      KpiCard(
                        label: "Total Employees",
                        count: "$totalEmployeesCount",
                        icon: Icons.people_outline_rounded,
                        iconColor: const Color(0xFF2E90FA),
                        accentBg: const Color(0xFFEFF8FF),
                        onTap: () => onNavigateToTab?.call(2),
                      ),
                      KpiCard(
                        label: "Pending Tasks",
                        count: "$pendingTasksCount",
                        icon: Icons.assignment_outlined,
                        iconColor: const Color(0xFFF79009),
                        accentBg: const Color(0xFFFFFAEB),
                        onTap: () => onNavigateToTab?.call(3),
                      ),
                      KpiCard(
                        label: "Tasks in Review",
                        count: "${tasksInReview.length}",
                        icon: Icons.rate_review_outlined,
                        iconColor: const Color(0xFF9333EA),
                        accentBg: const Color(0xFFF3E8FF),
                        onTap: () => onNavigateToTab?.call(3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Needs Attention Section (Tasks waiting for review)
                if (tasksInReview.isNotEmpty) ...[
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error_outline_rounded, color: AppColors.warning, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Needs Attention",
                                  style: AppTypography.sectionTitle.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.warningLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.warning.withAlpha(50), width: 0.8),
                              ),
                              child: Text(
                                "${tasksInReview.length} Pending Review",
                                style: AppTypography.label.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasksInReview.length > 2 ? 2 : tasksInReview.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final task = tasksInReview[index];
                            return GlassCard(
                              padding: const EdgeInsets.all(14),
                              backgroundColor: AppColors.white.withAlpha(240),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  AppPageRoute.create(
                                    TaskDetailsScreen(task: task),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3E8FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.rate_review_rounded, color: Color(0xFF9333EA), size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.taskTitle,
                                          style: AppTypography.cardTitle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Assigned to ${task.assignedEmployee} • ${task.projectType}",
                                          style: AppTypography.bodySecondary.copyWith(fontSize: 11.5),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 34,
                                    child: PrimaryButton(
                                      text: "Review",
                                      icon: Icons.arrow_forward_rounded,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          AppPageRoute.create(
                                            TaskDetailsScreen(task: task),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // 4. Employee Team Overview Section
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 180),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Employee Team Status",
                        style: AppTypography.sectionTitle.copyWith(
                          fontSize: isMobile ? 16 : 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onNavigateToTab?.call(2),
                        child: Text(
                          "View All (${employees.length})",
                          style: AppTypography.label.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

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
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return FadeSlideTransition(
                        delay: Duration(milliseconds: 200 + (index * 40)),
                        child: _DashboardEmployeeCard(
                          employee: employee,
                          isMobile: isMobile,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.label.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardEmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final bool isMobile;
  final VoidCallback onTap;

  const _DashboardEmployeeCard({
    required this.employee,
    this.isMobile = true,
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
          border: Border.all(color: AppColors.border, width: 1),
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
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.primary,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          employee.employeeName,
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: isMobile ? 14 : 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      PriorityBadge(priority: employee.priority, fontSize: 10),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    employee.role,
                    style: AppTypography.bodySecondary.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
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
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          employee.currentProject,
                          style: AppTypography.label.copyWith(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
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
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
