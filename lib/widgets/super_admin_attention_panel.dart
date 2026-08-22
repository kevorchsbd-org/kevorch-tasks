import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/dummy_data.dart';
import '../data/models.dart';

class SuperAdminAttentionItem {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeTextColor;
  final Color badgeBgColor;
  final VoidCallback? onTap;

  SuperAdminAttentionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeTextColor,
    required this.badgeBgColor,
    this.onTap,
  });
}

class SuperAdminAttentionPanel extends StatelessWidget {
  final DummyDataProvider provider;
  final Function(int)? onNavigateToTab;

  const SuperAdminAttentionPanel({
    super.key,
    required this.provider,
    this.onNavigateToTab,
  });

  List<SuperAdminAttentionItem> _getAttentionItems() {
    final List<SuperAdminAttentionItem> items = [];

    // 1. Projects pending review
    final reviewProjects = provider.projects.where((p) => p.status == ProjectStatus.phase1Review).toList();
    for (final p in reviewProjects) {
      final empName = p.assignedEmployee ?? 'Unassigned';
      items.add(
        SuperAdminAttentionItem(
          id: 'review_${p.id}',
          title: p.projectName,
          subtitle: 'Phase 1 Review pending • Lead: $empName',
          badgeText: 'REVIEW PENDING',
          badgeTextColor: const Color(0xFFD97706),
          badgeBgColor: const Color(0xFFFEF3C7),
          onTap: () => onNavigateToTab?.call(2),
        ),
      );
    }

    // 2. Projects in Rework
    final reworkProjects = provider.projects.where((p) => p.status == ProjectStatus.rework).toList();
    for (final p in reworkProjects) {
      final empName = p.assignedEmployee ?? 'Unassigned';
      items.add(
        SuperAdminAttentionItem(
          id: 'rework_${p.id}',
          title: p.projectName,
          subtitle: 'Rework in progress • Lead: $empName',
          badgeText: 'REWORK',
          badgeTextColor: AppColors.primaryRed,
          badgeBgColor: AppColors.primaryRedLight,
          onTap: () => onNavigateToTab?.call(2),
        ),
      );
    }

    // 3. Projects in Closure / Closure ready
    final closureProjects = provider.projects.where(
      (p) => p.status == ProjectStatus.closure || p.closureRequestedAt != null,
    ).toList();
    for (final p in closureProjects) {
      final empName = p.assignedEmployee ?? 'Unassigned';
      items.add(
        SuperAdminAttentionItem(
          id: 'closure_${p.id}',
          title: p.projectName,
          subtitle: 'Awaiting final closure verification • Lead: $empName',
          badgeText: 'CLOSURE',
          badgeTextColor: const Color(0xFF4F46E5),
          badgeBgColor: const Color(0xFFEEF2FF),
          onTap: () => onNavigateToTab?.call(2),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final attentionItems = _getAttentionItems();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
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
                "ATTENTION REQUIRED",
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  letterSpacing: 0.5,
                ),
              ),
              if (attentionItems.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRedLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${attentionItems.length} ACTIONABLE",
                    style: AppTypography.label.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          if (attentionItems.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.successGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All caught up",
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "No projects currently require attention",
                          style: AppTypography.bodySecondary.copyWith(
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attentionItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = attentionItems[index];
                return GestureDetector(
                  onTap: item.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderGray,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTypography.body.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.subtitle,
                                style: AppTypography.bodySecondary.copyWith(
                                  fontSize: 11.5,
                                  color: AppColors.mediumGray,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.badgeBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.badgeText,
                            style: AppTypography.label.copyWith(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: item.badgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
