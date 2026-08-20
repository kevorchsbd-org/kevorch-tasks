import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';
import '../../core/animations/app_animations.dart';

class CreateProjectModal extends StatefulWidget {
  const CreateProjectModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateProjectModal(),
    );
  }

  @override
  State<CreateProjectModal> createState() => _CreateProjectModalState();
}

class _CreateProjectModalState extends State<CreateProjectModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _collegeController = TextEditingController();
  final _domainController = TextEditingController();
  bool _isLoading = false;
  String? _selectedEmployeeName;

  @override
  void initState() {
    super.initState();
    _domainController.addListener(_onDomainChanged);
  }

  void _onDomainChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _domainController.removeListener(_onDomainChanged);
    _nameController.dispose();
    _descController.dispose();
    _collegeController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      final newProject = ProjectModel(
        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
        projectName: _nameController.text.trim(),
        projectDescription: _descController.text.trim(),
        collegeName: _collegeController.text.trim(),
        domain: _domainController.text.trim(),
        createdDate: '20 August 2026',
        assignedEmployee: _selectedEmployeeName,
      );

      DummyDataProvider().addProject(newProject);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        SuccessStateDialog.show(
          context,
          title: "Project Created",
          message: _selectedEmployeeName != null
              ? "${newProject.projectName} created and assigned to $_selectedEmployeeName."
              : "${newProject.projectName} has been added successfully.",
          onDismiss: () {},
        );
      }
    }
  }

  String _normalizeDomain(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[/_\-\.\s]+'), ' ')
        .trim();
  }

  List<_EmployeeMatch> _getRankedSuggestions(List<EmployeeModel> employees, String query) {
    final String normQuery = _normalizeDomain(query);
    if (normQuery.isEmpty) return [];

    final List<_EmployeeMatch> matches = [];
    final List<String> queryWords = normQuery.split(' ').where((w) => w.length >= 2).toList();

    debugPrint("--- Employee Suggestion Match Check ---");
    debugPrint("Project domain query: '$query' | Normalized: '$normQuery'");

    for (var emp in employees) {
      final String normEmpDomain = _normalizeDomain(emp.domain);
      _EmployeeMatch? match;

      // 1. Direct or equivalent domain match after normalization -> Best Match
      if (normEmpDomain == normQuery ||
          (normEmpDomain.isNotEmpty && normQuery.isNotEmpty && (normEmpDomain.startsWith(normQuery) || normQuery.startsWith(normEmpDomain)))) {
        match = _EmployeeMatch(employee: emp, label: "Best Match", score: 3);
      }
      // 2. Closely related domain version -> Strong Match
      else if (normEmpDomain.contains(normQuery) || normQuery.contains(normEmpDomain)) {
        match = _EmployeeMatch(employee: emp, label: "Strong Match", score: 2);
      }
      // 3. Meaningful partial domain word overlap -> Good Match
      else if (queryWords.any((word) => normEmpDomain.contains(word))) {
        match = _EmployeeMatch(employee: emp, label: "Good Match", score: 1);
      }

      if (match != null) {
        matches.add(match);
      }

      debugPrint("Employee: '${emp.employeeName}', Domain: '${emp.domain}' (Norm: '$normEmpDomain') -> ${match?.label ?? 'No Match'}");
    }

    matches.sort((a, b) => b.score.compareTo(a.score));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    final data = DummyDataProvider();
    final employees = data.employees;
    final String currentDomain = _domainController.text;
    final bool showSuggestions = currentDomain.trim().isNotEmpty;
    final suggestions = _getRankedSuggestions(employees, currentDomain);

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
                    "Create Project",
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
                label: "Project Name",
                hint: "e.g. AI Placement Predictor",
                controller: _nameController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Project Name is required" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Project Description",
                hint: "Enter a brief summary of the project",
                controller: _descController,
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Project Description is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "College Name",
                hint: "e.g. IIT Madras",
                controller: _collegeController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "College Name is required"
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Domain",
                hint: "e.g. Web Development, Mobile App, Artificial Intelligence",
                controller: _domainController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Domain is required" : null,
              ),
              const SizedBox(height: 16),

              // Smart Employee Suggestions Section (Visible only when domain contains text)
              if (showSuggestions) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.primaryRed,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Suggested Employees",
                          style: AppTypography.sectionTitle.copyWith(fontSize: 15),
                        ),
                        const Spacer(),
                        if (_selectedEmployeeName != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedEmployeeName = null;
                              });
                            },
                            child: Text(
                              "Clear Selection",
                              style: AppTypography.label.copyWith(
                                color: AppColors.primaryRed,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (suggestions.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGray,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Text(
                          "No employees found for this domain.",
                          style: AppTypography.bodySecondary.copyWith(
                            fontSize: 12.5,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 104,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final item = suggestions[index];
                            final bool isSelected = _selectedEmployeeName == item.employee.employeeName;

                            return ScaleTapWidget(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedEmployeeName = null;
                                  } else {
                                    _selectedEmployeeName = item.employee.employeeName;
                                  }
                                });
                              },
                              child: Container(
                                width: 175,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryRedLight : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primaryRed : AppColors.borderGray,
                                    width: isSelected ? 1.8 : 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.cardShadow,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: const BoxDecoration(
                                            color: AppColors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.employee.initials,
                                              style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.employee.employeeName,
                                            style: AppTypography.cardTitle.copyWith(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      item.employee.role,
                                      style: AppTypography.label.copyWith(
                                        fontSize: 11,
                                        color: AppColors.mediumGray,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _MatchBadge(label: item.label, score: item.score),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.primaryRed,
                                            size: 16,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              PrimaryButton(
                text: _selectedEmployeeName != null
                    ? "Create & Assign to $_selectedEmployeeName"
                    : "Create Project",
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

class _EmployeeMatch {
  final EmployeeModel employee;
  final String label;
  final int score;

  _EmployeeMatch({
    required this.employee,
    required this.label,
    required this.score,
  });
}

class _MatchBadge extends StatelessWidget {
  final String label;
  final int score;

  const _MatchBadge({
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    if (score == 3) {
      bg = const Color(0xFFECFDF5);
      fg = const Color(0xFF059669);
    } else if (score == 2) {
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF2563EB);
    } else {
      bg = const Color(0xFFF3F4F6);
      fg = const Color(0xFF4B5563);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
