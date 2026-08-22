import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/dummy_data.dart';
import '../data/models.dart';
import '../screens/projects/project_details_screen.dart';
import 'student_submission_read_only_view.dart';

class SuperAdminPulseActivityItem {
  final String id;
  final String type; // 'submission', 'process', 'notification'
  final String title;
  final String? subtitle;
  final DateTime timestamp;
  final String? projectId;
  final String? sourceEntityId;
  final StudentSubmissionModel? submission;

  SuperAdminPulseActivityItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.timestamp,
    this.projectId,
    this.sourceEntityId,
    this.submission,
  });
}

class SuperAdminPulseWorkflowItem {
  final ProjectModel project;
  final String stageLabel;
  final String contextMessage;
  final Color dotColor;
  final int priorityRank;

  SuperAdminPulseWorkflowItem({
    required this.project,
    required this.stageLabel,
    required this.contextMessage,
    required this.dotColor,
    required this.priorityRank,
  });
}

class SuperAdminOperationsPulse extends StatelessWidget {
  final DummyDataProvider provider;
  final Function(int)? onNavigateToTab;

  const SuperAdminOperationsPulse({
    super.key,
    required this.provider,
    this.onNavigateToTab,
  });

  List<SuperAdminPulseWorkflowItem> _getPriorityAttentionItems() {
    final List<SuperAdminPulseWorkflowItem> items = [];

    for (final p in provider.projects) {
      if (p.status == ProjectStatus.completed) continue;

      if (p.status == ProjectStatus.rework) {
        items.add(
          SuperAdminPulseWorkflowItem(
            project: p,
            stageLabel: "Rework",
            contextMessage: "Changes require attention",
            dotColor: AppColors.primaryRed,
            priorityRank: 1,
          ),
        );
      } else if (p.status == ProjectStatus.phase1Review) {
        items.add(
          SuperAdminPulseWorkflowItem(
            project: p,
            stageLabel: "Phase 1 Review",
            contextMessage: "Waiting for review",
            dotColor: const Color(0xFFD97706),
            priorityRank: 2,
          ),
        );
      } else if (p.status == ProjectStatus.closure || p.closureRequestedAt != null) {
        items.add(
          SuperAdminPulseWorkflowItem(
            project: p,
            stageLabel: "Project Closure",
            contextMessage: "Ready for closure",
            dotColor: const Color(0xFF4F46E5),
            priorityRank: 3,
          ),
        );
      } else if (p.status == ProjectStatus.testing) {
        items.add(
          SuperAdminPulseWorkflowItem(
            project: p,
            stageLabel: "Testing",
            contextMessage: "Testing currently in progress",
            dotColor: const Color(0xFF2563EB),
            priorityRank: 4,
          ),
        );
      }
    }

    items.sort((a, b) => a.priorityRank.compareTo(b.priorityRank));
    return items.take(4).toList();
  }

  SuperAdminPulseActivityItem? _getRecentUpdate() {
    final List<SuperAdminPulseActivityItem> items = [];

    // 1. Student Submissions
    final submissions = provider.getAllSubmittedStudentSubmissions();
    for (final s in submissions) {
      final projName = provider.getProjectById(s.projectId)?.projectName ?? 'Project';
      final dt = s.submittedAt ?? s.createdAt;
      items.add(
        SuperAdminPulseActivityItem(
          id: 'sub_${s.id}',
          type: 'submission',
          title: 'Student Record Submitted: ${s.studentName}',
          subtitle: '$projName • ${_formatTimeAgo(dt)}',
          timestamp: dt,
          projectId: s.projectId,
          sourceEntityId: s.id,
          submission: s,
        ),
      );
    }

    // 2. Student Processes
    final processes = provider.getAllSubmittedStudentProcesses()
        .where((p) => p.status == 'SUBMITTED')
        .toList();
    for (final p in processes) {
      final projName = provider.getProjectById(p.projectId)?.projectName ?? 'Project';
      final dt = p.submittedAt ?? p.createdAt;
      items.add(
        SuperAdminPulseActivityItem(
          id: 'proc_${p.id}',
          type: 'process',
          title: 'Process Logged: ${p.title}',
          subtitle: '$projName • ${_formatTimeAgo(dt)}',
          timestamp: dt,
          projectId: p.projectId,
          sourceEntityId: p.id,
        ),
      );
    }

    // 3. Notifications (with duplicate suppression if refers to already logged submission/process)
    for (final n in provider.notifications) {
      DateTime dt = DateTime.now();
      if (n.eventDateTime != null && n.eventDateTime!.isNotEmpty) {
        dt = _parseEventDateTime(n.eventDateTime!) ?? DateTime.now().subtract(const Duration(hours: 2));
      }

      // Check duplicate
      final isDuplicate = items.any((existing) =>
          existing.projectId == n.relatedProjectId &&
          existing.timestamp.difference(dt).inMinutes.abs() < 10);

      if (!isDuplicate) {
        items.add(
          SuperAdminPulseActivityItem(
            id: 'notif_${n.id}',
            type: 'notification',
            title: n.title,
            subtitle: '${n.subTitle ?? "System Event"} • ${_formatTimeAgo(dt)}',
            timestamp: dt,
            projectId: n.relatedProjectId,
            sourceEntityId: n.id,
          ),
        );
      }
    }

    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items.isNotEmpty ? items.first : null;
  }

