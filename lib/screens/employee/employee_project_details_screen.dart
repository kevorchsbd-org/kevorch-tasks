import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import 'employee_todo_details_screen.dart';

class EmployeeProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;
  final EmployeeModel loggedInEmployee;

  const EmployeeProjectDetailsScreen({
    super.key,
    required this.project,
    required this.loggedInEmployee,
  });

  @override
  State<EmployeeProjectDetailsScreen> createState() =>
      _EmployeeProjectDetailsScreenState();
}

class _EmployeeProjectDetailsScreenState
    extends State<EmployeeProjectDetailsScreen> {
  String _todoFilter = 'All'; // All | Pending | Submitted

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final updatedProject =
            provider.getProjectById(widget.project.id) ?? widget.project;
        final allTodos = provider.getTodosByProject(widget.project.id);
        final filteredTodos = _todoFilter == 'All'
            ? allTodos
            : allTodos
                .where((t) => t.status == _todoFilter.toUpperCase())
                .toList();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              updatedProject.projectName,
              style: AppTypography.sectionTitle.copyWith(fontSize: 17),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.borderGray, height: 1),
            ),
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () => _TodoBottomSheet.show(
              context,
              projectId: widget.project.id,
              employeeId: widget.loggedInEmployee.id,
            ),
            backgroundColor: AppColors.primaryRed,
            elevation: 3,
            child: const Icon(Icons.add_rounded, color: AppColors.white, size: 20),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Project Info Card ───────────────────────────────────────
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 60),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: AppColors.borderGray, width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRedLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.folder_rounded,
                                color: AppColors.primaryRed,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    updatedProject.projectName,
                                    style: AppTypography.pageTitle.copyWith(
                                      fontSize: 20,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    updatedProject.collegeName,
                                    style: AppTypography.bodySecondary
                                        .copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.borderGray, height: 1),
                        const SizedBox(height: 16),
                        Text(
                          'Project Description',
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          updatedProject.projectDescription,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _InfoChip(
                              Icons.category_outlined,
                              'Domain',
                              updatedProject.domain,
                            ),
                            _InfoChip(
                              Icons.calendar_today_outlined,
                              'Assigned Date',
                              updatedProject.createdDate,
                            ),
                            _InfoChip(
                              Icons.person_outline_rounded,
                              'Lead',
                              updatedProject.assignedEmployee ?? 'Unassigned',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── TO DO Section ───────────────────────────────────────────
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 130),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TO DO',
                        style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Text(
                          '${allTodos.length} items',
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Filter chips
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 160),
                  child: SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', 'Pending', 'Submitted'].map((f) {
                        final active = _todoFilter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _todoFilter = f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primaryRed
                                    : AppColors.surfaceGray,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primaryRed
                                      : AppColors.borderGray,
                                ),
                              ),
                              child: Text(
                                f,
                                style: AppTypography.label.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? AppColors.white
                                      : AppColors.mediumGray,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // TO DO list or empty state
                filteredTodos.isEmpty
                    ? FadeSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: _emptyTodoState(context),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTodos.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final todo = filteredTodos[index];
                          return FadeSlideTransition(
                            delay:
                                Duration(milliseconds: 180 + index * 40),
                            child: _TodoCard(
                              todo: todo,
                              loggedInEmployee: widget.loggedInEmployee,
                            ),
                          );
                        },
                      ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _emptyTodoState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.checklist_rounded,
              size: 34, color: AppColors.lightGray),
          const SizedBox(height: 10),
          Text(
            'No TO DO items yet',
            style: AppTypography.cardTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a TO DO when new work is required.',
            style:
                AppTypography.bodySecondary.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ScaleTapWidget(
            onTap: () => _TodoBottomSheet.show(
              context,
              projectId: widget.project.id,
              employeeId: widget.loggedInEmployee.id,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded,
                      color: AppColors.white, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    'Add TO DO',
                    style: AppTypography.label.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TO DO Card
// ─────────────────────────────────────────────────────────────────────────────

class _TodoCard extends StatelessWidget {
  final EmployeeTodoModel todo;
  final EmployeeModel loggedInEmployee;

  const _TodoCard({required this.todo, required this.loggedInEmployee});

  @override
  Widget build(BuildContext context) {
    return ScaleTapWidget(
      onTap: () => Navigator.push(
        context,
        AppPageRoute.create(
          EmployeeTodoDetailsScreen(
            todo: todo,
            loggedInEmployee: loggedInEmployee,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGray, width: 1),
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
            // Title + status
            Row(
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: AppTypography.cardTitle.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: _TodoStatusBadge(
                    key: ValueKey(todo.status),
                    status: todo.status,
                  ),
                ),
              ],
            ),

            // Student name
            if (todo.studentName != null && todo.studentName!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 13, color: AppColors.mediumGray),
                  const SizedBox(width: 4),
                  Text(
                    todo.studentName!,
                    style: AppTypography.label.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],

            // Description
            const SizedBox(height: 8),
            Text(
              todo.description,
              style: AppTypography.bodySecondary.copyWith(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Date + Submit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 12, color: AppColors.mediumGray),
                    const SizedBox(width: 4),
                    Text(
                      todo.createdDateStr,
                      style: AppTypography.label.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                if (todo.isPending)
                  GestureDetector(
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          title: Text(
                            'Submit TO DO?',
                            style: AppTypography.cardTitle
                                .copyWith(fontSize: 17),
                          ),
                          content: Text(
                            'Once submitted, this TO DO will be permanently locked.',
                            style: AppTypography.body
                                .copyWith(fontSize: 13, height: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, false),
                              child: Text(
                                'Cancel',
                                style: AppTypography.label.copyWith(
                                    color: AppColors.mediumGray,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, true),
                              child: Text(
                                'Submit',
                                style: AppTypography.label.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        DummyDataProvider()
                            .submitEmployeeTodo(todo.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Submit',
                        style: AppTypography.label.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TO DO Status Badge
// ─────────────────────────────────────────────────────────────────────────────

class _TodoStatusBadge extends StatelessWidget {
  final String status;
  const _TodoStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'PENDING';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? AppColors.surfaceGray : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPending
              ? AppColors.borderGray
              : const Color(0xFF16A34A).withAlpha(70),
        ),
      ),
      child: Text(
        isPending ? 'Pending' : 'Submitted',
        style: AppTypography.label.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isPending ? AppColors.mediumGray : const Color(0xFF16A34A),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Chip
// ─────────────────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.mediumGray),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTypography.label.copyWith(fontSize: 11)),
            Text(
              value,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit TO DO Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _TodoBottomSheet extends StatefulWidget {
  final String projectId;
  final String employeeId;
  final EmployeeTodoModel? existing;

  const _TodoBottomSheet({
    required this.projectId,
    required this.employeeId,
    this.existing,
  });

  static void show(
    BuildContext context, {
    required String projectId,
    required String employeeId,
    EmployeeTodoModel? existing,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TodoBottomSheet(
        projectId: projectId,
        employeeId: employeeId,
        existing: existing,
      ),
    );
  }

  @override
  State<_TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends State<_TodoBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _studentCtrl;
  late final TextEditingController _noteCtrl;
  bool _loading = false;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl =
        TextEditingController(text: widget.existing?.title ?? '');
    _descCtrl =
        TextEditingController(text: widget.existing?.description ?? '');
    _studentCtrl =
        TextEditingController(text: widget.existing?.studentName ?? '');
    _noteCtrl =
        TextEditingController(text: widget.existing?.note ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _studentCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 200));
    final provider = DummyDataProvider();
    if (_isEditMode) {
      provider.updateEmployeeTodo(
        id: widget.existing!.id,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        studentName: _studentCtrl.text.trim().isEmpty
            ? null
            : _studentCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty
            ? null
            : _noteCtrl.text.trim(),
      );
    } else {
      final now = DateTime.now();
      provider.addEmployeeTodo(EmployeeTodoModel(
        id: 'td_${now.millisecondsSinceEpoch}',
        projectId: widget.projectId,
        employeeId: widget.employeeId,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        studentName: _studentCtrl.text.trim().isEmpty
            ? null
            : _studentCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty
            ? null
            : _noteCtrl.text.trim(),
        createdAt: now,
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 30,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _isEditMode ? 'Edit TO DO' : 'Add TO DO',
              style: AppTypography.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 20),
            _Field(
              controller: _titleCtrl,
              label: 'TO DO Title',
              hint: 'e.g. Collect Requirements',
              required: true,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _descCtrl,
              label: 'Description',
              hint: 'Describe the work to be done...',
              maxLines: 3,
              required: true,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _studentCtrl,
              label: 'Student Name (optional)',
              hint: 'e.g. Kavitha R',
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _noteCtrl,
              label: 'Note (optional)',
              hint: 'Any additional notes...',
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ScaleTapWidget(
              onTap: _loading ? null : _onSubmit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : Text(
                          _isEditMode ? 'Save Changes' : 'Add TO DO',
                          style:
                              AppTypography.button.copyWith(fontSize: 14),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool required;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: AppTypography.body.copyWith(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTypography.bodySecondary.copyWith(fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            filled: true,
            fillColor: AppColors.surfaceGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryRed, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryRed, width: 1.5),
            ),
          ),
          validator: required
              ? (v) => (v == null || v.trim().isEmpty)
                  ? 'This field is required'
                  : null
              : null,
        ),
      ],
    );
  }
}
