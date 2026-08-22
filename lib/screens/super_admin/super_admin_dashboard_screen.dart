import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/success_state_dialog.dart';
import '../../widgets/student_submission_read_only_view.dart';
import '../../widgets/super_admin_operations_pulse.dart';
import '../monitoring/monitoring_screen.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const SuperAdminDashboardScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    // Re-use shared DummyDataProvider instance for reactive subscription
    final provider = DummyDataProvider();

    return AnimatedBuilder(
      animation: provider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header (Avatar, Title, Super Admin Badge, Monitoring)
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
                            border: Border.all(color: AppColors.primaryRed, width: 1.8),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "SA",
                              style: TextStyle(
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
                                      "Super Admin Portal",
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
                                      color: AppColors.primaryRed,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "SUPER ADMIN",
                                      style: AppTypography.label.copyWith(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Full System & Executive Scope",
                                style: AppTypography.bodySecondary.copyWith(
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderGray),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.insert_chart_outlined_rounded,
                              color: AppColors.black,
                              size: 20,
                            ),
                            tooltip: "System Monitoring",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MonitoringScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Operations Pulse
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: SuperAdminOperationsPulse(
                      provider: provider,
                      onNavigateToTab: onNavigateToTab,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Recent Student Submissions
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "RECENT STUDENT SUBMISSIONS",
                              style: AppTypography.cardTitle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              "READ-ONLY",
                              style: AppTypography.label.copyWith(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _SuperAdminSubmissionsList(provider: provider),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 5. Quick System Actions
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 250),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Super Admin System Actions",
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionTile(
                                context,
                                title: "System Monitoring",
                                subtitle: "View telemetry breakdown",
                                icon: Icons.monitor_heart_outlined,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MonitoringScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionTile(
                                context,
                                title: "Export System Report",
                                subtitle: "Generate CSV summary",
                                icon: Icons.file_download_outlined,
                                onTap: () {
                                  SuccessStateDialog.show(
                                    context,
                                    title: "System Report Generated",
                                    message: "Full Super Admin system diagnostic summary downloaded.",
                                    onDismiss: () {},
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
          ),
        );
      },
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ScaleTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryRedLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryRed, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppTypography.cardTitle.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.bodySecondary.copyWith(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuperAdminSubmissionsList extends StatelessWidget {
  final DummyDataProvider provider;

  const _SuperAdminSubmissionsList({required this.provider});

  @override
  Widget build(BuildContext context) {
    final submissions = provider.getAllSubmittedStudentSubmissions();

    // sort by submittedAt descending
    submissions.sort((a, b) {
      if (a.submittedAt == null && b.submittedAt == null) return 0;
      if (a.submittedAt == null) return 1;
      if (b.submittedAt == null) return -1;
      return b.submittedAt!.compareTo(a.submittedAt!);
    });

    // limit to 5
    final displayList = submissions.take(5).toList();

    if (displayList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Center(
          child: Text(
            "No recent student submissions",
            style: AppTypography.bodySecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final s = displayList[index];
        final empName = provider.getEmployeeById(s.employeeId)?.employeeName ?? 'Unknown Employee';
        final projName = provider.getProjectById(s.projectId)?.projectName ?? 'Unknown Project';

        final submittedDateStr = s.submittedAt != null
            ? '${s.submittedAt!.day} ${const ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][s.submittedAt!.month]} ${s.submittedAt!.year}'
            : 'N/A';

        return GestureDetector(
          onTap: () => StudentSubmissionReadOnlyView.show(context, s),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderGray),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 6,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.studentName,
                        style: AppTypography.cardTitle.copyWith(fontSize: 13.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Project: $projName • By: $empName',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 11.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Submitted: $submittedDateStr',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: AppColors.mediumGray, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
