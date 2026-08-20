import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/animations/app_animations.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Duration delay;
  final VoidCallback? onTap;
  final bool isCompact;

  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    this.delay = Duration.zero,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      delay: delay,
      child: ScaleTapWidget(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(isCompact ? 16 : 32),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(isCompact ? 16 : 28),
            border: Border.all(color: AppColors.borderGray, width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top-left Icon Container (Adaptive: 42x42px on mobile, 96x96px on desktop)
              Container(
                width: isCompact ? 42 : 96,
                height: isCompact ? 42 : 96,
                decoration: BoxDecoration(
                  color: AppColors.primaryRedLight,
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 26),
                  border: Border.all(color: AppColors.primaryRed.withAlpha(30)),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: AppColors.primaryRed,
                    size: isCompact ? 21 : 56,
                  ),
                ),
              ),
              SizedBox(height: isCompact ? 8 : 52),

              // Metric Number with Count-Up Animation
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: count.toDouble()),
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    '${value.toInt()}',
                    style: AppTypography.summaryNumber.copyWith(
                      fontSize: isCompact ? 28 : 68,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: AppColors.black,
                    ),
                  );
                },
              ),
              SizedBox(height: isCompact ? 4 : 20),

              // Metric Label
              Text(
                title,
                style: AppTypography.label.copyWith(
                  color: isCompact ? const Color(0xFF4B5563) : const Color(0xFF333333),
                  fontSize: isCompact ? 13 : 24,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isCompact ? 8 : 20),

              // Red Horizontal Accent Line
              Container(
                width: isCompact ? 55 : 135,
                height: isCompact ? 3 : 6,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
