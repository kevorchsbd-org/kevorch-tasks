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
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSecondary
              ? AppColors.white
              : (onPressed == null ? AppColors.textMuted : AppColors.primary),
          borderRadius: BorderRadius.circular(10),
          border: isSecondary
              ? Border.all(color: AppColors.border, width: 1.2)
              : null,
          boxShadow: isSecondary || onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSecondary ? AppColors.primary : AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              Icon(
                icon,
                color: isSecondary ? AppColors.textPrimary : AppColors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: AppTypography.button.copyWith(
                color: isSecondary ? AppColors.textPrimary : AppColors.white,
                fontSize: 13,
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
