import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/dummy_data.dart';
import '../data/models.dart';

class SuperAdminExecutiveOverview extends StatelessWidget {
  final DummyDataProvider provider;
  final Function(int)? onNavigateToTab;

  const SuperAdminExecutiveOverview({
    super.key,
    required this.provider,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final totalProjects = provider.totalProjects;
    final totalEmployees = provider.totalEmployees;
    final activeProjects = provider.projects.where((p) => p.status != ProjectStatus.completed).length;
    final completedProjects = provider.projects.where((p) => p.status == ProjectStatus.completed).length;

    // Secondary Operational Metrics
    final reviewPending = provider.projects.where((p) => p.status == ProjectStatus.phase1Review).length;
    final closureRequests = provider.projects.where((p) => p.status == ProjectStatus.closure || p.closureRequestedAt != null).length;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFAFAFA),
            const Color(0xFFFEF2F2).withValues(alpha: 0.35),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OVERVIEW',
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mediumGray,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'System-wide project overview',
                          style: AppTypography.bodySecondary.copyWith(
                            fontSize: 12,
                            color: AppColors.mediumGray.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'EXECUTIVE',
                        style: AppTypography.label.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Primary Metrics Layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 550;
                    if (isWide) {
                      return Row(
                        children: [
                          Expanded(child: _buildMetricTile("Total Projects", "$totalProjects", AppColors.black, () => onNavigateToTab?.call(2))),
                          _buildVerticalDivider(),
                          Expanded(child: _buildMetricTile("Total Employees", "$totalEmployees", AppColors.black, () => onNavigateToTab?.call(3))),
                          _buildVerticalDivider(),
                          Expanded(child: _buildMetricTile("Active Projects", "$activeProjects", AppColors.primaryRed, () => onNavigateToTab?.call(2))),
                          _buildVerticalDivider(),
                          Expanded(child: _buildMetricTile("Completed", "$completedProjects", AppColors.successGreen, () => onNavigateToTab?.call(2))),
                        ],
                      );
                    } else {
                      // 2 x 2 compact mobile metric grid
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildMetricTile("Total Projects", "$totalProjects", AppColors.black, () => onNavigateToTab?.call(2))),
                              const SizedBox(width: 12),
                              Expanded(child: _buildMetricTile("Total Employees", "$totalEmployees", AppColors.black, () => onNavigateToTab?.call(3))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildMetricTile("Active Projects", "$activeProjects", AppColors.primaryRed, () => onNavigateToTab?.call(2))),
                              const SizedBox(width: 12),
                              Expanded(child: _buildMetricTile("Completed", "$completedProjects", AppColors.successGreen, () => onNavigateToTab?.call(2))),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),

                // Secondary Operational Metrics (if present)
                if (reviewPending > 0 || closureRequests > 0) ...[
                  const SizedBox(height: 18),
                  Container(
                    height: 1,
                    color: AppColors.borderGray.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (reviewPending > 0) ...[
                        _buildSecondaryBadge("Review Pending", "$reviewPending", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
                        const SizedBox(width: 10),
                      ],
                      if (closureRequests > 0) ...[
                        _buildSecondaryBadge("Closure Requests", "$closureRequests", const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
                      ],
                    ],
                  ),
                ],

                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: AppColors.borderGray.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),

                // Project Stage Summary Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PROJECT STATUS',
                      style: AppTypography.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mediumGray,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '${provider.projects.length} Total',
                      style: AppTypography.bodySecondary.copyWith(
                        fontSize: 11,
                        color: AppColors.lightGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _buildStageSummaryList(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color valueColor, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.padLeft(2, '0'),
            style: AppTypography.pageTitle.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.label.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.mediumGray,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 38,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: AppColors.borderGray.withValues(alpha: 0.6),
    );
  }

  Widget _buildSecondaryBadge(String label, String count, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: textColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageSummaryList(DummyDataProvider provider) {
    final stages = ProjectStatus.all;

    // Filter stages according to rules: hide operational stages with 0 count, show completed if completed > 0
    final stageItems = <Widget>[];

    for (final stage in stages) {
      final count = provider.projects.where((p) => p.status == stage).length;
      if (count == 0 && stage != ProjectStatus.completed) {
        continue;
      }
      if (count == 0 && stage == ProjectStatus.completed) {
        continue;
      }

      final label = ProjectStatus.getLabel(stage);
      Color dotColor = AppColors.mediumGray;
      if (stage == ProjectStatus.completed) {
        dotColor = AppColors.successGreen;
      } else if (stage == ProjectStatus.phase1Review || stage == ProjectStatus.rework) {
        dotColor = AppColors.primaryRed;
      } else if (stage == ProjectStatus.inProgress || stage == ProjectStatus.testing) {
        dotColor = const Color(0xFF2563EB);
      }

      stageItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: dotColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString().padLeft(2, '0'),
                  style: AppTypography.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: dotColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (stageItems.isEmpty) {
      return Text(
        "No active stage data",
        style: AppTypography.bodySecondary.copyWith(fontSize: 12),
      );
    }

    return Column(
      children: stageItems,
    );
  }
}
