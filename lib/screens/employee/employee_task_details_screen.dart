import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/task_status_badge.dart';
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
        final showWorkUpdateCard = status == 'IN PROGRESS' || status == 'REWORK';

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Task Details",
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.borderGray, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Task Title and Status Badge
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderGray, width: 1),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  currentTask.taskTitle,
                                  style: AppTypography.pageTitle.copyWith(
                                    fontSize: 20,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              TaskStatusBadge(
                                status: currentTask.status,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceGray,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderGray, width: 0.8),
                            ),
                            child: Text(
                              currentTask.projectType,
                              style: AppTypography.label.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Task Information Card
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: _buildCard(
                      title: "Task Description",
                      icon: Icons.description_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentTask.taskDescription,
                            style: AppTypography.body.copyWith(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _buildMiniLabel("Task Category", currentTask.taskType),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Assignment Information Card
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 300),
                    child: _buildCard(
                      title: "Assignment Details",
                      icon: Icons.assignment_ind_outlined,
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 12,
                        children: [
                          _buildMiniLabel(
                            "Assigned To",
                            currentTask.assignedEmployee,
                            icon: Icons.person_outline_rounded,
                          ),
                          _buildMiniLabel(
                            "Created",
                            currentTask.createdDate,
                            icon: Icons.calendar_today_outlined,
                          ),
                          _buildMiniLabel(
                            "Due Date",
                            currentTask.dueDate,
                            icon: Icons.event_available_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Work Update Card (Visible for IN PROGRESS & REWORK)
                  if (showWorkUpdateCard) ...[
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 400),
                      child: _buildCard(
                        title: "Work Update Note",
                        icon: Icons.edit_note_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status == 'REWORK'
                                  ? "Admin requested rework. Please detail your changes below:"
                                  : "Describe work accomplished or progress notes for review:",
                              style: AppTypography.bodySecondary.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _workNoteController,
                              maxLines: 4,
                              maxLength: 500,
                              style: AppTypography.body.copyWith(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Type work progress notes, links, or implementation details...",
                                hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 13),
                                filled: true,
                                fillColor: AppColors.surfaceGray,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.borderGray),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
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
                    // Read-only Work Update Note for other states if note exists
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 400),
                      child: _buildCard(
                        title: "Work Update Note",
                        icon: Icons.sticky_note_2_outlined,
                        child: Text(
                          currentTask.workUpdateNote!,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 5. Context-Sensitive Action Button & State Banners
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 500),
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

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray, width: 1),
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
              Icon(icon, size: 18, color: AppColors.primaryRed),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.cardTitle.copyWith(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderGray, height: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildMiniLabel(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: AppColors.mediumGray),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                style: AppTypography.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
          onPressed: () => _handleStatusTransition('IN PROGRESS'),
        );

      case 'IN PROGRESS':
        return PrimaryButton(
          text: "Submit for Review",
          icon: Icons.send_rounded,
          isLoading: _isLoading,
          onPressed: () => _handleStatusTransition('REVIEW', requiresNote: true),
        );

      case 'REVIEW':
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD8B4FE), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.rate_review_rounded, color: Color(0xFF9333EA), size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Under Review by Admin",
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF9333EA),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Waiting for Admin feedback or testing approval.",
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
        );

      case 'REWORK':
        return PrimaryButton(
          text: "Submit Updated Work",
          icon: Icons.replay_rounded,
          isLoading: _isLoading,
          onPressed: () => _handleStatusTransition('REVIEW', requiresNote: true),
        );

      case 'TESTING':
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.science_outlined, color: Color(0xFF059669), size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "In Testing Phase",
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "QA & Admin testing is in progress.",
                      style: AppTypography.bodySecondary.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 'DONE':
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF86EFAC), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF16A34A), size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task Completed",
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF16A34A),
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
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
