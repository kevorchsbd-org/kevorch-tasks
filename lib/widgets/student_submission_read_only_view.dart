import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/models.dart';
import '../data/dummy_data.dart';

class StudentSubmissionReadOnlyView extends StatelessWidget {
  final StudentSubmissionModel submission;

  const StudentSubmissionReadOnlyView({
    super.key,
    required this.submission,
  });

  static void show(BuildContext context, StudentSubmissionModel submission) {
    showDialog(
      context: context,
      builder: (context) => StudentSubmissionReadOnlyView(submission: submission),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = DummyDataProvider();
    final project = provider.getProjectById(submission.projectId);
    final employee = provider.getEmployeeById(submission.employeeId);

    final submittedDateStr = submission.submittedAt != null
        ? '${submission.submittedAt!.day} ${const ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][submission.submittedAt!.month]} ${submission.submittedAt!.year}'
        : 'N/A';
    final submittedTimeStr = submission.submittedAt != null
        ? '${submission.submittedAt!.hour % 12 == 0 ? 12 : submission.submittedAt!.hour % 12}:${submission.submittedAt!.minute.toString().padLeft(2, '0')} ${submission.submittedAt!.hour < 12 ? 'AM' : 'PM'}'
        : 'N/A';

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Student Submission',
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.mediumGray, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Lock Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderGray),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.mediumGray),
                    const SizedBox(width: 6),
                    Text(
                      'Submitted — Read Only',
                      style: AppTypography.label.copyWith(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Section 1: Student Information
              _buildSectionTitle('Student Information'),
              const SizedBox(height: 8),
              _buildDetailField('Student Name', submission.studentName),
              _buildDetailField('Register Number', submission.registerNumber),
              _buildDetailField('Department', submission.department),
              _buildDetailField('College', submission.college),
              if (submission.email != null && submission.email!.isNotEmpty)
                _buildDetailField('Email', submission.email!),
              if (submission.phone != null && submission.phone!.isNotEmpty)
                _buildDetailField('Phone', submission.phone!),
              if (submission.notes != null && submission.notes!.isNotEmpty)
                _buildDetailField('Notes', submission.notes!),
              const SizedBox(height: 18),

              // Section 2: Document
              _buildSectionTitle('Document'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF16A34A).withAlpha(40)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF16A34A), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            submission.documentName ?? 'No document',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${submission.documentType ?? "PDF"} • ${submission.documentSize ?? "0 KB"}',
                            style: AppTypography.bodySecondary.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Section 3: Submission Information
              _buildSectionTitle('Submission Information'),
              const SizedBox(height: 8),
              _buildDetailField('Project', project?.projectName ?? 'Unknown Project'),
              _buildDetailField('Submitted By', employee?.employeeName ?? 'Unknown Employee'),
              _buildDetailField('Submitted Date', submittedDateStr),
              _buildDetailField('Submitted Time', submittedTimeStr),
              _buildDetailField('Status', 'SUBMITTED'),
              const SizedBox(height: 20),

              // Close Action
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.borderGray),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Close',
                    style: AppTypography.button.copyWith(
                      color: AppColors.darkGray,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.label.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryRed,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodySecondary.copyWith(
                fontSize: 13,
                color: AppColors.mediumGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
