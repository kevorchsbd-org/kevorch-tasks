import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/models.dart';

class EmployeeProjectSnapshot extends StatelessWidget {
  final List<ProjectModel> assignedProjects;
  final VoidCallback? onSeeAll;
  final ValueChanged<ProjectModel>? onProjectTap;

  const EmployeeProjectSnapshot({
    super.key,
    required this.assignedProjects,
    this.onSeeAll,
    this.onProjectTap,
  });

  DateTime _getSortDate(ProjectModel project) {
    if (project.assignedDate != null) {
      return project.assignedDate!;
    }
    return DateTime.tryParse(project.createdDate) ?? DateTime(1970);
  }

  @override
  Widget build(BuildContext context) {
    final totalProjects = assignedProjects.length;
    final completedProjects = assignedProjects.where((p) => p.status == ProjectStatus.completed).length;
    final activeProjects = assignedProjects.where((p) => p.status != ProjectStatus.completed).toList();
    
    final activeRatio = totalProjects == 0 ? 0.0 : activeProjects.length / totalProjects;
    final activePercentage = (activeRatio * 100).round();

    // Resolve current focus project (most recently assigned active project)
    ProjectModel? currentFocus;
    if (activeProjects.isNotEmpty) {
      final sortedActive = List<ProjectModel>.from(activeProjects);
      sortedActive.sort((a, b) {
        final aDate = _getSortDate(a);
        final bDate = _getSortDate(b);
        return bDate.compareTo(aDate);
      });
      currentFocus = sortedActive.first;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // Soft ambient glow container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFBFBFB),
            const Color(0xFFFEF2F2).withValues(alpha: 0.4),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (YOUR PROJECTS | See All ->)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'YOUR PROJECTS',
                      style: AppTypography.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mediumGray,
                        letterSpacing: 0.8,
                      ),
                    ),
                    InkWell(
                      onTap: onSeeAll,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'See All',
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 11,
                            color: AppColors.primaryRed,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Primary Metric (Total Count + Assigned Label)
                Text(
                  totalProjects.toString().padLeft(2, '0'),
                  style: AppTypography.summaryNumber.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Projects Assigned',
                  style: AppTypography.bodySecondary.copyWith(
                    fontSize: 13,
                    color: AppColors.mediumGray,
                  ),
                ),
                const SizedBox(height: 16),

                // Active Projects section (Label & Count/Percentage Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Projects',
                      style: AppTypography.body.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                    Text(
                      '${activeProjects.length.toString().padLeft(2, '0')}  •  $activePercentage%',
                      style: AppTypography.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Compact Active-Ratio Bar
                Container(
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: totalProjects == 0
                      ? const SizedBox()
                      : TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 500),
                          tween: Tween<double>(begin: 0, end: activeRatio),
                          builder: (context, value, _) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: value,
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDC2626),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 8),

                // Completed Counter Text
                Text(
                  '${completedProjects.toString().padLeft(2, '0')} Completed',
                  style: AppTypography.bodySecondary.copyWith(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),

                // Currently Working On Section
                if (totalProjects > 0) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  Text(
                    'CURRENTLY WORKING ON',
                    style: AppTypography.label.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mediumGray,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (currentFocus != null)
                    InkWell(
                      onTap: () => onProjectTap?.call(currentFocus!),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentFocus.projectName,
                                    style: AppTypography.cardTitle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    currentFocus.currentTimelineStage,
                                    style: AppTypography.bodySecondary.copyWith(
                                      fontSize: 12,
                                      color: AppColors.mediumGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.mediumGray,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // All completed state
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF16A34A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'All projects completed',
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                ] else ...[
                  // Zero projects assigned state message
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.mediumGray,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'No projects assigned yet',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
