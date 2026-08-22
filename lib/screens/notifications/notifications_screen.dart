import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../core/animations/app_animations.dart';
import 'notification_details_screen.dart';
import '../tasks/task_details_screen.dart';
import '../projects/project_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _handleNotificationTap(BuildContext context, NotificationItemModel notification) {
    final provider = DummyDataProvider();
    provider.markNotificationAsRead(notification.id);

    if (notification.relatedTaskId != null) {
      final task = provider.getTaskById(notification.relatedTaskId!);
      if (task != null) {
        Navigator.push(
          context,
          AppPageRoute.create(
            TaskDetailsScreen(task: task),
          ),
        );
        return;
      }
    }

    if (notification.relatedProjectId != null) {
      final project = provider.getProjectById(notification.relatedProjectId!);
      if (project != null) {
        Navigator.push(
          context,
          AppPageRoute.create(
            ProjectDetailsScreen(projectId: project.id),
          ),
        );
        return;
      }
    }

    Navigator.push(
      context,
      AppPageRoute.create(
        NotificationDetailsScreen(notification: notification),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final notifications = data.notifications;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Notifications",
              style: AppTypography.pageTitle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              if (data.hasUnreadNotifications)
                TextButton(
                  onPressed: () => data.markAllNotificationsAsRead(),
                  child: Text(
                    "Mark all as read",
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.border, height: 1),
            ),
          ),
          body: notifications.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return FadeSlideTransition(
                      delay: Duration(milliseconds: 40 * index),
                      child: _NotificationCardItem(
                        item: item,
                        onTap: () => _handleNotificationTap(context, item),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textMuted,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You're all caught up!",
              style: AppTypography.cardTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "No new notifications",
              style: AppTypography.bodySecondary.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCardItem extends StatelessWidget {
  final NotificationItemModel item;
  final VoidCallback onTap;

  const _NotificationCardItem({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !item.isRead;

    return ScaleTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.primaryLight.withAlpha(120) : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnread ? AppColors.primary.withAlpha(60) : AppColors.border,
            width: isUnread ? 1.2 : 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUnread ? AppColors.primaryLight : AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getNotificationIcon(item.title),
                color: isUnread ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: AppTypography.bodySecondary.copyWith(fontSize: 12.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.timestamp,
                    style: AppTypography.label.copyWith(fontSize: 10.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('task')) return Icons.assignment_outlined;
    if (t.contains('project')) return Icons.folder_open_rounded;
    if (t.contains('employee')) return Icons.person_outline_rounded;
    return Icons.notifications_none_rounded;
  }
}
