import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/dummy_data.dart';

class SuperAdminActivityItem {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final String? projectId;
  final String? employeeId;
  final DateTime timestamp;
  final IconData icon;

  SuperAdminActivityItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.projectId,
    this.employeeId,
    required this.timestamp,
    required this.icon,
  });
}

class SuperAdminActivityPanel extends StatelessWidget {
  final DummyDataProvider provider;

  const SuperAdminActivityPanel({
    super.key,
    required this.provider,
  });

  List<SuperAdminActivityItem> _getNormalizedActivities() {
    final List<SuperAdminActivityItem> items = [];

    // 1. Student Submissions
    final submissions = provider.getAllSubmittedStudentSubmissions();
    for (final s in submissions) {
      final projName = provider.getProjectById(s.projectId)?.projectName ?? 'Project';
      final empName = provider.getEmployeeById(s.employeeId)?.employeeName ?? 'Employee';
      final dt = s.submittedAt ?? s.createdAt;
      items.add(
        SuperAdminActivityItem(
          id: 'sub_${s.id}',
          type: 'submission',
          title: 'Student Record Submitted: ${s.studentName}',
          subtitle: '$projName • By $empName',
          projectId: s.projectId,
          employeeId: s.employeeId,
          timestamp: dt,
          icon: Icons.assignment_turned_in_rounded,
        ),
      );
    }

    // 2. Student Processes
    final processes = provider.getAllSubmittedStudentProcesses()
        .where((p) => p.status == 'SUBMITTED')
        .toList();
    for (final p in processes) {
      final projName = provider.getProjectById(p.projectId)?.projectName ?? 'Project';
      final empName = provider.getEmployeeById(p.employeeId)?.employeeName ?? 'Employee';
      final dt = p.submittedAt ?? p.createdAt;
      items.add(
        SuperAdminActivityItem(
          id: 'proc_${p.id}',
          type: 'process',
          title: 'Process Logged: ${p.title}',
          subtitle: 'Student: ${p.studentName} • $projName ($empName)',
          projectId: p.projectId,
          employeeId: p.employeeId,
          timestamp: dt,
          icon: Icons.rocket_launch_rounded,
        ),
      );
    }

    // 3. System Notifications / Events
    for (final n in provider.notifications) {
      // Parse eventDateTime or fallback
      DateTime dt = DateTime.now();
      if (n.eventDateTime != null && n.eventDateTime!.isNotEmpty) {
        dt = _parseEventDateTime(n.eventDateTime!) ?? DateTime.now().subtract(const Duration(hours: 2));
      }
      items.add(
        SuperAdminActivityItem(
          id: 'notif_${n.id}',
          type: 'notification',
          title: n.title,
          subtitle: n.message.isNotEmpty ? n.message : n.subTitle,
          projectId: n.relatedProjectId,
          employeeId: n.relatedEmployeeId,
          timestamp: dt,
          icon: n.icon,
        ),
      );
    }

    // Sort descending by timestamp
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Limit to top 6 items
    return items.take(6).toList();
  }

  DateTime? _parseEventDateTime(String str) {
    try {
      // Example format: "21 Aug 2026 • 10:25 AM"
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
    final activities = _getNormalizedActivities();

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
                "RECENT ACTIVITY",
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "LIVE FEED",
                  style: AppTypography.label.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (activities.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "No recent activity",
                  style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  height: 1,
                  color: AppColors.borderGray.withValues(alpha: 0.5),
                ),
              ),
              itemBuilder: (context, index) {
                final item = activities[index];
                Color iconBg = AppColors.surfaceGray;
                Color iconColor = AppColors.darkGray;

                if (item.type == 'submission') {
                  iconBg = const Color(0xFFDCFCE7);
                  iconColor = AppColors.successGreen;
                } else if (item.type == 'process') {
                  iconBg = const Color(0xFFEFF6FF);
                  iconColor = const Color(0xFF2563EB);
                } else if (item.type == 'notification') {
                  iconBg = AppColors.primaryRedLight.withValues(alpha: 0.6);
                  iconColor = AppColors.primaryRed;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: iconColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
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
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle!,
                              style: AppTypography.bodySecondary.copyWith(
                                fontSize: 11.5,
                                color: AppColors.mediumGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimeAgo(item.timestamp),
                      style: AppTypography.label.copyWith(
                        fontSize: 10.5,
                        color: AppColors.lightGray,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
