import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';

class EmployeeTodoDetailsScreen extends StatefulWidget {
  final EmployeeTodoModel todo;
  final EmployeeModel loggedInEmployee;

  const EmployeeTodoDetailsScreen({
    super.key,
    required this.todo,
    required this.loggedInEmployee,
  });

  @override
  State<EmployeeTodoDetailsScreen> createState() =>
      _EmployeeTodoDetailsScreenState();
}

class _EmployeeTodoDetailsScreenState extends State<EmployeeTodoDetailsScreen> {
  bool _submitting = false;
  bool _submitted = false;

  Future<void> _onSubmitTap() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Submit TO DO?',
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        content: Text(
          'Once submitted, this TO DO will be permanently locked and cannot be edited.',
          style: AppTypography.body.copyWith(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: AppTypography.label.copyWith(
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Submit',
              style: AppTypography.label.copyWith(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 250));

    DummyDataProvider().submitEmployeeTodo(widget.todo.id);

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) Navigator.pop(context);
  }

  void _onEditTap() {
    _TodoBottomSheet.show(
      context,
      projectId: widget.todo.projectId,
      employeeId: widget.loggedInEmployee.id,
      existing: widget.todo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final todos = provider.getTodosByProject(widget.todo.projectId);
        final live = todos.firstWhere(
          (t) => t.id == widget.todo.id,
          orElse: () => widget.todo,
        );

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'TO DO Details',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            actions: [
              if (live.isPending)
                TextButton.icon(
                  onPressed: _onEditTap,
                  icon: const Icon(Icons.edit_outlined,
                      size: 16, color: AppColors.black),
                  label: Text(
                    'Edit',
                    style: AppTypography.label.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.borderGray, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Status + Title ───────────────────────────────────────────
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 60),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          live.title,
                          style: AppTypography.pageTitle.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: _StatusBadge(
                          key: ValueKey(live.status),
                          status: live.status,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Submitted lock banner ─────────────────────────────────────
                if (live.isSubmitted) ...[
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF16A34A).withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded,
                              size: 16, color: Color(0xFF16A34A)),
                          const SizedBox(width: 8),
                          Text(
                            'Submitted — Read Only',
                            style: AppTypography.label.copyWith(
                              color: const Color(0xFF16A34A),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Main Details Card ─────────────────────────────────────────
                FadeSlideTransition(
                  delay: const Duration(milliseconds: 130),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: AppColors.borderGray, width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          icon: Icons.description_outlined,
                          label: 'Description',
                          value: live.description,
                          multiLine: true,
                        ),
                        if (live.studentName != null &&
                            live.studentName!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.borderGray, height: 1),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Student',
                            value: live.studentName!,
                          ),
                        ],
                        if (live.note != null && live.note!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.borderGray, height: 1),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: Icons.sticky_note_2_outlined,
                            label: 'Note',
                            value: live.note!,
                            multiLine: true,
                          ),
                        ],
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.borderGray, height: 1),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.access_time_rounded,
                          label: 'Created',
                          value:
                              '${live.createdDateStr} • ${live.createdTimeStr}',
                        ),
                        if (live.isSubmitted &&
                            live.submittedDateStr != null) ...[
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.borderGray, height: 1),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Submitted',
                            value:
                                '${live.submittedDateStr} • ${live.submittedTimeStr}',
                            valueColor: const Color(0xFF16A34A),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Submit Button (PENDING only) ──────────────────────────────
                if (live.isPending)
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: _submitted
                        ? _SuccessConfirmation()
                        : ScaleTapWidget(
                            onTap: _submitting ? null : _onSubmitTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _submitting
                                    ? AppColors.primaryRed.withAlpha(180)
                                    : AppColors.primaryRed,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryRed.withAlpha(50),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _submitting
                                  ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.send_rounded,
                                          color: AppColors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Submit TO DO',
                                          style: AppTypography.button.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success Confirmation Widget
// ─────────────────────────────────────────────────────────────────────────────

class _SuccessConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'Submitted Successfully',
            style: AppTypography.button.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'PENDING';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPending
            ? AppColors.surfaceGray
            : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPending ? AppColors.borderGray : const Color(0xFF16A34A).withAlpha(80),
        ),
      ),
      child: Text(
        isPending ? 'Pending' : 'Submitted',
        style: AppTypography.label.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isPending ? AppColors.mediumGray : const Color(0xFF16A34A),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail Row
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool multiLine;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.multiLine = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 17, color: AppColors.mediumGray),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: AppTypography.label.copyWith(fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColors.darkGray,
              height: multiLine ? 1.5 : 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit TO DO Bottom Sheet  (reused for both ADD and EDIT modes)
// ─────────────────────────────────────────────────────────────────────────────

class _TodoBottomSheet extends StatefulWidget {
  final String projectId;
  final String employeeId;
  final EmployeeTodoModel? existing; // null = ADD mode, non-null = EDIT mode

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
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
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
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
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
            // Handle
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

            _SheetField(
              controller: _titleCtrl,
              label: 'TO DO Title',
              hint: 'e.g. Collect Requirements',
              required: true,
            ),
            const SizedBox(height: 14),
            _SheetField(
              controller: _descCtrl,
              label: 'Description',
              hint: 'Describe the work to be done...',
              maxLines: 3,
              required: true,
            ),
            const SizedBox(height: 14),
            _SheetField(
              controller: _studentCtrl,
              label: 'Student Name (optional)',
              hint: 'e.g. Kavitha R',
            ),
            const SizedBox(height: 14),
            _SheetField(
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
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isEditMode ? 'Save Changes' : 'Add TO DO',
                          style: AppTypography.button.copyWith(fontSize: 14),
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

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool required;

  const _SheetField({
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
              borderSide:
                  const BorderSide(color: AppColors.borderGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.borderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.primaryRed, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.primaryRed, width: 1.5),
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
