import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/student_submission_read_only_view.dart';
import '../../widgets/project_timeline.dart';
import '../../widgets/student_process_card.dart';
import 'assign_employee_modal.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final project = data.getProjectById(projectId);

        if (project == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Project Details")),
            body: const Center(child: Text("Project not found")),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Project Details",
              style: AppTypography.sectionTitle,
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header & Domain Badge
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                project.projectName,
                                style: AppTypography.pageTitle.copyWith(fontSize: 26),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRedLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primaryRed.withAlpha(40)),
                              ),
                              child: Text(
                                project.domain,
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Project Information Card
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
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
                                "Project Information",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                project.projectDescription,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.darkGray,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.account_balance_outlined,
                                label: "College Name",
                                value: project.collegeName,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.category_outlined,
                                label: "Domain",
                                value: project.domain,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: "Created Date",
                                value: project.createdDate,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Assigned Employee Section
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Assigned Employee",
                                    style: AppTypography.cardTitle.copyWith(fontSize: 18),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: project.isAssigned
                                          ? AppColors.primaryRedLight
                                          : AppColors.surfaceGray,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: project.isAssigned
                                            ? AppColors.primaryRed.withAlpha(40)
                                            : AppColors.borderGray,
                                      ),
                                    ),
                                    child: Text(
                                      project.isAssigned ? "Assigned" : "Unassigned",
                                      style: AppTypography.label.copyWith(
                                        fontSize: 12,
                                        color: project.isAssigned
                                            ? AppColors.primaryRed
                                            : AppColors.mediumGray,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Employee Details / Unassigned View
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: project.isAssigned
                                    ? Row(
                                        key: ValueKey("assigned_${project.assignedEmployee}"),
                                        children: [
                                          Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: AppColors.black,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.borderGray,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                project.assignedInitials,
                                                style: AppTypography.cardTitle.copyWith(
                                                  color: AppColors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  project.assignedEmployee!,
                                                  style: AppTypography.cardTitle.copyWith(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "Project Lead / Assignee",
                                                  style: AppTypography.bodySecondary.copyWith(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        key: const ValueKey("unassigned"),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceGray,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.borderGray),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_off_outlined,
                                              color: AppColors.mediumGray,
                                              size: 22,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              "Not Assigned",
                                              style: AppTypography.bodySecondary.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 20),

                              // Action Button
                              PrimaryButton(
                                text: "Assign Employee",
                                icon: Icons.person_add_alt_1_rounded,
                                onPressed: () {
                                  AssignEmployeeModal.show(context, project);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Project Journey (Timeline) Section
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 350),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderGray),
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
                                "Project Journey & Timeline",
                                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              ProjectTimeline(
                                project: project,
                                isAdmin: true,
                                onRework: () => data.setProjectTimelineStage(project.id, 'Rework'),
                                onTesting: () => data.setProjectTimelineStage(project.id, 'Testing'),
                                onReview: () => data.setProjectTimelineStage(project.id, 'Phase 1 Review'),
                                onClosure: () => data.setProjectTimelineStage(project.id, 'Project Closure'),
                                onConfirmClosure: () => _showConfirmClosureDialog(context, data, project),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Submissions (Employee TO DO history) ────────────────
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 400),
                        child: _SubmissionsSection(projectId: projectId),
                      ),
                      const SizedBox(height: 24),

                      // ── Student Submissions ────────────────────────────────
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 450),
                        child: _StudentSubmissionsSection(projectId: projectId),
                      ),
                      const SizedBox(height: 24),

                      // ── Student Process Logs ──────────────────────────────
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 500),
                        child: _StudentProcessesSection(projectId: projectId),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mediumGray),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTypography.bodySecondary.copyWith(
              color: AppColors.mediumGray,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.label.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showConfirmClosureDialog(BuildContext context, DummyDataProvider provider, ProjectModel project) {
    final validation = provider.validateProjectClosure(project.id);
    final isValid = validation['isValid'] == true;
    final incompleteItems = List<String>.from(validation['incompleteItems'] ?? []);

    if (!isValid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                'Prerequisites Pending',
                style: AppTypography.cardTitle.copyWith(fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This project cannot be completed yet. The following required tasks/submissions are incomplete:',
                style: AppTypography.body.copyWith(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              ...incompleteItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'OK',
                style: AppTypography.label.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Otherwise, show confirmation dialog to finalize project
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Confirm Project Completion?',
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        content: Text(
          'Once confirmed, the project will be permanently marked as COMPLETED and all user modifications will be locked.',
          style: AppTypography.body.copyWith(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.label.copyWith(color: AppColors.mediumGray, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.confirmProjectClosure(project.id);
              
              // Success notice dialog
              showDialog(
                context: context,
                builder: (successCtx) => AlertDialog(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Project Completed',
                        style: AppTypography.cardTitle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The project has been closed and locked permanently.',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(successCtx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Text(
              'Complete Project',
              style: AppTypography.label.copyWith(color: const Color(0xFF16A34A), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Submissions Section — Read-only view of Employee submitted TO DOs
// ─────────────────────────────────────────────────────────────────────────────

class _SubmissionsSection extends StatelessWidget {
  final String projectId;
  const _SubmissionsSection({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final submissions =
            DummyDataProvider().getSubmittedTodosByProject(projectId);
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderGray),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Submissions',
                    style: AppTypography.cardTitle.copyWith(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: submissions.isEmpty
                          ? AppColors.surfaceGray
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: submissions.isEmpty
                            ? AppColors.borderGray
                            : const Color(0xFF16A34A).withAlpha(60),
                      ),
                    ),
                    child: Text(
                      '${submissions.length} submitted',
                      style: AppTypography.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: submissions.isEmpty
                            ? AppColors.mediumGray
                            : const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (submissions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_outlined,
                          size: 20, color: AppColors.lightGray),
                      const SizedBox(width: 10),
                      Text(
                        'No submissions yet',
                        style: AppTypography.bodySecondary
                            .copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: submissions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final s = submissions[index];
                    return GestureDetector(
                      onTap: () => _showDetails(context, s),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                const Color(0xFF16A34A).withAlpha(60),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 15,
                                    color: Color(0xFF16A34A)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    s.title,
                                    style: AppTypography.cardTitle
                                        .copyWith(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF16A34A),
                                    borderRadius:
                                        BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Submitted',
                                    style: AppTypography.label.copyWith(
                                      fontSize: 10,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                if (s.studentName != null)
                                  _MetaChip(
                                      Icons.person_outline_rounded,
                                      s.studentName!),
                                if (s.submittedDateStr != null)
                                  _MetaChip(
                                    Icons.schedule_rounded,
                                    '${s.submittedDateStr} • ${s.submittedTimeStr}',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context, EmployeeTodoModel s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF16A34A), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(s.title,
                  style: AppTypography.cardTitle.copyWith(fontSize: 16)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DialogRow('Description', s.description),
            if (s.studentName != null) ...[
              const SizedBox(height: 10),
              _DialogRow('Student', s.studentName!),
            ],
            if (s.note != null) ...[
              const SizedBox(height: 10),
              _DialogRow('Note', s.note!),
            ],
            const SizedBox(height: 10),
            _DialogRow('Created',
                '${s.createdDateStr} • ${s.createdTimeStr}'),
            const SizedBox(height: 10),
            _DialogRow('Submitted',
                '${s.submittedDateStr ?? "-"} • ${s.submittedTimeStr ?? "-"}'),
            const SizedBox(height: 6),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.primaryRed.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 13, color: AppColors.primaryRed),
                  const SizedBox(width: 6),
                  Text(
                    'Admin view only — cannot be edited',
                    style: AppTypography.label.copyWith(
                      fontSize: 11,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close',
                style: AppTypography.label.copyWith(
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaChip(this.icon, this.text);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.mediumGray),
        const SizedBox(width: 4),
        Text(text,
            style: AppTypography.label.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _DialogRow extends StatelessWidget {
  final String label;
  final String value;
  const _DialogRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.body.copyWith(fontSize: 13),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: Color(0xFF111111)),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Color(0xFF374151)),
          ),
        ],
      ),
    );
  }
}

class _StudentSubmissionsSection extends StatelessWidget {
  final String projectId;
  const _StudentSubmissionsSection({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final submissions = provider.getSubmittedStudentSubmissionsByProject(projectId);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderGray),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Student Submissions',
                    style: AppTypography.cardTitle.copyWith(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: submissions.isEmpty
                          ? AppColors.surfaceGray
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: submissions.isEmpty
                            ? AppColors.borderGray
                            : const Color(0xFF16A34A).withAlpha(60),
                      ),
                    ),
                    child: Text(
                      '${submissions.length} submitted',
                      style: AppTypography.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: submissions.isEmpty
                            ? AppColors.mediumGray
                            : const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (submissions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_outlined, size: 20, color: AppColors.lightGray),
                      const SizedBox(width: 10),
                      Text(
                        'No student submissions yet',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: submissions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final s = submissions[index];
                    final empName = provider.getEmployeeById(s.employeeId)?.employeeName ?? 'Unknown Employee';

                    return GestureDetector(
                      onTap: () => StudentSubmissionReadOnlyView.show(context, s),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF16A34A).withAlpha(60)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, size: 15, color: Color(0xFF16A34A)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    s.studentName,
                                    style: AppTypography.cardTitle.copyWith(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF16A34A),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'SUBMITTED',
                                    style: AppTypography.label.copyWith(
                                      fontSize: 10,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                _MetaChip(Icons.badge_outlined, s.registerNumber),
                                _MetaChip(Icons.category_outlined, s.department),
                                _MetaChip(Icons.person_outline_rounded, 'By $empName'),
                                if (s.documentName != null)
                                  _MetaChip(Icons.attach_file_rounded, s.documentName!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StudentProcessesSection extends StatelessWidget {
  final String projectId;

  const _StudentProcessesSection({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final processes = provider.getProcessesByProject(projectId)
            .where((p) => p.status == 'SUBMITTED')
            .toList();

        processes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderGray),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Student Process Logs",
                    style: AppTypography.cardTitle.copyWith(fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderGray),
                    ),
                    child: Text(
                      "${processes.length} logs",
                      style: AppTypography.label.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (processes.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: Text(
                    "No student process logs submitted yet.",
                    style: AppTypography.bodySecondary,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: processes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final process = processes[index];
                    return StudentProcessCard(
                      process: process,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

