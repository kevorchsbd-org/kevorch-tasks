import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';

class CreateTaskModal extends StatefulWidget {
  const CreateTaskModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateTaskModal(),
    );
  }

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _projectTypeController = TextEditingController();
  final _taskTypeController = TextEditingController();
  final _employeeController = TextEditingController();
  final _dueDateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _projectTypeController.dispose();
    _taskTypeController.dispose();
    _employeeController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      final newTask = TaskModel(
        id: 't_${DateTime.now().millisecondsSinceEpoch}',
        taskTitle: _titleController.text.trim(),
        taskDescription: _descController.text.trim(),
        projectType: _projectTypeController.text.trim(),
        taskType: _taskTypeController.text.trim(),
        assignedEmployee: _employeeController.text.trim(),
        createdDate: _formatCurrentDate(),
        dueDate: _dueDateController.text.trim(),
        status: 'TO DO',
      );

      DummyDataProvider().addTask(newTask);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        SuccessStateDialog.show(
          context,
          title: "Task Created & Assigned",
          message: "${newTask.taskTitle} has been assigned to ${newTask.assignedEmployee}.",
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
                    "Create Task",
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
                label: "Task Title",
                hint: "e.g. Database Schema Design",
                controller: _titleController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Task Title is required" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Task Description",
                hint: "e.g. Define core tables for student enrollment",
                controller: _descController,
                maxLines: 2,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Task Description is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Project Type",
                hint: "e.g. Web Development (type directly)",
                controller: _projectTypeController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Project Type is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Task Type",
                hint: "e.g. Backend Architecture (type directly)",
                controller: _taskTypeController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Task Type is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Employee Name",
                hint: "e.g. Michael Chen (type directly)",
                controller: _employeeController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Employee Name is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Due Date",
                hint: "e.g. Aug 30, 2026",
                controller: _dueDateController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Due Date is required" : null,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: "Create Task",
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
