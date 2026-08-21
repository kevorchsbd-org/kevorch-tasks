import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class SuperAdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SuperAdminBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.grid_view_rounded, 'label': 'Dashboard'},
      {'icon': Icons.admin_panel_settings_outlined, 'label': 'Admins'},
      {'icon': Icons.folder_open_rounded, 'label': 'Projects'},
      {'icon': Icons.people_outline_rounded, 'label': 'Employees'},
      {'icon': Icons.assignment_outlined, 'label': 'Tasks'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderGray, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SafeArea(
        child: Row(
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            final item = items[index];

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRedLight.withAlpha(128)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isSelected ? AppColors.primaryRed : AppColors.mediumGray,
                        size: 20,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item['label'] as String,
                        style: AppTypography.navigation.copyWith(
                          fontSize: 9,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryRed : AppColors.mediumGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
