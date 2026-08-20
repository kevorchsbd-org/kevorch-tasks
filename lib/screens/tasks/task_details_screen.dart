import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'EM';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final task = data.getTaskById(taskId);

        if (task == null) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("Task Details", style: AppTypography.sectionTitle),
            ),
            body: Center(
              child: Text(
                "Task not found",
                style: AppTypography.bodySecondary,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Task Details",
              style: AppTypography.sectionTitle,
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Task Title & Status Badge Header
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                task.taskTitle,
                                style: AppTypography.pageTitle.copyWith(fontSize: 26),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRedLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.primaryRed.withAlpha(40),
                                ),
                              ),
                              child: Text(
                                task.status,
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Task Information Section
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Task Information",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                task.taskDescription.isNotEmpty
                                    ? task.taskDescription
                                    : "No description provided.",
                                style: AppTypography.body.copyWith(
                                  color: AppColors.darkGray,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.folder_outlined,
                                label: "Project Type",
                                value: task.projectType,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.category_outlined,
                                label: "Task Type",
                                value: task.taskType,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Assignment Information Section
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assignment Information",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.black,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.borderGray,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _getInitials(task.assignedEmployee),
                                        style: AppTypography.cardTitle.copyWith(
                                          color: AppColors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.assignedEmployee,
                                          style: AppTypography.cardTitle.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Assigned Employee",
                                          style: AppTypography.bodySecondary.copyWith(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. Date Information Section
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 400),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date Information",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: "Created Date",
                                value: task.createdDate,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.event_available_outlined,
                                label: "Due Date",
                                value: task.dueDate,
                                valueColor: AppColors.primaryRed,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 5. Status Information Section
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status Information",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRedLight,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.primaryRed.withAlpha(40),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.pending_actions_rounded,
                                          size: 16,
                                          color: AppColors.primaryRed,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          task.status,
                                          style: AppTypography.label.copyWith(
                                            color: AppColors.primaryRed,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      "Current task state.",
                                      style: AppTypography.bodySecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mediumGray),
        const SizedBox(width: 10),
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: AppTypography.bodySecondary.copyWith(
              color: AppColors.mediumGray,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.label.copyWith(
              color: valueColor ?? AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
