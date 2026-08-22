import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;
  final double fontSize;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (priority.toLowerCase()) {
      case 'urgent':
      case 'high':
        bg = AppColors.dangerLight;
        fg = AppColors.danger;
        icon = Icons.flag_rounded;
        break;
      case 'medium':
        bg = AppColors.warningLight;
        fg = const Color(0xFFD97706);
        icon = Icons.flag_outlined;
        break;
      case 'low':
      default:
        bg = AppColors.infoLight;
        fg = const Color(0xFF2563EB);
        icon = Icons.flag_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 1, color: fg),
          const SizedBox(width: 3),
          Text(
            priority,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
