import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/dummy_data.dart';
import '../screens/notifications/notifications_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHeaderProfile;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onMonitoringPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showHeaderProfile = false,
    this.onNotificationPressed,
    this.onMonitoringPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showHeaderProfile) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderGray, width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      "AD",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
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
                          color: AppColors.primaryRedLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "ADMIN",
                          style: AppTypography.label.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.pageTitle.copyWith(fontSize: 22),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            if (onMonitoringPressed != null) ...[
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderGray),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.insert_chart_outlined_rounded,
                    color: AppColors.black,
                    size: 20,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                  tooltip: "Admin Monitoring",
                  onPressed: onMonitoringPressed,
                ),
              ),
            ],
            AnimatedBuilder(
              animation: DummyDataProvider(),
              builder: (context, _) {
                final data = DummyDataProvider();
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.black,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                        onPressed: onNotificationPressed ??
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen(),
                                ),
                              );
                            },
                      ),
                      if (data.hasUnreadNotifications)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}
