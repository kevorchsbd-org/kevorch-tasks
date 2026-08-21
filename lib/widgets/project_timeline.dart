import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/models.dart';

class ProjectTimeline extends StatelessWidget {
  final ProjectModel project;
  final bool isAdmin;
  final VoidCallback? onRework;
  final VoidCallback? onTesting;
  final VoidCallback? onReview;
  final VoidCallback? onClosure;
  final VoidCallback? onConfirmClosure;

  const ProjectTimeline({
    super.key,
    required this.project,
    this.isAdmin = false,
    this.onRework,
    this.onTesting,
    this.onReview,
    this.onClosure,
    this.onConfirmClosure,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      "Project Assigned",
      "Student Added",
      "Initial Process",
      "Student Work",
      "Phase 1 Review",
      "Rework",
      "Testing",
      "Project Closure",
      "Completed"
    ];

    final currentStage = project.currentTimelineStage;
    final currentIndex = stages.contains(currentStage) ? stages.indexOf(currentStage) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stages.length, (index) {
        final stageName = stages[index];
        final isCompleted = index < currentIndex || (currentStage == 'Completed' && index == stages.length - 1);
        final isCurrent = index == currentIndex && currentStage != 'Completed';

        // Custom station colors & icons
        Color nodeColor = AppColors.lightGray;
        Widget nodeWidget = const SizedBox();

        if (isCompleted) {
          nodeColor = const Color(0xFF16A34A);
          nodeWidget = const Icon(Icons.check_rounded, color: AppColors.white, size: 12);
        } else if (isCurrent) {
          nodeColor = AppColors.primaryRed;
          nodeWidget = Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          );
        } else {
          nodeColor = const Color(0xFFE5E7EB);
        }

        // Mock timestamps where applicable
        String? timestampStr;
        if (stageName == 'Project Assigned' && project.assignedDate != null) {
          timestampStr = _formatDate(project.assignedDate!);
        } else if (stageName == 'Completed' && project.completedAt != null) {
          timestampStr = _formatDate(project.completedAt!);
        } else if (isCompleted) {
          // generate fallback completed timestamps
          final offsetDays = index + 1;
          final dt = project.assignedDate?.add(Duration(days: offsetDays)) ?? DateTime.now();
          timestampStr = _formatDate(dt);
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Column: Train-station Track & Node
              Column(
                children: [
                  // Node
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: nodeColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent ? AppColors.primaryRed.withAlpha(50) : Colors.transparent,
                        width: isCurrent ? 4 : 0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: nodeWidget,
                  ),
                  // Track line (connector)
                  if (index < stages.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isCompleted ? const Color(0xFF16A34A) : const Color(0xFFE5E7EB),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              
              // Right Column: Station Details card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stageName,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 15,
                              color: isCurrent
                                  ? AppColors.black
                                  : isCompleted
                                      ? const Color(0xFF1F2937)
                                      : AppColors.mediumGray,
                              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                          if (timestampStr != null)
                            Text(
                              timestampStr,
                              style: AppTypography.bodySecondary.copyWith(
                                fontSize: 11,
                                color: isCompleted ? const Color(0xFF16A34A) : AppColors.mediumGray,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStageDescription(stageName),
                        style: AppTypography.bodySecondary.copyWith(
                          fontSize: 12,
                          color: isCurrent ? const Color(0xFF4B5563) : AppColors.mediumGray,
                        ),
                      ),
                      
                      // Render Admin Stage Actions in Timeline
                      if (isAdmin && isCurrent) ...[
                        const SizedBox(height: 12),
                        _buildAdminActions(context, stageName),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAdminActions(BuildContext context, String stageName) {
    if (stageName == 'Phase 1 Review') {
      return Row(
        children: [
          ElevatedButton.icon(
            onPressed: onRework,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 14, color: AppColors.white),
            label: Text(
              'Rework',
              style: AppTypography.label.copyWith(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onTesting,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.biotech_rounded, size: 14, color: AppColors.white),
            label: Text(
              'Testing',
              style: AppTypography.label.copyWith(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

    if (stageName == 'Rework') {
      return ElevatedButton.icon(
        onPressed: onReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Icon(Icons.rate_review_rounded, size: 14, color: AppColors.white),
        label: Text(
          'Back to Review',
          style: AppTypography.label.copyWith(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (stageName == 'Testing') {
      return ElevatedButton.icon(
        onPressed: onClosure,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Icon(Icons.lock_clock_rounded, size: 14, color: AppColors.white),
        label: Text(
          'Proceed to Closure',
          style: AppTypography.label.copyWith(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (stageName == 'Project Closure') {
      return ElevatedButton.icon(
        onPressed: onConfirmClosure,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF16A34A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.white),
        label: Text(
          'Confirm Project Completion',
          style: AppTypography.label.copyWith(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    return const SizedBox();
  }

  String _getStageDescription(String stageName) {
    switch (stageName) {
      case 'Project Assigned':
        return 'Project assigned to lead employee.';
      case 'Student Added':
        return 'At least one student record is mapped.';
      case 'Initial Process':
        return 'Initial student process logs are created.';
      case 'Student Work':
        return 'Active development processes in progress.';
      case 'Phase 1 Review':
        return 'Milestone submission awaiting admin review.';
      case 'Rework':
        return 'Rework requested. Resolve comments to progress.';
      case 'Testing':
        return 'Final product testing and verification.';
      case 'Project Closure':
        return 'Closure summary, validation checks and final sign-off.';
      case 'Completed':
        return 'Project locked. Deliverables finalized.';
      default:
        return '';
    }
  }

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }
}
