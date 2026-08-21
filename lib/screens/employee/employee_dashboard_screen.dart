import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
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

                  const SizedBox(height: 12),

                  // 2. Premium Glassmorphism Project Snapshot
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: AnimatedBuilder(
                      animation: DummyDataProvider(),
                      builder: (context, _) {
                        final provider = DummyDataProvider();
                        final employeeProjects = provider.getProjectsByEmployee(loggedInEmployee.employeeName);

                        return EmployeeProjectSnapshot(
                          assignedProjects: employeeProjects,
                          onSeeAll: () {
                            onNavigateToTab?.call(1);
                          },
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
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. My Assigned Projects Section
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 140),
                    child: AnimatedBuilder(
                      animation: DummyDataProvider(),
                      builder: (context, _) {
                        final provider = DummyDataProvider();
                        final employeeProjects = provider.getProjectsByEmployee(loggedInEmployee.employeeName);

                        final sortedProjects = List<ProjectModel>.from(employeeProjects)..sort((a, b) {
                          // Primary: Active before Completed
                          final aCompleted = a.status == ProjectStatus.completed;
                          final bCompleted = b.status == ProjectStatus.completed;
                          if (aCompleted != bCompleted) {
                            return aCompleted ? 1 : -1;
                          }
                          // Secondary: assignedDate descending
                          if (a.assignedDate != null && b.assignedDate != null) {
                            return b.assignedDate!.compareTo(a.assignedDate!);
                          }
                          // Null date behavior
                          if (a.assignedDate != null && b.assignedDate == null) {
                            return -1;
                          }
                          if (a.assignedDate == null && b.assignedDate != null) {
                            return 1;
                          }
                          return b.createdDate.compareTo(a.createdDate);
                        });

                        final displayedProjects = sortedProjects.take(4).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "My Assigned Projects",
                                    style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (employeeProjects.isNotEmpty)
                                  TextButton(
                                    onPressed: () {
                                      onNavigateToTab?.call(1);
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
                            if (employeeProjects.isEmpty)
                              _buildEmptyProjectsState()
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayedProjects.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final project = displayedProjects[index];
                                  return FadeSlideTransition(
                                    delay: Duration(milliseconds: 160 + (index * 50)),
                                    child: _DashboardProjectCard(
                                      project: project,
                                      onTap: () {
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
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Admin Notifications
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Notifications",
                                style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
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

  Widget _buildEmptyProjectsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray, width: 0.8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.folder_off_outlined,
              size: 28,
              color: AppColors.lightGray,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "No projects assigned yet",
            style: AppTypography.cardTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            "Projects assigned to you will appear here.",
            style: AppTypography.bodySecondary.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DashboardProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const _DashboardProjectCard({
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = getStatusBadgeStyle(project.status);
    
    // Presentation level date formatting helper
    final String dateText;
    if (project.assignedDate != null) {
      dateText = '${project.assignedDate!.day} ${const ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][project.assignedDate!.month]} ${project.assignedDate!.year}';
    } else {
      dateText = project.createdDate;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final showCollegeAndDomain = screenWidth > 500;

    return ScaleTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGray, width: 1.0),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray, width: 0.8),
                  ),
                  child: const Icon(
                    Icons.folder_outlined,
                    color: AppColors.primaryRed,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName,
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: AppColors.mediumGray,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Assigned $dateText',
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
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusStyle.bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusStyle.borderColor, width: 0.8),
                  ),
                  child: Text(
                    ProjectStatus.getLabel(project.status),
                    style: AppTypography.label.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusStyle.textColor,
                    ),
                  ),
                ),
              ],
            ),
            if (showCollegeAndDomain) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderGray, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 14,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            project.collegeName,
                            style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.borderGray, width: 0.6),
                    ),
                    child: Text(
                      project.domain,
                      style: AppTypography.label.copyWith(
                        fontSize: 11,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatusBadgeStyle {
  final Color textColor;
  final Color bgColor;
  final Color borderColor;

  const StatusBadgeStyle({
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
  });
}

StatusBadgeStyle getStatusBadgeStyle(String status) {
  switch (status.toUpperCase()) {
    case 'ASSIGNED':
      return const StatusBadgeStyle(
        textColor: Color(0xFF4B5563), // Neutral Gray
        bgColor: Color(0xFFF3F4F6),
        borderColor: Color(0xFFE5E7EB),
      );
    case 'IN PROGRESS':
      return const StatusBadgeStyle(
        textColor: Color(0xFF2563EB), // Blue Active
        bgColor: Color(0xFFEFF6FF),
        borderColor: Color(0xFFDBEAFE),
      );
    case 'PHASE 1 REVIEW':
      return const StatusBadgeStyle(
        textColor: Color(0xFF7C3AED), // Purple Review
        bgColor: Color(0xFFF5F3FF),
        borderColor: Color(0xFFEDE9FE),
      );
    case 'REWORK':
      return const StatusBadgeStyle(
        textColor: Color(0xFFDC2626), // Spec Red for Attention / Rework
        bgColor: Color(0xFFFEF2F2),
        borderColor: Color(0xFFFEE2E2),
      );
    case 'TESTING':
      return const StatusBadgeStyle(
        textColor: Color(0xFF0891B2), // Cyan Testing
        bgColor: Color(0xFFECFEFF),
        borderColor: Color(0xFFCFFAFE),
      );
    case 'CLOSURE':
      return const StatusBadgeStyle(
        textColor: Color(0xFFEA580C), // Orange Near Completion
        bgColor: Color(0xFFFFF7ED),
        borderColor: Color(0xFFFFEDD5),
      );
    case 'COMPLETED':
      return const StatusBadgeStyle(
        textColor: Color(0xFF16A34A), // Success Green
        bgColor: Color(0xFFF0FDF4),
        borderColor: Color(0xFFDCFCE7),
      );
    default:
      return const StatusBadgeStyle(
        textColor: Color(0xFF4B5563),
        bgColor: Color(0xFFF3F4F6),
        borderColor: Color(0xFFE5E7EB),
      );
  }
}
