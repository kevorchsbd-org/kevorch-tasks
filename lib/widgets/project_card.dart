import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/animations/app_animations.dart';
import '../data/models.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTapWidget(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGray),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    project.projectName,
                    style: AppTypography.cardTitle.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderGray),
                    ),
                    child: Text(
                      project.domain,
                      style: AppTypography.label.copyWith(
                        fontSize: 11,
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.projectDescription,
              style: AppTypography.bodySecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_outlined,
                        size: 16,
                        color: AppColors.mediumGray,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          project.collegeName,
                          style: AppTypography.label.copyWith(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(
                      project.isAssigned
                          ? Icons.person_rounded
                          : Icons.person_outline_rounded,
                      size: 14,
                      color: project.isAssigned
                          ? AppColors.primaryRed
                          : AppColors.mediumGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      project.isAssigned
                          ? project.assignedEmployee!
                          : "Not Assigned",
                      style: AppTypography.label.copyWith(
                        fontSize: 12,
                        color: project.isAssigned
                            ? AppColors.black
                            : AppColors.mediumGray,
                        fontWeight: project.isAssigned
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
