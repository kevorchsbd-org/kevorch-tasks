import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/employee_notification_card.dart';
import 'employee_task_details_screen.dart';
import 'employee_project_details_screen.dart';

class EmployeeNotificationsScreen extends StatelessWidget {
  final EmployeeModel loggedInEmployee;

  const EmployeeNotificationsScreen({
    super.key,
    required this.loggedInEmployee,
  });

  void _handleNotificationTap(BuildContext context, NotificationItemModel notification) {
    final provider = DummyDataProvider();
    provider.markNotificationAsRead(notification.id);

    if (notification.relatedTaskId != null) {
      final task = provider.getTaskById(notification.relatedTaskId!);
      if (task != null) {
        Navigator.push(
          context,
          AppPageRoute.create(
            EmployeeTaskDetailsScreen(
              task: task,
              loggedInEmployee: loggedInEmployee,
            ),
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
            EmployeeProjectDetailsScreen(
              project: project,
              loggedInEmployee: loggedInEmployee,
            ),
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final notifications = provider.getEmployeeNotifications(loggedInEmployee.id);
        final hasUnread = provider.hasUnreadEmployeeNotifications(loggedInEmployee.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Notifications",
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            actions: [
              if (hasUnread)
                TextButton(
                  onPressed: () => provider.markAllEmployeeNotificationsAsRead(loggedInEmployee.id),
                  child: Text(
                    "Mark all read",
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.border, height: 1),
            ),
          ),
          body: notifications.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 40,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No notifications yet",
                          style: AppTypography.cardTitle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Assignments and task updates will appear here",
                          style: AppTypography.bodySecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return FadeSlideTransition(
                      delay: Duration(milliseconds: 50 * index),
                      child: EmployeeNotificationCard(
                        notification: item,
                        onTap: () => _handleNotificationTap(context, item),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
