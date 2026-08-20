import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'primary_button.dart';

class SuccessStateDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const SuccessStateDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SuccessStateDialog(
        title: title,
        message: message,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<SuccessStateDialog> createState() => _SuccessStateDialogState();
}

class _SuccessStateDialogState extends State<SuccessStateDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryRedLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryRed,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTypography.cardTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Continue",
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDismiss();
              },
            ),
          ],
        ),
      ),
    );
  }
}