  DateTime? _parseEventDateTime(String str) {
    try {
      final parts = str.split('•');
      if (parts.isNotEmpty) {
        final datePart = parts[0].trim();
        final dateBits = datePart.split(' ');
        if (dateBits.length >= 3) {
          final day = int.tryParse(dateBits[0]) ?? 21;
          final monthStr = dateBits[1];
          final year = int.tryParse(dateBits[2]) ?? 2026;
          const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
          final month = months.indexOf(monthStr) + 1;
          return DateTime(year, month > 0 ? month : 8, day);
        }
      }
    } catch (_) {}
    return null;
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    const months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return '${dt.day} ${months[dt.month]}';
  }

  @override
  Widget build(BuildContext context) {
    final attentionItems = _getPriorityAttentionItems();
    final recentUpdate = _getRecentUpdate();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFAFAFA),
            const Color(0xFFFEF2F2).withValues(alpha: 0.4),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (OPERATIONS PULSE | CURRENT badge)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OPERATIONS PULSE',
                            style: AppTypography.label.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'What needs your attention right now',
                            style: AppTypography.bodySecondary.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF8A8F9C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGray,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'CURRENT',
                            style: AppTypography.label.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Priority Workflow Items Section
                if (attentionItems.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.successGreen,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Everything is on track",
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "No projects currently require your attention.",
                                style: AppTypography.bodySecondary.copyWith(
                                  fontSize: 11.5,
                                  color: const Color(0xFF8A8F9C),
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
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = attentionItems[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProjectDetailsScreen(projectId: item.project.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: item.dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.stageLabel,
                                        style: AppTypography.label.copyWith(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.mediumGray,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item.project.projectName,
                                        style: AppTypography.body.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item.contextMessage,
                                        style: AppTypography.bodySecondary.copyWith(
                                          fontSize: 11.5,
                                          color: const Color(0xFF8A8F9C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.lightGray,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Recent Update Subsection (if timestamped activity exists)
                if (recentUpdate != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    height: 1,
                    color: AppColors.borderGray.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RECENT UPDATE',
                        style: AppTypography.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mediumGray,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (recentUpdate.type == 'submission' && recentUpdate.submission != null) {
                          StudentSubmissionReadOnlyView.show(context, recentUpdate.submission!);
                        } else if (recentUpdate.projectId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailsScreen(projectId: recentUpdate.projectId!),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceGray,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                recentUpdate.type == 'submission'
                                    ? Icons.assignment_turned_in_rounded
                                    : (recentUpdate.type == 'process'
                                        ? Icons.rocket_launch_rounded
                                        : Icons.notifications_none_rounded),
                                color: AppColors.darkGray,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recentUpdate.title,
                                    style: AppTypography.body.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (recentUpdate.subtitle != null) ...[
                                    const SizedBox(height: 1),
                                    Text(
                                      recentUpdate.subtitle!,
                                      style: AppTypography.bodySecondary.copyWith(
                                        fontSize: 11.5,
                                        color: const Color(0xFF8A8F9C),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (recentUpdate.submission != null || recentUpdate.projectId != null)
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.lightGray,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
