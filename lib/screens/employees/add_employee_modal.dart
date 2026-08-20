import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';

class AddEmployeeModal extends StatefulWidget {
  const AddEmployeeModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddEmployeeModal(),
    );
  }

  @override
  State<AddEmployeeModal> createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployeeModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      final newEmployee = EmployeeModel(
        id: 'e_${DateTime.now().millisecondsSinceEpoch}',
        employeeName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _roleController.text.trim(),
      );

      DummyDataProvider().addEmployee(newEmployee);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        SuccessStateDialog.show(
          context,
          title: "Employee Added",
          message: "${newEmployee.employeeName} has been added to the team.",
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
                  Text(
                    "Add Employee",
                    style: AppTypography.sectionTitle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Employee Name",
                hint: "e.g. Sarah Jenkins",
                controller: _nameController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Employee Name is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Email",
                hint: "e.g. sarah.j@admintech.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Email is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Role",
                hint: "e.g. Lead Full Stack Dev",
                controller: _roleController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Role is required" : null,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: "Add Employee",
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
