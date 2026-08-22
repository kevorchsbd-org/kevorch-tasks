import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/kpi_card.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool _showLogs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "System Monitoring",
          style: AppTypography.sectionTitle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.border, height: 1),
        ),
      ),
      body: AnimatedBuilder(
        animation: DummyDataProvider(),
        builder: (context, _) {
          final data = DummyDataProvider();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Health Overview Metrics Grid
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 50),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      KpiCard(
                        label: "Server Health",
                        count: "HEALTHY",
                        icon: Icons.check_circle_rounded,
                        iconColor: AppColors.success,
                        accentBg: AppColors.successLight,
                      ),
                      KpiCard(
                        label: "Node Latency",
                        count: "24 ms",
                        icon: Icons.speed_rounded,
                        iconColor: AppColors.primary,
                        accentBg: AppColors.primaryLight,
                      ),
                      KpiCard(
                        label: "RAM Utilization",
                        count: "3.2 GB",
                        icon: Icons.memory_rounded,
                        iconColor: Color(0xFF2E90FA),
                        accentBg: Color(0xFFEFF8FF),
                      ),
                      KpiCard(
                        label: "DB Connection Pool",
                        count: "99.8%",
                        icon: Icons.storage_rounded,
                        iconColor: Color(0xFF9333EA),
                        accentBg: Color(0xFFF3E8FF),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Resource Allocation Breakdown
                Text(
                  "Resource Allocation",
                  style: AppTypography.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),

                FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: _buildMetricBarTile(
                    title: "CPU Load",
                    value: 0.28,
                    percentageLabel: "28%",
                    icon: Icons.developer_board_rounded,
                  ),
                ),
                const SizedBox(height: 10),

                FadeSlideTransition(
                  delay: const Duration(milliseconds: 150),
                  child: _buildMetricBarTile(
                    title: "Active Workspaces",
                    value: 0.65,
                    percentageLabel: "${data.totalProjects} Active",
                    icon: Icons.folder_copy_outlined,
                  ),
                ),
                const SizedBox(height: 10),

                FadeSlideTransition(
                  delay: const Duration(milliseconds: 200),
                  child: _buildMetricBarTile(
                    title: "API Gateway Connections",
                    value: 0.42,
                    percentageLabel: "42 Connections",
                    icon: Icons.hub_outlined,
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Collapsible Technical Audit Log Panel
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 250),
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
                        InkWell(
                          onTap: () => setState(() => _showLogs = !_showLogs),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.terminal_rounded, size: 20, color: AppColors.textPrimary),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Technical Audit & Telemetry Logs",
                                    style: AppTypography.cardTitle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Icon(
                                _showLogs ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                        if (_showLogs) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "[INFO] 18:55:01 Node-01 HEALTHCHECK OK (latency: 22ms)",
                                  style: AppTypography.label.copyWith(fontSize: 11, color: const Color(0xFF34D399), fontFamily: 'monospace'),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "[INFO] 18:54:48 DB_POOL Connection active (idle: 12, busy: 4)",
                                  style: AppTypography.label.copyWith(fontSize: 11, color: const Color(0xFF60A5FA), fontFamily: 'monospace'),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "[INFO] 18:54:12 Auth Token Renewal for Admin (Session 0x8F)",
                                  style: AppTypography.label.copyWith(fontSize: 11, color: const Color(0xFFFBBF24), fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricBarTile({
    required String title,
    required double value,
    required String percentageLabel,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                percentageLabel,
                style: AppTypography.label.copyWith(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
