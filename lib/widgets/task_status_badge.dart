import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class TaskStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const TaskStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toUpperCase()) {
      case 'TO DO':
        bg = AppColors.surfaceGray;
        fg = AppColors.textSecondary;
        break;
      case 'IN PROGRESS':
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        break;
      case 'REVIEW':
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        break;
      case 'REWORK':
        bg = AppColors.warningLight;
        fg = const Color(0xFFD97706);
        break;
      case 'TESTING':
        bg = AppColors.infoLight;
        fg = AppColors.info;
        break;
      case 'DONE':
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      default:
        bg = AppColors.surfaceGray;
        fg = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withAlpha(50), width: 0.8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
