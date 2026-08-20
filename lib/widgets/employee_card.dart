import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/models.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeCard({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderGray, width: 1),
            ),
            child: Center(
              child: Text(
                employee.initials,
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
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
                  employee.employeeName,
                  style: AppTypography.cardTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  employee.email,
                  style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Text(
                    employee.role,
                    style: AppTypography.label.copyWith(
                      fontSize: 12,
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.lightGray,
          ),
        ],
      ),
    );
  }
}
