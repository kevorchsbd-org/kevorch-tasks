import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../screens/monitoring/monitoring_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../core/animations/app_animations.dart';

class AdminSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const AdminSidebar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.grid_view_rounded, 'label': 'Dashboard'},
      {'icon': Icons.folder_open_rounded, 'label': 'Projects'},
      {'icon': Icons.people_outline_rounded, 'label': 'Employees'},
      {'icon': Icons.assignment_outlined, 'label': 'Tasks'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Brand Logo
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "K",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kevorch Tasks",
                      style: AppTypography.cardTitle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "ADMIN PORTAL",
                            style: AppTypography.label.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "NAVIGATION",
              style: AppTypography.label.copyWith(
                fontSize: 10.5,
                color: AppColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Navigation Links
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final isSelected = currentIndex == index;
                final item = navItems[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () => onTabSelected(index),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item['label'] as String,
                            style: AppTypography.body.copyWith(
                              fontSize: 13.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // Secondary Utilities
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: const Icon(Icons.insert_chart_outlined_rounded, color: AppColors.textSecondary, size: 20),
                  title: Text(
                    "Monitoring",
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.textPrimary),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      AppPageRoute.create(const MonitoringScreen()),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 20),
                  title: Text(
                    "Notifications",
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.textPrimary),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      AppPageRoute.create(const NotificationsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
