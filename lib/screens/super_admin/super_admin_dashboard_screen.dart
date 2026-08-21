import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../navigation/employee_navigation.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/success_state_dialog.dart';
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
