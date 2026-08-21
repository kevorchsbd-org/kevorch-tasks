import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/models.dart';

class StudentProcessCard extends StatelessWidget {
  final StudentProcessModel process;
  final VoidCallback? onEdit;
  final VoidCallback? onSubmit;

  const StudentProcessCard({
    super.key,
    required this.process,
    this.onEdit,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitted = process.status == 'SUBMITTED';

    final createdDateStr = '${process.createdAt.day} ${_monthName(process.createdAt.month)} ${process.createdAt.year}';
    final submittedDateStr = process.submittedAt != null
        ? '${process.submittedAt!.day} ${_monthName(process.submittedAt!.month)} ${process.submittedAt!.year}'
        : null;

    final createdTimeStr = _formatTime(process.createdAt);
    final submittedTimeStr = process.submittedAt != null ? _formatTime(process.submittedAt!) : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSubmitted ? const Color(0xFFE5E7EB) : AppColors.borderGray,
          width: 1,
        ),
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
          // Header: Status Badges and Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  process.title,
                  style: AppTypography.cardTitle.copyWith(fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              // Required / Optional Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: process.isRequired ? const Color(0xFFFEF2F2) : AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: process.isRequired ? const Color(0xFFFCA5A5) : AppColors.borderGray,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  process.isRequired ? 'REQUIRED' : 'OPTIONAL',
                  style: AppTypography.label.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: process.isRequired ? const Color(0xFFDC2626) : AppColors.mediumGray,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Submitted / Draft Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSubmitted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSubmitted ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  process.status,
                  style: AppTypography.label.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isSubmitted ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Description
          Text(
            process.description,
            style: AppTypography.bodySecondary.copyWith(fontSize: 13, color: const Color(0xFF374151)),
          ),
          
          // Note (if available)
          if (process.note != null && process.note!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderGray, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes:',
                    style: AppTypography.label.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.mediumGray),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    process.note!,
                    style: AppTypography.bodySecondary.copyWith(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],

          // Reference Document (if available)
          if (process.referenceDocumentName != null && process.referenceDocumentName!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.primaryRed),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    process.referenceDocumentName!,
                    style: AppTypography.bodySecondary.copyWith(
                      fontSize: 12,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderGray),
          const SizedBox(height: 10),

          // Timestamps & Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timestamp display
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created: $createdDateStr • $createdTimeStr',
                      style: AppTypography.bodySecondary.copyWith(fontSize: 10.5, color: AppColors.mediumGray),
                    ),
                    if (isSubmitted && submittedDateStr != null && submittedTimeStr != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Submitted: $submittedDateStr • $submittedTimeStr',
                        style: AppTypography.bodySecondary.copyWith(
                          fontSize: 10.5,
                          color: const Color(0xFF16A34A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Draft actions (Edit & Submit)
              if (!isSubmitted) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onEdit != null)
                      TextButton(
                        onPressed: onEdit,
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        child: Text(
                          'Edit',
                          style: AppTypography.label.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (onSubmit != null) ...[
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit',
                          style: AppTypography.label.copyWith(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month];
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
