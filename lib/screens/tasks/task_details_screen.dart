import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/task_status_badge.dart';
import '../../widgets/progress_stepper.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';

class TaskDetailsScreen extends StatefulWidget {
  final dynamic task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _reworkController = TextEditingController();
  bool _isLoading = false;

  String get _taskId {
    if (widget.task is String) return widget.task as String;
    if (widget.task is TaskModel) return (widget.task as TaskModel).id;
    return widget.task.toString();
  }

  @override
  void dispose() {
    _reworkController.dispose();
    super.dispose();
  }

  void _handleApproveTask(TaskModel currentTask) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    DummyDataProvider().updateTaskStatus(currentTask.id, 'DONE');
    setState(() => _isLoading = false);

    SuccessStateDialog.show(
      context,
      title: "Task Approved!",
      message: "The task has been marked as DONE.",
      onDismiss: () => Navigator.pop(context),
    );
  }

  void _handleShowReworkModal(TaskModel currentTask) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Request Task Rework",
                    style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Provide clear revision instructions for ${currentTask.assignedEmployee}:",
                style: AppTypography.bodySecondary.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _reworkController,
                maxLines: 3,
                style: AppTypography.body.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Explain what needs to be changed or fixed...",
                  hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 13),
                  filled: true,
                  fillColor: AppColors.surfaceGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: "Send Rework",
                      icon: Icons.send_rounded,
                      onPressed: () {
                        final feedback = _reworkController.text.trim();
                        DummyDataProvider().updateTaskStatus(
                          currentTask.id,
                          'REWORK',
                          workUpdateNote: feedback.isNotEmpty ? "Rework: $feedback" : null,
                        );
                        Navigator.pop(context);
                        SuccessStateDialog.show(
                          context,
                          title: "Rework Requested",
                          message: "Notification & instructions sent to employee.",
                          onDismiss: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final currentTask = data.getTaskById(_taskId);

        if (currentTask == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text("Task Details", style: AppTypography.sectionTitle),
            ),
            body: const Center(
              child: Text("Task not found"),
            ),
          );
        }

        final status = currentTask.status.toUpperCase();
        final isReviewState = status == 'REVIEW' || status == 'TESTING';

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
              "Task Details",
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.border, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Task Header & Status/Priority Badges Card
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 50),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TaskStatusBadge(status: currentTask.status, fontSize: 12),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceGray,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.border, width: 0.8),
                              ),
                              child: Text(
                                currentTask.projectType,
                                style: AppTypography.label.copyWith(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentTask.taskTitle,
                          style: AppTypography.pageTitle.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              "Assigned to ${currentTask.assignedEmployee}",
                              style: AppTypography.bodySecondary.copyWith(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              "Due ${currentTask.dueDate}",
                              style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Horizontal Progress Stepper
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: ProgressStepper(currentStatus: currentTask.status),
                ),

                const SizedBox(height: 16),

                // 3. Task Description Container
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 140),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task Description",
                          style: AppTypography.cardTitle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentTask.taskDescription.isNotEmpty
                              ? currentTask.taskDescription
                              : "No detailed description provided.",
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Work Submission View (if available)
                if (currentTask.workUpdateNote != null && currentTask.workUpdateNote!.isNotEmpty) ...[
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 180),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isReviewState ? const Color(0xFFF3E8FF) : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isReviewState ? const Color(0xFFD8B4FE) : AppColors.border,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                color: isReviewState ? const Color(0xFF9333EA) : AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Employee Work Submission",
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isReviewState ? const Color(0xFF9333EA) : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentTask.workUpdateNote!,
                            style: AppTypography.body.copyWith(
                              fontSize: 13.5,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // 5. Admin Review Actions (Approve & Request Rework)
                if (isReviewState) ...[
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 220),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary, width: 1.5),
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
                          Text(
                            "Admin Review Decision",
                            style: AppTypography.cardTitle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Verify submitted work and select an action below:",
                            style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.danger, width: 1.2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.replay_rounded, color: AppColors.danger, size: 18),
                                  label: Text(
                                    "Request Rework",
                                    style: AppTypography.button.copyWith(color: AppColors.danger, fontSize: 13),
                                  ),
                                  onPressed: () => _handleShowReworkModal(currentTask),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PrimaryButton(
                                  text: "Approve & Done",
                                  icon: Icons.check_circle_rounded,
                                  isLoading: _isLoading,
                                  onPressed: () => _handleApproveTask(currentTask),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
