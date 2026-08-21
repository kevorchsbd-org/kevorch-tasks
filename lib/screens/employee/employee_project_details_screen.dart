import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/task_status_badge.dart';
import 'employee_task_details_screen.dart';

class EmployeeProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;
  final EmployeeModel loggedInEmployee;

  const EmployeeProjectDetailsScreen({
    super.key,
    required this.project,
    required this.loggedInEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final updatedProject = provider.getProjectById(project.id) ?? project;
        final employeeTasks = provider
            .getTasksByEmployee(loggedInEmployee.employeeName)
            .where((t) => t.projectType == updatedProject.projectName)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Project Details",
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.borderGray, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderGray, width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRedLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.folder_rounded,
                                color: AppColors.primaryRed,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    updatedProject.projectName,
                                    style: AppTypography.pageTitle.copyWith(
                                      fontSize: 20,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    updatedProject.collegeName,
                                    style: AppTypography.bodySecondary.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.borderGray, height: 1),
                        const SizedBox(height: 16),
                        Text(
                          "Project Description",
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          updatedProject.projectDescription,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _buildInfoChip(
                              Icons.category_outlined,
                              "Domain",
                              updatedProject.domain,
                            ),
                            _buildInfoChip(
                              Icons.calendar_today_outlined,
                              "Assigned Date",
                              updatedProject.createdDate,
                            ),
                            _buildInfoChip(
                              Icons.person_outline_rounded,
                              "Lead Assigned",
                              updatedProject.assignedEmployee ?? "Unassigned",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Tasks in this Project",
                        style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGray,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Text(
                          "${employeeTasks.length} Tasks",
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 300),
                  child: employeeTasks.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(30),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderGray, width: 1),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.assignment_turned_in_outlined,
                                size: 36,
                                color: AppColors.lightGray,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No tasks assigned to you in this project",
                                style: AppTypography.bodySecondary,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: employeeTasks.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final task = employeeTasks[index];
                            return ScaleTapWidget(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  AppPageRoute.create(
                                    EmployeeTaskDetailsScreen(
                                      task: task,
                                      loggedInEmployee: loggedInEmployee,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.borderGray, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.cardShadow,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.taskTitle,
                                            style: AppTypography.cardTitle.copyWith(
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TaskStatusBadge(status: task.status),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      task.taskDescription,
                                      style: AppTypography.bodySecondary.copyWith(
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          task.taskType,
                                          style: AppTypography.label.copyWith(
                                            fontSize: 11,
                                            color: AppColors.darkGray,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.event_outlined,
                                              size: 13,
                                              color: AppColors.mediumGray,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Due ${task.dueDate}",
                                              style: AppTypography.bodySecondary.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.mediumGray),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.label.copyWith(fontSize: 11),
            ),
            Text(
              value,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
