import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/employee_notification_card.dart';
import 'employee_notifications_screen.dart';
import 'employee_task_details_screen.dart';
import 'employee_project_details_screen.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  final EmployeeModel loggedInEmployee;
  final Function(int)? onNavigateToTab;

  const EmployeeDashboardScreen({
    super.key,
    required this.loggedInEmployee,
    this.onNavigateToTab,
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

        final previewNotifications = notifications.take(3).toList();

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header (Avatar, Name, Role badge, Notification Bell with badge)
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 50),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderGray, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              loggedInEmployee.initials,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
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
                                  Flexible(
                                    child: Text(
                                      loggedInEmployee.employeeName,
                                      style: AppTypography.pageTitle.copyWith(
                                        fontSize: 18,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceGray,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppColors.borderGray),
                                    ),
                                    child: Text(
                                      "EMPLOYEE",
                                      style: AppTypography.label.copyWith(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.darkGray,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                loggedInEmployee.role,
                                style: AppTypography.bodySecondary.copyWith(
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Notification Bell Button
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderGray),
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: AppColors.black,
                                  size: 22,
                                ),
                                constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    AppPageRoute.create(
                                      EmployeeNotificationsScreen(
                                        loggedInEmployee: loggedInEmployee,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (hasUnread)
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDC2626), // Spec Red #DC2626
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Admin Notifications
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Notifications",
                              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  AppPageRoute.create(
                                    EmployeeNotificationsScreen(
                                      loggedInEmployee: loggedInEmployee,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "See All",
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (previewNotifications.isEmpty)
                          _buildEmptyState("No recent notifications")
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: previewNotifications.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = previewNotifications[index];
                              return EmployeeNotificationCard(
                                notification: item,
                                onTap: () => _handleNotificationTap(context, item),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGray, width: 0.8),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTypography.bodySecondary.copyWith(fontSize: 13),
        ),
      ),
    );
  }
}
