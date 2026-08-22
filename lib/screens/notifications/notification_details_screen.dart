import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../tasks/task_details_screen.dart';
import '../projects/project_details_screen.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationItemModel notification;

  const NotificationDetailsScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final data = DummyDataProvider();
    final task = notification.relatedTaskId != null
        ? data.getTaskById(notification.relatedTaskId!)
        : null;
    final project = notification.relatedProjectId != null
        ? data.getProjectById(notification.relatedProjectId!)
        : null;
    final employee = notification.relatedEmployeeId != null
        ? data.getEmployeeById(notification.relatedEmployeeId!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: FadeSlideTransition(
          duration: const Duration(milliseconds: 380),
          beginOffset: const Offset(0, 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Summary Card ─────────────────────────────────────────────
              _SummaryCard(notification: notification),
              const SizedBox(height: 16),

              // ── Details Card ─────────────────────────────────────────────
              _DetailsCard(
                notification: notification,
                task: task,
                project: project,
                employee: employee,
              ),

              // ── Action Button(s) ─────────────────────────────────────────
              if (task != null || project != null) ...[
                const SizedBox(height: 20),
                _ActionButton(
                  notification: notification,
                  task: task,
                  project: project,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        'Notification Details',
        style: AppTypography.pageTitle.copyWith(fontSize: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final NotificationItemModel notification;

  const _SummaryCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primaryRed.withAlpha(40),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withAlpha(22),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                notification.icon,
                color: AppColors.primaryRed,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: AppTypography.bodySecondary.copyWith(
                    fontSize: 13,
                    color: AppColors.darkGray,
                    height: 1.4,
                  ),
                ),
                if (notification.subTitle != null &&
                    notification.subTitle!.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.folder_outlined,
                        size: 12,
                        color: AppColors.primaryRed,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          notification.subTitle!,
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      notification.timestamp,
                      style: AppTypography.label.copyWith(
                        fontSize: 11.5,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Details Card — type-specific fields resolved from relational dummy data
// ─────────────────────────────────────────────────────────────────────────────

class _DetailsCard extends StatelessWidget {
  final NotificationItemModel notification;
  final TaskModel? task;
  final ProjectModel? project;
  final EmployeeModel? employee;

  const _DetailsCard({
    required this.notification,
    this.task,
    this.project,
    this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETAILS',
            style: AppTypography.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mediumGray,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          ...rows.asMap().entries.map((entry) {
            final isLast = entry.key == rows.length - 1;
            return Column(
              children: [
                entry.value,
                if (!isLast) ...[
                  Divider(
                    color: AppColors.borderGray.withAlpha(120),
                    height: 18,
                    thickness: 1,
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildRows() {
    final type = notification.type;

    if (type == 'task_submitted') {
      return [
        if (task != null)
          _DetailRow(label: 'Task', value: task!.taskTitle),
        if (project != null)
          _DetailRow(label: 'Project', value: project!.projectName),
        if (employee != null)
          _DetailRow(label: 'Submitted By', value: employee!.employeeName),
        if (notification.eventDateTime != null)
          _DetailRow(label: 'Submitted At', value: notification.eventDateTime!),
        if (task != null)
          _DetailRow(
            label: 'Current Status',
            value: task!.status,
            isStatus: true,
          ),
      ];
    }

    if (type == 'task_assigned') {
      return [
        if (task != null)
          _DetailRow(label: 'Task', value: task!.taskTitle),
        if (project != null)
          _DetailRow(label: 'Project', value: project!.projectName),
        if (employee != null)
          _DetailRow(label: 'Assigned To', value: employee!.employeeName),
        if (notification.eventDateTime != null)
          _DetailRow(label: 'Assigned Date', value: notification.eventDateTime!),
        if (task != null)
          _DetailRow(label: 'Due Date', value: task!.dueDate),
        if (task != null)
          _DetailRow(
            label: 'Current Status',
            value: task!.status,
            isStatus: true,
          ),
      ];
    }

    if (type == 'task_status_updated') {
      return [
        if (task != null)
          _DetailRow(label: 'Task', value: task!.taskTitle),
        if (project != null)
          _DetailRow(label: 'Project', value: project!.projectName),
        if (employee != null)
          _DetailRow(label: 'Employee', value: employee!.employeeName),
        // Show Previous Status ONLY when real data exists — never fabricated
        if (notification.previousStatus != null)
          _DetailRow(
            label: 'Previous Status',
            value: notification.previousStatus!,
            isStatus: true,
          ),
        if (notification.newStatus != null)
          _DetailRow(
            label: 'New Status',
            value: notification.newStatus!,
            isStatus: true,
          ),
        if (notification.eventDateTime != null)
          _DetailRow(label: 'Updated At', value: notification.eventDateTime!),
      ];
    }

    if (type == 'project_created') {
      return [
        if (project != null)
          _DetailRow(label: 'Project Name', value: project!.projectName),
        if (project != null && project!.projectDescription.isNotEmpty)
          _DetailRow(label: 'Description', value: project!.projectDescription),
        if (project != null)
          _DetailRow(label: 'College', value: project!.collegeName),
        if (project != null)
          _DetailRow(label: 'Domain', value: project!.domain),
        if (notification.eventDateTime != null)
          _DetailRow(label: 'Created Date', value: notification.eventDateTime!),
      ];
    }

    // Fallback for programmatically generated notifications
    return [
      _DetailRow(label: 'Type', value: notification.type),
      if (notification.eventDateTime != null)
        _DetailRow(label: 'Occurred At', value: notification.eventDateTime!),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail Row
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStatus;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.label.copyWith(
                fontSize: 12.5,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isStatus
                ? _StatusBadge(status: value)
                : Text(
                    value,
                    style: AppTypography.bodySecondary.copyWith(
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Badge with AnimatedSwitcher
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get _bgColor {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'DONE':
        return const Color(0xFFDCFCE7);
      case 'IN PROGRESS':
      case 'REVIEW':
      case 'SUBMITTED':
        return const Color(0xFFFEF9C3);
      case 'PENDING':
      case 'TO DO':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get _textColor {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'DONE':
        return const Color(0xFF16A34A);
      case 'IN PROGRESS':
      case 'REVIEW':
      case 'SUBMITTED':
        return const Color(0xFFB45309);
      case 'PENDING':
      case 'TO DO':
      default:
        return AppColors.mediumGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Container(
        key: ValueKey(status),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          status,
          style: AppTypography.label.copyWith(
            fontSize: 12,
            color: _textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button — View Task / View Project
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final NotificationItemModel notification;
  final TaskModel? task;
  final ProjectModel? project;

  const _ActionButton({
    required this.notification,
    this.task,
    this.project,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasTask =
        task != null && notification.relatedTaskId != null;
    final bool hasProject =
        project != null && notification.relatedProjectId != null;

    if (!hasTask && !hasProject) return const SizedBox.shrink();

    // Both buttons — side by side Row
    if (hasTask && hasProject) {
      return Row(
        children: [
          Expanded(
            child: _ActionButtonTile(
              label: 'View Task',
              icon: Icons.task_alt_rounded,
              onTap: () => Navigator.of(context).push(
                AppPageRoute.create(
                  TaskDetailsScreen(task: notification.relatedTaskId!),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionButtonTile(
              label: 'View Project',
              icon: Icons.folder_open_rounded,
              onTap: () => Navigator.of(context).push(
                AppPageRoute.create(
                  ProjectDetailsScreen(projectId: notification.relatedProjectId!),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Only task button
    if (hasTask) {
      return _ActionButtonTile(
        label: 'View Task',
        icon: Icons.task_alt_rounded,
        fullWidth: true,
        onTap: () => Navigator.of(context).push(
          AppPageRoute.create(
            TaskDetailsScreen(task: notification.relatedTaskId!),
          ),
        ),
      );
    }

    // Only project button
    return _ActionButtonTile(
      label: 'View Project',
      icon: Icons.folder_open_rounded,
      fullWidth: true,
      onTap: () => Navigator.of(context).push(
        AppPageRoute.create(
          ProjectDetailsScreen(projectId: notification.relatedProjectId!),
        ),
      ),
    );
  }
}

class _ActionButtonTile extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool fullWidth;

  const _ActionButtonTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  State<_ActionButtonTile> createState() => _ActionButtonTileState();
}

class _ActionButtonTileState extends State<_ActionButtonTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withAlpha(45),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppColors.white, size: 14),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTypography.label.copyWith(
                  fontSize: 12,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
