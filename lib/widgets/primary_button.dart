import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/animations/app_animations.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isSecondary;
  final double? width;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSecondary = false,
    this.width,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = ScaleTapWidget(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSecondary
              ? AppColors.white
              : (onPressed == null ? AppColors.lightGray : AppColors.primaryRed),
          borderRadius: BorderRadius.circular(8),
          border: isSecondary
              ? Border.all(color: AppColors.borderGray, width: 1.5)
              : null,
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primaryRed.withAlpha(30),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSecondary ? AppColors.primaryRed : AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(
                icon,
                color: isSecondary ? AppColors.black : AppColors.white,
                size: 14,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              text,
              style: AppTypography.button.copyWith(
                color: isSecondary ? AppColors.black : AppColors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: buttonWidget);
    }

    return Center(
      child: width != null
          ? SizedBox(width: width, child: buttonWidget)
          : buttonWidget,
    );
  }
}
