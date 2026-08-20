import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';

class AssignEmployeeModal extends StatefulWidget {
  final ProjectModel project;

  const AssignEmployeeModal({
    super.key,
    required this.project,
  });

  static void show(BuildContext context, ProjectModel project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AssignEmployeeModal(project: project),
    );
  }

  @override
  State<AssignEmployeeModal> createState() => _AssignEmployeeModalState();
}

class _AssignEmployeeModalState extends State<AssignEmployeeModal> {
  final _formKey = GlobalKey<FormState>();
  final _employeeNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.project.isAssigned) {
      _employeeNameController.text = widget.project.assignedEmployee!;
    }
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      final assignedName = _employeeNameController.text.trim();
      DummyDataProvider().assignEmployeeToProject(widget.project.id, assignedName);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(); // Close modal sheet

        SuccessStateDialog.show(
          context,
          title: "Employee Assigned",
          message: "$assignedName has been assigned to ${widget.project.projectName}.",
          onDismiss: () {},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Assign Employee",
                      style: AppTypography.sectionTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text(
                "Assign an employee to ${widget.project.projectName}",
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Employee Name",
                hint: "Enter employee name",
                controller: _employeeNameController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Employee Name is required"
                    : null,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: widget.project.isAssigned ? "Update Assignment" : "Assign",
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
