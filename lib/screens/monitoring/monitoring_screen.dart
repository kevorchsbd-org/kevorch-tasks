import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Monitoring",
          style: AppTypography.sectionTitle,
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AnimatedBuilder(
        animation: DummyDataProvider(),
        builder: (context, _) {
          final data = DummyDataProvider();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monitoring Breakdown",
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 14),
                
                // Item 1: Projects Overview
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 200),
                  child: _buildMonitoringTile(
                    icon: Icons.folder_copy_outlined,
                    title: "Projects Overview",
                    subtitle: "${data.totalProjects} active projects across ${data.projects.map((p) => p.domain).toSet().length} domains",
                    countLabel: "${data.totalProjects} Projects",
                  ),
                ),
                const SizedBox(height: 12),

                // Item 2: Employees Overview
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 300),
                  child: _buildMonitoringTile(
                    icon: Icons.people_outline_rounded,
                    title: "Employees & Resources",
                    subtitle: "${data.totalEmployees} registered team members fully assigned",
                    countLabel: "${data.totalEmployees} Active",
                  ),
                ),
                const SizedBox(height: 12),

                // Item 3: Tasks Tracking
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 400),
                  child: _buildMonitoringTile(
                    icon: Icons.assignment_outlined,
                    title: "Tasks Tracking",
                    subtitle: "${data.totalTasks} total tasks logged across projects",
                    countLabel: "${data.totalTasks} Tasks",
                  ),
                ),
                const SizedBox(height: 12),

                // Item 4: Due Dates Timeline
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 500),
                  child: _buildMonitoringTile(
                    icon: Icons.access_time_rounded,
                    title: "Upcoming Due Dates",
                    subtitle: "Next upcoming deadline: ${data.tasks.isNotEmpty ? data.tasks.first.dueDate : 'N/A'}",
                    countLabel: "On Track",
                    badgeColor: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonitoringTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String countLabel,
    Color badgeColor = AppColors.primaryRed,
  }) {
    return Container(
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderGray),
            ),
            child: Icon(icon, color: AppColors.black, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.bodySecondary.copyWith(fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              countLabel,
              style: AppTypography.label.copyWith(
                fontSize: 12,
                color: badgeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
