import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailsScreen({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final employee = data.getEmployeeById(employeeId);

        if (employee == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Employee Details"),
              backgroundColor: AppColors.white,
            ),
            body: const Center(
              child: Text("Employee not found"),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Employee Details",
              style: AppTypography.pageTitle.copyWith(fontSize: 20),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Profile Card
                _buildHeaderCard(employee),
                const SizedBox(height: 20),

                // Section 1: Employee Info
                _buildSectionCard(
                  title: "Employee Info",
                  icon: Icons.person_outline_rounded,
                  items: [
                    _DetailRow(label: "Employee ID", value: employee.id),
                    _DetailRow(label: "Name", value: employee.employeeName),
                    _DetailRow(label: "Email", value: employee.email),
                    _DetailRow(label: "Role", value: employee.role),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 2: Current Work
                _buildSectionCard(
                  title: "Current Work",
                  icon: Icons.work_outline_rounded,
                  items: [
                    _DetailRow(label: "Current Project", value: employee.currentProject),
                    _DetailRow(label: "Current Task", value: employee.currentTask),
                    _DetailRow(
                      label: "Priority",
                      widgetValue: _PriorityBadge(priority: employee.priority),
                    ),
                    _DetailRow(label: "Deadline", value: employee.deadline),
                    _DetailRow(
                      label: "Status",
                      widgetValue: _StatusBadge(status: employee.status),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Section 3: Student Details
                _buildSectionCard(
                  title: "Student Details",
                  icon: Icons.school_outlined,
                  items: [
                    _DetailRow(label: "Student ID", value: employee.studentId),
                    _DetailRow(label: "Student Name", value: employee.studentName),
                    _DetailRow(label: "College", value: employee.college),
                    _DetailRow(label: "Domain", value: employee.domain),
                    _DetailRow(label: "Project Title", value: employee.projectTitle),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(EmployeeModel employee) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                employee.initials,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.employeeName,
                  style: AppTypography.cardTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.role,
                  style: AppTypography.bodySecondary.copyWith(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(status: employee.status),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryRed),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.sectionTitle.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.borderGray),
          const SizedBox(height: 14),
          ...items,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? widgetValue;

  const _DetailRow({
    required this.label,
    this.value,
    this.widgetValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.label.copyWith(
              fontSize: 13,
              color: AppColors.mediumGray,
            ),
          ),
          if (widgetValue != null)
            widgetValue!
          else
            Flexible(
              child: Text(
                value ?? "-",
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (priority.trim().toLowerCase()) {
      case 'high':
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFDC2626);
        break;
      case 'medium':
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        break;
      case 'low':
      default:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.trim().toLowerCase()) {
      case 'in progress':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        break;
      case 'submitted':
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        break;
      case 'completed':
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF059669);
        break;
      case 'pending':
      default:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
