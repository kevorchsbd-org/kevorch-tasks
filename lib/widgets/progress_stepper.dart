import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class ProgressStepper extends StatelessWidget {
  final String currentStatus;

  const ProgressStepper({
    super.key,
    required this.currentStatus,
  });

  static const List<String> steps = [
    'TO DO',
    'IN PROGRESS',
    'REVIEW',
    'REWORK',
    'DONE',
  ];

  int _getStepIndex(String status) {
    switch (status.toUpperCase()) {
      case 'TO DO':
        return 0;
      case 'IN PROGRESS':
        return 1;
      case 'REVIEW':
        return 2;
      case 'REWORK':
        return 3;
      case 'TESTING':
        return 2; // Map TESTING under Review/QA phase visually
      case 'DONE':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _getStepIndex(currentStatus);
    final isRework = currentStatus.toUpperCase() == 'REWORK';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
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
              Text(
                "Task Execution Workflow",
                style: AppTypography.label.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.textMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isRework
                      ? AppColors.warningLight
                      : (activeIndex == 4
                          ? AppColors.successLight
                          : AppColors.primaryLight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentStatus.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isRework
                        ? AppColors.warning
                        : (activeIndex == 4
                            ? AppColors.success
                            : AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length, (index) {
              final stepName = steps[index];
              final isCompleted = index < activeIndex || activeIndex == 4;
              final isCurrent = index == activeIndex;
              final isStepRework = stepName == 'REWORK' && isRework;

              Color stepColor;
              if (isStepRework) {
                stepColor = AppColors.warning;
              } else if (isCurrent) {
                stepColor = activeIndex == 4 ? AppColors.success : AppColors.primary;
              } else if (isCompleted) {
                stepColor = AppColors.success;
              } else {
                stepColor = AppColors.border;
              }

              return Expanded(
                child: Row(
                  children: [
                    // Step Indicator Circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (isCurrent || isCompleted || isStepRework)
                            ? stepColor
                            : AppColors.surfaceGray,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: stepColor,
                          width: (isCurrent || isStepRework) ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: isCompleted && !isCurrent
                            ? const Icon(Icons.check, size: 13, color: AppColors.white)
                            : (isStepRework
                                ? const Icon(Icons.refresh_rounded,
                                    size: 13, color: AppColors.white)
                                : Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: (isCurrent || isStepRework)
                                          ? AppColors.white
                                          : AppColors.textMuted,
                                    ),
                                  )),
                      ),
                    ),
                    // Line separator (if not last)
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: (index < activeIndex)
                              ? AppColors.success
                              : AppColors.border,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Step Labels Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final isCurrent = index == activeIndex;
              final stepName = steps[index];
              return SizedBox(
                width: 50,
                child: Text(
                  stepName,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    fontSize: 9.5,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent
                        ? (isRework
                            ? AppColors.warning
                            : (index == 4 ? AppColors.success : AppColors.primary))
                        : AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
