import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../navigation/employee_navigation.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/success_state_dialog.dart';
import '../../widgets/student_submission_read_only_view.dart';
import '../../data/models.dart';
import '../monitoring/monitoring_screen.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const SuperAdminDashboardScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final totalAdmins = provider.totalAdminUsers;
        final totalProjects = provider.totalProjects;
        final totalEmployees = provider.totalEmployees;
        final totalTasks = provider.totalTasks;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header (Avatar, Title, Super Admin Badge, Monitoring, Employee View switch)
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
                                "Full System & Employee Access Scope",
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

                  const SizedBox(height: 20),

                  // 2. Banner Card & Switch to Employee View Action
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.black,
                            Color(0xFF1F2937),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Full System Control Scope",
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.lightGray,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRedLight.withAlpha(80),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "ALL ROLES ACCESSIBLE",
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.primaryRed,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Super Admin Control Center",
                            style: AppTypography.pageTitle.copyWith(
                              color: AppColors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "You have unrestricted access to System Administration, Projects, Employees, Tasks, and Employee Workflows.",
                            style: AppTypography.bodySecondary.copyWith(
                              color: AppColors.borderGray,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.white,
                                    side: const BorderSide(color: AppColors.primaryRed, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.badge_outlined, size: 18),
                                  label: const Text(
                                    "Switch to Employee View",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    final demoEmp = provider.getEmployeeByEmail("employee@kevorch.com") ??
                                        provider.employees.first;
                                    Navigator.push(
                                      context,
                                      AppPageRoute.create(
                                        EmployeeNavigation(loggedInEmployee: demoEmp),
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
                  ),

                  const SizedBox(height: 24),

                  // 3. Quick System Stats (2x2 Grid using SummaryCard)
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 150),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: "System Admins",
                                count: totalAdmins,
                                icon: Icons.admin_panel_settings_outlined,
                                isCompact: true,
                                onTap: () => onNavigateToTab?.call(1),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SummaryCard(
                                title: "Active Projects",
                                count: totalProjects,
                                icon: Icons.folder_open_rounded,
                                isCompact: true,
                                onTap: () => onNavigateToTab?.call(2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: "Total Employees",
                                count: totalEmployees,
                                icon: Icons.people_outline_rounded,
                                isCompact: true,
                                onTap: () => onNavigateToTab?.call(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SummaryCard(
                                title: "Total Tasks",
                                count: totalTasks,
                                icon: Icons.assignment_outlined,
                                isCompact: true,
                                onTap: () => onNavigateToTab?.call(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 4. Quick Actions & Reports
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Super Admin System Actions",
                          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionTile(
                                context,
                                title: "System Health & Logs",
                                subtitle: "View live metrics & telemetry",
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
                                subtitle: "Generate CSV / PDF summary",
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
                  const SizedBox(height: 28),

                  // 5. Recent Student Submissions
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 250),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Student Submissions",
                          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        _SuperAdminSubmissionsList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 6. Recent Student Processes
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Student Process Updates",
                          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        _SuperAdminProcessesList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 7. Project Progress Summary
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Timelines & Stages",
                          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        _SuperAdminProjectsProgressList(),
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
              child: Icon(icon, color: AppColors.primaryRed, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppTypography.cardTitle.copyWith(fontSize: 14),
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
  @override
  Widget build(BuildContext context) {
    final provider = DummyDataProvider();
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
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.studentName,
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
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
                const Icon(Icons.chevron_right_rounded, color: AppColors.mediumGray, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuperAdminProcessesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = DummyDataProvider();
    final processes = provider.getAllSubmittedStudentProcesses()
        .where((p) => p.status == 'SUBMITTED')
        .toList();

    // sort by submittedAt descending
    processes.sort((a, b) {
      if (a.submittedAt == null && b.submittedAt == null) return 0;
      if (a.submittedAt == null) return 1;
      if (b.submittedAt == null) return -1;
      return b.submittedAt!.compareTo(a.submittedAt!);
    });

    // limit to 5
    final displayList = processes.take(5).toList();

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
            "No recent student processes submitted",
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
        final p = displayList[index];
        final empName = provider.getEmployeeById(p.employeeId)?.employeeName ?? 'Unknown Employee';
        final projName = provider.getProjectById(p.projectId)?.projectName ?? 'Unknown Project';

        final submittedDateStr = p.submittedAt != null
            ? '${p.submittedAt!.day} ${const ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][p.submittedAt!.month]} ${p.submittedAt!.year}'
            : 'N/A';

        return Container(
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
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Student: ${p.studentName} • Project: $projName • Lead: $empName',
                      style: AppTypography.bodySecondary.copyWith(fontSize: 11.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Logged: $submittedDateStr',
                      style: AppTypography.bodySecondary.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SuperAdminProjectsProgressList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = DummyDataProvider();
    final projects = provider.projects;

    // limit to 5
    final displayList = projects.take(5).toList();

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
            "No projects found",
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
        final proj = displayList[index];
        
        // Derive color for the status
        Color statusColor = const Color(0xFFFEF3C7);
        Color textColor = const Color(0xFFD97706);
        if (proj.status == ProjectStatus.completed) {
          statusColor = const Color(0xFFDCFCE7);
          textColor = const Color(0xFF16A34A);
        } else if (proj.status == ProjectStatus.assigned) {
          statusColor = const Color(0xFFEFF6FF);
          textColor = const Color(0xFF2563EB);
        }

        return Container(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proj.projectName,
                      style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.linear_scale_rounded, size: 13, color: AppColors.mediumGray),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Stage: ${proj.currentTimelineStage}',
                            style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ProjectStatus.getLabel(proj.status),
                  style: AppTypography.label.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
