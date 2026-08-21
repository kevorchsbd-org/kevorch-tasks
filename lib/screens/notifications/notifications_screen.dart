import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../core/animations/app_animations.dart';
import 'notification_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final notifications = data.notifications;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Notifications",
              style: AppTypography.pageTitle.copyWith(fontSize: 20),
            ),
            actions: [
              if (data.hasUnreadNotifications)
                TextButton(
                  onPressed: () => data.markAllNotificationsAsRead(),
                  child: Text(
                    "Mark all as read",
                    style: AppTypography.label.copyWith(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: notifications.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return FadeSlideTransition(
                      delay: Duration(milliseconds: index * 60),
                      child: _NotificationCardItem(
                        item: item,
                        onTap: () {
                          data.markNotificationAsRead(item.id);
                          Navigator.of(context).push(
                            AppPageRoute.create(
                              NotificationDetailsScreen(notification: item),
                            ),
                          );
                        },
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
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.surfaceGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                color: AppColors.mediumGray,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You're all caught up!",
              style: AppTypography.cardTitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
          color: isUnread ? const Color(0xFFFEF2F2) : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnread
                ? AppColors.primaryRed.withAlpha(50)
                : AppColors.borderGray,
            width: isUnread ? 1.2 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isUnread
                    ? AppColors.primaryRed.withAlpha(25)
                    : AppColors.surfaceGray,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  color: isUnread ? AppColors.primaryRed : AppColors.mediumGray,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      Text(
                        item.timestamp,
                        style: AppTypography.label.copyWith(
                          fontSize: 11,
                          color: isUnread
                              ? AppColors.primaryRed
                              : AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: AppTypography.bodySecondary.copyWith(
                      fontSize: 12.5,
                      color: isUnread ? AppColors.black : AppColors.mediumGray,
                      height: 1.3,
                    ),
                  ),
                  if (item.subTitle != null && item.subTitle!.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 11,
                          color: isUnread
                              ? AppColors.primaryRed.withAlpha(180)
                              : AppColors.lightGray,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.subTitle!,
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              color: isUnread
                                  ? AppColors.primaryRed.withAlpha(200)
                                  : AppColors.lightGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
