import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/primary_button.dart';
import 'assign_employee_modal.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final project = data.getProjectById(projectId);

        if (project == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Project Details")),
            body: const Center(child: Text("Project not found")),
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
              "Project Details",
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
                      // Header & Domain Badge
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                project.projectName,
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
                                border: Border.all(color: AppColors.primaryRed.withAlpha(40)),
                              ),
                              child: Text(
                                project.domain,
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Project Information Card
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
                                "Project Information",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                project.projectDescription,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.darkGray,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.account_balance_outlined,
                                label: "College Name",
                                value: project.collegeName,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.category_outlined,
                                label: "Domain",
                                value: project.domain,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: "Created Date",
                                value: project.createdDate,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Assigned Employee Section
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Assigned Employee",
                                    style: AppTypography.cardTitle.copyWith(fontSize: 18),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: project.isAssigned
                                          ? AppColors.primaryRedLight
                                          : AppColors.surfaceGray,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: project.isAssigned
                                            ? AppColors.primaryRed.withAlpha(40)
                                            : AppColors.borderGray,
                                      ),
                                    ),
                                    child: Text(
                                      project.isAssigned ? "Assigned" : "Unassigned",
                                      style: AppTypography.label.copyWith(
                                        fontSize: 12,
                                        color: project.isAssigned
                                            ? AppColors.primaryRed
                                            : AppColors.mediumGray,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Employee Details / Unassigned View
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: project.isAssigned
                                    ? Row(
                                        key: ValueKey("assigned_${project.assignedEmployee}"),
                                        children: [
                                          Container(
                                            width: 52,
                                            height: 52,
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
                                                project.assignedInitials,
                                                style: AppTypography.cardTitle.copyWith(
                                                  color: AppColors.white,
                                                  fontSize: 18,
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
                                                  project.assignedEmployee!,
                                                  style: AppTypography.cardTitle.copyWith(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "Project Lead / Assignee",
                                                  style: AppTypography.bodySecondary.copyWith(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        key: const ValueKey("unassigned"),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceGray,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.borderGray),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_off_outlined,
                                              color: AppColors.mediumGray,
                                              size: 22,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              "Not Assigned",
                                              style: AppTypography.bodySecondary.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 20),

                              // Action Button
                              PrimaryButton(
                                text: "Assign Employee",
                                icon: Icons.person_add_alt_1_rounded,
                                onPressed: () {
                                  AssignEmployeeModal.show(context, project);
                                },
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
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mediumGray),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
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
              color: AppColors.black,
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
