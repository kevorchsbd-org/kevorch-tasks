import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/task_status_badge.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/progress_stepper.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';

class EmployeeTaskDetailsScreen extends StatefulWidget {
  final TaskModel task;
  final EmployeeModel loggedInEmployee;

  const EmployeeTaskDetailsScreen({
    super.key,
    required this.task,
    required this.loggedInEmployee,
  });

  @override
  State<EmployeeTaskDetailsScreen> createState() => _EmployeeTaskDetailsScreenState();
}

class _EmployeeTaskDetailsScreenState extends State<EmployeeTaskDetailsScreen> {
  late TextEditingController _workNoteController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _workNoteError;

  @override
  void initState() {
    super.initState();
    _workNoteController = TextEditingController(
      text: widget.task.workUpdateNote ?? '',
    );
  }

  @override
  void dispose() {
    _workNoteController.dispose();
    super.dispose();
  }

  void _handleStatusTransition(String newStatus, {bool requiresNote = false}) async {
    if (requiresNote) {
      final noteText = _workNoteController.text.trim();
      if (noteText.isEmpty) {
        setState(() {
          _workNoteError = "Please enter work update details before submitting.";
        });
        return;
      }
    }

    setState(() {
      _workNoteError = null;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    final provider = DummyDataProvider();
    provider.updateTaskStatus(
      widget.task.id,
      newStatus,
      workUpdateNote: _workNoteController.text.trim().isNotEmpty
          ? _workNoteController.text.trim()
          : null,
    );

    setState(() {
      _isLoading = false;
    });

    String dialogTitle = "Task Status Updated";
    String dialogMsg = "Task is now in $newStatus state.";

    if (newStatus == 'IN PROGRESS') {
      dialogTitle = "Task Started";
      dialogMsg = "Task status updated to IN PROGRESS. Good luck!";
    } else if (newStatus == 'REVIEW') {
      dialogTitle = "Submitted for Review";
      dialogMsg = "Your work update has been submitted to Admin for review.";
    }

    SuccessStateDialog.show(
      context,
      title: dialogTitle,
      message: dialogMsg,
      onDismiss: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final currentTask = DummyDataProvider().getTaskById(widget.task.id) ?? widget.task;
        final status = currentTask.status.toUpperCase();
        final isEditableState = status == 'IN PROGRESS' || status == 'REWORK';

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Task Header & Status/Priority Badges Card
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 60),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
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
                            children: [
                              PriorityBadge(priority: widget.loggedInEmployee.priority),
                              const Spacer(),
                              TaskStatusBadge(status: currentTask.status, fontSize: 12),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentTask.taskTitle,
                            style: AppTypography.pageTitle.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceGray,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border, width: 0.8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.folder_outlined, size: 12, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentTask.projectType,
                                      style: AppTypography.label.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceGray,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border, width: 0.8),
                                ),
                                child: Text(
                                  currentTask.taskType,
                                  style: AppTypography.label.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Horizontal Stepper Visual Progress Indicator
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: ProgressStepper(currentStatus: currentTask.status),
                  ),

                  const SizedBox(height: 16),

                  // 3. Task Description & Metadata Card
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 140),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
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
                              const Icon(Icons.description_outlined, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                "Task Description",
                                style: AppTypography.cardTitle.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(color: AppColors.border, height: 1),
                          const SizedBox(height: 12),
                          Text(
                            currentTask.taskDescription,
                            style: AppTypography.body.copyWith(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMetaItem("Assigned To", currentTask.assignedEmployee, Icons.person_outline_rounded),
                              _buildMetaItem("Created", currentTask.createdDate, Icons.calendar_today_outlined),
                              _buildMetaItem("Due Date", currentTask.dueDate, Icons.event_available_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. Rework Feedback Alert Banner (if REWORK state)
                  if (status == 'REWORK') ...[
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 180),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.warning, width: 1.2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Color(0xFFD97706), size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Admin Rework Requested",
                                    style: AppTypography.cardTitle.copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFFD97706),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Please review Admin instructions, revise your work update below, and click Submit Updated Work.",
                                    style: AppTypography.bodySecondary.copyWith(
                                      fontSize: 12.5,
                                      color: const Color(0xFFB45309),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 5. Reviewing Banner (if REVIEW or TESTING state)
                  if (status == 'REVIEW' || status == 'TESTING') ...[
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 180),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD8B4FE), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.rate_review_rounded, color: Color(0xFF9333EA), size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    status == 'TESTING' ? "Testing in Progress" : "Under Review by Admin",
                                    style: AppTypography.cardTitle.copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFF9333EA),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Your submission is being verified by Admin/QA.",
                                    style: AppTypography.bodySecondary.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF7E22CE),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 6. Completed State Banner (if DONE state)
                  if (status == 'DONE') ...[
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 180),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.success, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Task Successfully Completed",
                                    style: AppTypography.cardTitle.copyWith(
                                      fontSize: 14,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "This task has been verified and marked completed.",
                                    style: AppTypography.bodySecondary.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF15803D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 7. Work Update Input Card (Visually dominant for IN PROGRESS and REWORK)
                  if (isEditableState) ...[
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 200),
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
                            Row(
                              children: [
                                const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  "Work Update & Notes",
                                  style: AppTypography.cardTitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Required for submission",
                                  style: AppTypography.label.copyWith(
                                    fontSize: 10.5,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(color: AppColors.border, height: 1),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _workNoteController,
                              maxLines: 4,
                              maxLength: 500,
                              style: AppTypography.body.copyWith(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Describe progress, completed sub-tasks, URLs or pull request links...",
                                hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 13),
                                filled: true,
                                fillColor: AppColors.surfaceGray,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                                ),
                                errorText: _workNoteError,
                              ),
                              onChanged: (_) {
                                if (_workNoteError != null) {
                                  setState(() {
                                    _workNoteError = null;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else if (currentTask.workUpdateNote != null &&
                      currentTask.workUpdateNote!.isNotEmpty) ...[
                    // Read-only Work Update Note view for other states
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Work Update Note",
                              style: AppTypography.cardTitle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentTask.workUpdateNote!,
                              style: AppTypography.body.copyWith(
                                fontSize: 13.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 8. Action Buttons
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 240),
                    child: _buildActionButton(currentTask, status),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetaItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(fontSize: 10.5, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTypography.body.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(TaskModel currentTask, String status) {
    switch (status) {
      case 'TO DO':
        return PrimaryButton(
          text: "Start Task",
          icon: Icons.play_arrow_rounded,
          isLoading: _isLoading,
          fullWidth: true,
          onPressed: () => _handleStatusTransition('IN PROGRESS'),
        );

      case 'IN PROGRESS':
        return PrimaryButton(
          text: "Submit for Review",
          icon: Icons.send_rounded,
          isLoading: _isLoading,
          fullWidth: true,
          onPressed: () => _handleStatusTransition('REVIEW', requiresNote: true),
        );

      case 'REWORK':
        return PrimaryButton(
          text: "Submit Updated Work",
          icon: Icons.replay_rounded,
          isLoading: _isLoading,
          fullWidth: true,
          onPressed: () => _handleStatusTransition('REVIEW', requiresNote: true),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
