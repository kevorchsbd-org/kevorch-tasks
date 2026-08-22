import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/task_status_badge.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/employee_notification_card.dart';
import '../../widgets/employee_project_snapshot.dart';
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

        final employeeTasks = provider.getTasksByEmployee(loggedInEmployee.employeeName);

        // KPI Counts
        final assignedCount = employeeTasks.where((t) => t.status.toUpperCase() == 'TO DO').length;
        final inProgressCount = employeeTasks.where((t) => t.status.toUpperCase() == 'IN PROGRESS').length;
        final reviewCount = employeeTasks.where((t) => t.status.toUpperCase() == 'REVIEW' || t.status.toUpperCase() == 'REWORK' || t.status.toUpperCase() == 'TESTING').length;
        final completedCount = employeeTasks.where((t) => t.status.toUpperCase() == 'DONE').length;

        // Priority Active Task (First non-completed task or IN PROGRESS / REWORK)
        TaskModel? activeTask;
        if (employeeTasks.isNotEmpty) {
          final nonDone = employeeTasks.where((t) => t.status.toUpperCase() != 'DONE').toList();
          if (nonDone.isNotEmpty) {
            activeTask = nonDone.firstWhere(
              (t) => t.status.toUpperCase() == 'IN PROGRESS' || t.status.toUpperCase() == 'REWORK',
              orElse: () => nonDone.first,
            );
          } else {
            activeTask = employeeTasks.first;
          }
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Compact Welcome Header with Employee ID subtle badge
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 50),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            loggedInEmployee.initials,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Subtle Employee ID Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.primary.withAlpha(50), width: 0.8),
                                    ),
                                    child: Text(
                                      loggedInEmployee.id,
                                      style: AppTypography.label.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
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
                        // Notification Bell Icon Button
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: AppColors.textPrimary,
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
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.danger,
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

                  const SizedBox(height: 20),

                  // 2. 4 Compact KPI Cards
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        KpiCard(
                          label: "Assigned",
                          count: "$assignedCount",
                          icon: Icons.checklist_rounded,
                          iconColor: AppColors.textSecondary,
                          accentBg: AppColors.surfaceGray,
                          onTap: () => onNavigateToTab?.call(2),
                        ),
                        KpiCard(
                          label: "In Progress",
                          count: "$inProgressCount",
                          icon: Icons.play_circle_outline_rounded,
                          iconColor: AppColors.primary,
                          accentBg: AppColors.primaryLight,
                          onTap: () => onNavigateToTab?.call(2),
                        ),
                        KpiCard(
                          label: "Review",
                          count: "$reviewCount",
                          icon: Icons.rate_review_outlined,
                          iconColor: const Color(0xFF9333EA),
                          accentBg: const Color(0xFFF3E8FF),
                          onTap: () => onNavigateToTab?.call(2),
                        ),
                        KpiCard(
                          label: "Completed",
                          count: "$completedCount",
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: AppColors.success,
                          accentBg: AppColors.successLight,
                          onTap: () => onNavigateToTab?.call(2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Priority Active Task Glass Highlight Card
                  if (activeTask != null) ...[
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Priority Active Task",
                                style: AppTypography.sectionTitle.copyWith(fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () => onNavigateToTab?.call(2),
                                child: Text(
                                  "All Tasks",
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          GlassCard(
                            padding: const EdgeInsets.all(18),
                            backgroundColor: AppColors.white.withAlpha(240),
                            onTap: () {
                              Navigator.push(
                                context,
                                AppPageRoute.create(
                                  EmployeeTaskDetailsScreen(
                                    task: activeTask!,
                                    loggedInEmployee: loggedInEmployee,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    PriorityBadge(
                                      priority: loggedInEmployee.priority,
                                      fontSize: 11,
                                    ),
                                    const Spacer(),
                                    TaskStatusBadge(status: activeTask.status),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  activeTask.taskTitle,
                                  style: AppTypography.cardTitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 13,
                                          color: AppColors.textMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Due ${activeTask.dueDate}",
                                          style: AppTypography.bodySecondary.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.folder_outlined,
                                          size: 13,
                                          color: AppColors.textMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 160),
                                          child: Text(
                                            activeTask.projectType,
                                            style: AppTypography.bodySecondary.copyWith(
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryButton(
                                        text: "Open Task",
                                        icon: Icons.arrow_forward_rounded,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            AppPageRoute.create(
                                              EmployeeTaskDetailsScreen(
                                                task: activeTask!,
                                                loggedInEmployee: loggedInEmployee,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 4. Project Snapshot Progress
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 180),
                    child: EmployeeProjectSnapshot(
                      assignedProjects: provider.getProjectsByEmployee(loggedInEmployee.employeeName),
                      onSeeAll: () => onNavigateToTab?.call(1),
                      onProjectTap: (project) {
                        Navigator.push(
                          context,
                          AppPageRoute.create(
                            EmployeeProjectDetailsScreen(
                              project: project,
                              loggedInEmployee: loggedInEmployee,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 5. Recent Notifications
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 220),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Notifications",
                              style: AppTypography.sectionTitle.copyWith(fontSize: 16),
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
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (previewNotifications.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Center(
                              child: Text(
                                "No recent notifications",
                                style: AppTypography.bodySecondary,
                              ),
                            ),
                          )
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
}
