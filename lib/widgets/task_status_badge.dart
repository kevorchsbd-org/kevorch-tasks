import 'package:flutter/material.dart';

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
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF6B7280);
        break;
      case 'IN PROGRESS':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        break;
      case 'REVIEW':
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        break;
      case 'REWORK':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        break;
      case 'TESTING':
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        break;
      case 'DONE':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF16A34A);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
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
