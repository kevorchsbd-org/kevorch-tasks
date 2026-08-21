import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/student_submission_read_only_view.dart';
import '../../widgets/project_timeline.dart';
import '../../widgets/student_process_card.dart';
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
  int _selectedTab = 0; // 0: Overview, 1: Students, 2: Work, 3: Submissions, 4: Timeline
  String _submissionFilter = 'All'; // All | Draft | Submitted
  int _workSubTab = 0; // 0: TO DO, 1: Process, 2: My Tasks
  String? _selectedStudentId;

  void _openStudentSubmissionForm(StudentSubmissionModel? submission, {bool initialReviewMode = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudentSubmissionBottomSheet(
        projectId: widget.project.id,
        employeeId: widget.loggedInEmployee.id,
        submission: submission,
        initialReviewMode: initialReviewMode,
      ),
    );
  }

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

        // Project student registry
        final projectSubmissions = provider.getStudentSubmissionsByProject(widget.project.id);
        final deduplicatedSubmissions = <String, StudentSubmissionModel>{};
        for (final sub in projectSubmissions) {
          final key = sub.registerNumber.trim().isNotEmpty
              ? sub.registerNumber.trim()
              : sub.studentName.trim();
          if (key.isNotEmpty && !deduplicatedSubmissions.containsKey(key)) {
            deduplicatedSubmissions[key] = sub;
          }
        }
        final studentsList = deduplicatedSubmissions.values.toList();

        // Submissions filter & sort
        final filteredSubs = projectSubmissions.where((s) {
          if (_submissionFilter == 'All') return true;
          return s.status.toLowerCase() == _submissionFilter.toLowerCase();
        }).toList();
        filteredSubs.sort((a, b) {
          if (a.status != b.status) {
            return a.status == 'DRAFT' ? -1 : 1;
          }
          return b.createdAt.compareTo(a.createdAt);
        });

        // Project tasks
        final projectTasks = provider.getTasksByEmployee(widget.loggedInEmployee.employeeName)
            .where((t) => t.projectType.toUpperCase() == widget.project.projectName.toUpperCase())
            .toList();

        final isProjectCompleted = updatedProject.status == ProjectStatus.completed;

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
          floatingActionButton: isProjectCompleted
              ? null
              : (_selectedTab == 0
                  ? (_workSubTab == 0
                      ? FloatingActionButton.small(
                          onPressed: () => _TodoBottomSheet.show(
                            context,
                            projectId: widget.project.id,
                            employeeId: widget.loggedInEmployee.id,
                          ),
                          backgroundColor: AppColors.primaryRed,
                          elevation: 3,
                          child: const Icon(Icons.add_rounded, color: AppColors.white, size: 20),
                        )
                      : _workSubTab == 1
                          ? FloatingActionButton.small(
                              onPressed: () => _openAddProcessBottomSheet(context, studentsList),
                              backgroundColor: AppColors.primaryRed,
                              elevation: 3,
                              child: const Icon(Icons.add_rounded, color: AppColors.white, size: 20),
                            )
                          : null)
                  : _selectedTab == 1
                      ? FloatingActionButton.small(
                          onPressed: () => _openStudentSubmissionForm(null),
                          backgroundColor: AppColors.primaryRed,
                          elevation: 3,
                          child: const Icon(Icons.add_rounded, color: AppColors.white, size: 20),
                        )
                      : null),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Scrollable Tab Bar
              Container(
                height: 42,
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 3,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final tabs = ['Overview', 'Submissions', 'Timeline'];
                    final title = tabs[index];
                    final isSelected = _selectedTab == index;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = index),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryRedLight.withAlpha(128)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryRed : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          title,
                          style: AppTypography.label.copyWith(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? AppColors.primaryRed : AppColors.mediumGray,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(color: AppColors.borderGray, height: 1),

              // Scrollable Tab Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildTabContent(
                    context,
                    updatedProject: updatedProject,
                    allTodos: allTodos,
                    filteredTodos: filteredTodos,
                    studentsList: studentsList,
                    filteredSubs: filteredSubs,
                    projectTasks: projectTasks,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required ProjectModel updatedProject,
    required List<EmployeeTodoModel> allTodos,
    required List<EmployeeTodoModel> filteredTodos,
    required List<StudentSubmissionModel> studentsList,
    required List<StudentSubmissionModel> filteredSubs,
    required List<TaskModel> projectTasks,
  }) {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab(
          context,
          updatedProject: updatedProject,
          allTodos: allTodos,
          filteredTodos: filteredTodos,
          projectTasks: projectTasks,
        );
      case 1:
        return _buildSubmissionsTab(context, filteredSubs);
      case 2:
        return _buildTimelineTab(context, updatedProject);
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewTab(
    BuildContext context, {
    required ProjectModel updatedProject,
    required List<EmployeeTodoModel> allTodos,
    required List<EmployeeTodoModel> filteredTodos,
    required List<TaskModel> projectTasks,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlideTransition(
          delay: const Duration(milliseconds: 60),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderGray, width: 1.0),
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
                            style: AppTypography.bodySecondary.copyWith(fontSize: 14),
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
                      updatedProject.assignedDate != null
                          ? '${updatedProject.assignedDate!.day} ${const ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][updatedProject.assignedDate!.month]} ${updatedProject.assignedDate!.year}'
                          : updatedProject.createdDate,
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
        const SizedBox(height: 24),
        _buildWorkTab(context, allTodos, filteredTodos, updatedProject, projectTasks),
      ],
    );
  }

  Widget _buildTodoTab(
    BuildContext context,
    List<EmployeeTodoModel> allTodos,
    List<EmployeeTodoModel> filteredTodos,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TO DO Checklist',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['All', 'Pending', 'Submitted'].map((f) {
              final active = _todoFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _todoFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primaryRed : AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? AppColors.primaryRed : AppColors.borderGray,
                      ),
                    ),
                    child: Text(
                      f,
                      style: AppTypography.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active ? AppColors.white : AppColors.mediumGray,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        filteredTodos.isEmpty
            ? _emptyTodoState(context)
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTodos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return FadeSlideTransition(
                    delay: Duration(milliseconds: 60 + index * 30),
                    child: _TodoCard(
                      todo: todo,
                      loggedInEmployee: widget.loggedInEmployee,
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildSubmissionsTab(BuildContext context, List<StudentSubmissionModel> filteredSubs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Student Submissions',
                style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton.icon(
              onPressed: () => _openStudentSubmissionForm(null),
              icon: const Icon(Icons.add_rounded, size: 16, color: AppColors.primaryRed),
              label: Text(
                'New Submission',
                style: AppTypography.label.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['All', 'Draft', 'Submitted'].map((f) {
              final active = _submissionFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _submissionFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primaryRed : AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppColors.primaryRed : AppColors.borderGray),
                    ),
                    child: Text(
                      f,
                      style: AppTypography.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active ? AppColors.white : AppColors.mediumGray,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (filteredSubs.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.assignment_turned_in_outlined, size: 48, color: AppColors.lightGray),
                const SizedBox(height: 12),
                Text('No student submissions yet', style: AppTypography.cardTitle.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  'Create a student submission when student details and documents are ready.',
                  style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ScaleTapWidget(
                  onTap: () => _openStudentSubmissionForm(null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, color: AppColors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'New Student Submission',
                          style: AppTypography.label.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredSubs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final s = filteredSubs[index];
              final isSubmitted = s.status == 'SUBMITTED';

              final createdDateStr = '${s.createdAt.day} ${_monthName(s.createdAt.month)} ${s.createdAt.year}';
              final submittedDateStr = s.submittedAt != null
                  ? '${s.submittedAt!.day} ${_monthName(s.submittedAt!.month)} ${s.submittedAt!.year}'
                  : null;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGray),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            s.studentName,
                            style: AppTypography.cardTitle.copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSubmitted ? const Color(0xFFDCFCE7) : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s.status,
                            style: AppTypography.label.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSubmitted ? const Color(0xFF16A34A) : AppColors.mediumGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reg No: ${s.registerNumber} • ${s.department}',
                      style: AppTypography.bodySecondary.copyWith(fontSize: 12.5),
                    ),
                    if (s.documentName != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.mediumGray),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                s.documentName!,
                                style: AppTypography.bodySecondary.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderGray, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isSubmitted
                                ? 'Submitted: $submittedDateStr'
                                : 'Created: $createdDateStr',
                            style: AppTypography.bodySecondary.copyWith(fontSize: 11.5),
                          ),
                        ),
                        Row(
                          children: [
                            if (!isSubmitted) ...[
                              TextButton(
                                onPressed: () => _openStudentSubmissionForm(s),
                                child: Text(
                                  'Edit',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            TextButton(
                              onPressed: () {
                                if (isSubmitted) {
                                  StudentSubmissionReadOnlyView.show(context, s);
                                } else {
                                  _openStudentSubmissionForm(s, initialReviewMode: true);
                                }
                              },
                              child: Text(
                                'View',
                                style: AppTypography.label.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildWorkTab(
    BuildContext context,
    List<EmployeeTodoModel> allTodos,
    List<EmployeeTodoModel> filteredTodos,
    ProjectModel updatedProject,
    List<TaskModel> projectTasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-navigation segmented control
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _buildSubTabItem(0, 'TO DO'),
              _buildSubTabItem(1, 'Process'),
              _buildSubTabItem(2, 'My Tasks'),
            ],
          ),
        ),

        // Render sub-tab content
        if (_workSubTab == 0)
          _buildTodoTab(context, allTodos, filteredTodos)
        else if (_workSubTab == 1)
          _buildProcessTab(context, updatedProject)
        else if (_workSubTab == 2)
          _buildTasksTab(context, projectTasks),
      ],
    );
  }

  Widget _buildSubTabItem(int subTabIndex, String title) {
    final isSelected = _workSubTab == subTabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _workSubTab = subTabIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: AppTypography.label.copyWith(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.black : AppColors.mediumGray,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessTab(BuildContext context, ProjectModel project) {
    final provider = DummyDataProvider();
    final projectSubmissions = provider.getStudentSubmissionsByProject(project.id);
    
    // Deduplicate students
    final deduplicatedStudents = <String, String>{}; // registerNumber -> studentName
    for (var sub in projectSubmissions) {
      final key = sub.registerNumber.trim().isNotEmpty ? sub.registerNumber.trim() : sub.studentName.trim();
      if (key.isNotEmpty) {
        deduplicatedStudents[key] = sub.studentName;
      }
    }

    final students = deduplicatedStudents.entries.toList();

    // Default to the first student if none selected
    if (_selectedStudentId == null && students.isNotEmpty) {
      _selectedStudentId = students.first.key;
    }

    final selectedStudentName = students.isEmpty ? '' : students.firstWhere((e) => e.key == _selectedStudentId, orElse: () => students.first).value;

    final processes = provider.getProcessesByProject(project.id)
        .where((p) => p.studentId == _selectedStudentId || p.studentName == selectedStudentName)
        .toList();

    // Sort: most recent first
    processes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Student Processes',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderGray),
              ),
              child: Text(
                '${processes.length} logs',
                style: AppTypography.label.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Horizontal list of students to filter processes
        if (students.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderGray),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_outline_rounded, color: AppColors.mediumGray),
                const SizedBox(width: 10),
                Text(
                  'Add students first to log processes.',
                  style: AppTypography.bodySecondary,
                ),
              ],
            ),
          )
        else ...[
          Text(
            'Select Student:',
            style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.mediumGray),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final isSelected = student.key == _selectedStudentId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedStudentId = student.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.black : AppColors.surfaceGray,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isSelected ? AppColors.black : AppColors.borderGray),
                      ),
                      child: Text(
                        student.value,
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.white : AppColors.mediumGray,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          
          if (processes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGray),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined, size: 40, color: AppColors.lightGray),
                  const SizedBox(height: 12),
                  Text(
                    'No process updates for $selectedStudentName',
                    style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Click the FAB (+) to log a new process update.',
                    style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: processes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final process = processes[index];
                return StudentProcessCard(
                  process: process,
                  onEdit: () => _openAddProcessBottomSheet(context, projectSubmissions, existing: process),
                  onSubmit: () => _showSubmitProcessConfirmation(context, process.id),
                );
              },
            ),
        ],
      ],
    );
  }

  void _openAddProcessBottomSheet(
    BuildContext context,
    List<StudentSubmissionModel> studentSubmissions, {
    StudentProcessModel? existing,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudentProcessBottomSheet(
        projectId: widget.project.id,
        employeeId: widget.loggedInEmployee.id,
        studentSubmissions: studentSubmissions,
        selectedStudentId: _selectedStudentId,
        existing: existing,
      ),
    );
  }

  void _showSubmitProcessConfirmation(BuildContext context, String processId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Submit Process Update?',
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        content: Text(
          'Once submitted, this process update will become read-only.',
          style: AppTypography.body.copyWith(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.label.copyWith(color: AppColors.mediumGray, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              DummyDataProvider().submitStudentProcess(processId);
              
              // Show success state dialog
              showDialog(
                context: context,
                builder: (successCtx) => AlertDialog(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Process Update Submitted',
                        style: AppTypography.cardTitle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The student process history has been updated and locked.',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(successCtx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Text(
              'Submit',
              style: AppTypography.label.copyWith(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(BuildContext context, List<TaskModel> projectTasks) {
    if (projectTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.assignment_outlined, size: 48, color: AppColors.lightGray),
            const SizedBox(height: 12),
            Text('No tasks for this project', style: AppTypography.cardTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              'Tasks assigned to you under this project will appear here.',
              style: AppTypography.bodySecondary.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Project Tasks',
          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projectTasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final task = projectTasks[index];
            return Container(
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.taskTitle,
                          style: AppTypography.cardTitle.copyWith(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: task.status == 'COMPLETED' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.status,
                          style: AppTypography.label.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: task.status == 'COMPLETED' ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.taskDescription,
                    style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.borderGray, width: 0.8),
                          ),
                          child: Text(
                            "${task.projectType} • ${task.taskType}",
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              color: AppColors.darkGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event_outlined, size: 13, color: AppColors.mediumGray),
                          const SizedBox(width: 4),
                          Text(
                            "Due ${task.dueDate}",
                            style: AppTypography.bodySecondary.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimelineTab(BuildContext context, ProjectModel project) {
    final provider = DummyDataProvider();
    final validation = provider.validateProjectClosure(project.id);
    final isValid = validation['isValid'] == true;
    final incompleteItems = List<String>.from(validation['incompleteItems'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Journey',
          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        
        // Timeline station tracker widget
        ProjectTimeline(
          project: project,
          isAdmin: false, // Employee view only
        ),
        
        const SizedBox(height: 24),
        const Divider(color: AppColors.borderGray, height: 1),
        const SizedBox(height: 20),

        // Closure Stage Details
        if (project.currentTimelineStage == 'Project Closure') ...[
          Text(
            'Project Closure Stage',
            style: AppTypography.sectionTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          
          // Closure Summary Card
          _buildClosureSummaryCard(context, project),
          
          const SizedBox(height: 16),
          
          if (!isValid) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Prerequisites Pending',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14, color: const Color(0xFFB45309)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...incompleteItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                        Expanded(
                          child: Text(
                            item,
                            style: AppTypography.bodySecondary.copyWith(fontSize: 12, color: const Color(0xFF78350F)),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          if (project.closureRequestedAt != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Closure Requested successfully. Mapped to final Admin review.',
                      style: AppTypography.cardTitle.copyWith(fontSize: 14, color: const Color(0xFF065F46)),
                    ),
                  ),
                ],
              ),
            )
          else
            ScaleTapWidget(
              onTap: isValid ? () => _handleRequestClosure(context, project.id) : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isValid ? AppColors.black : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Request Project Closure',
                  style: AppTypography.label.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ] else if (project.currentTimelineStage == 'Completed') ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lock_rounded, color: Color(0xFF16A34A), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Project Completed & Locked',
                      style: AppTypography.cardTitle.copyWith(fontSize: 15, color: const Color(0xFF15803D)),
                    ),
                  ],
                ),
                if (project.completedAt != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Completion Date: ${_formatDate(project.completedAt!)}',
                    style: AppTypography.bodySecondary.copyWith(fontSize: 12, color: const Color(0xFF16A34A)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildClosureSummaryCard(BuildContext context, ProjectModel project) {
    final provider = DummyDataProvider();
    final students = provider.getStudentSubmissionsByProject(project.id);
    final todos = provider.getTodosByProject(project.id);
    final processes = provider.getProcessesByProject(project.id);

    final requiredTodos = todos.where((t) => t.isRequired).toList();
    final completedRequiredTodos = requiredTodos.where((t) => t.status == 'SUBMITTED').toList();

    final requiredProcesses = processes.where((p) => p.isRequired).toList();
    final submittedRequiredProcesses = requiredProcesses.where((p) => p.status == 'SUBMITTED').toList();

    final requiredSubs = students.where((s) => s.isRequired).toList();
    final submittedRequiredSubs = requiredSubs.where((s) => s.status == 'SUBMITTED').toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow('Total Students Mapped', '${students.length}'),
          const SizedBox(height: 8),
          _summaryRow('Required TO DOs', '${completedRequiredTodos.length} / ${requiredTodos.length} completed'),
          const SizedBox(height: 8),
          _summaryRow('Required Process Logs', '${submittedRequiredProcesses.length} / ${requiredProcesses.length} submitted'),
          const SizedBox(height: 8),
          _summaryRow('Required Submissions', '${submittedRequiredSubs.length} / ${requiredSubs.length} submitted'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySecondary.copyWith(fontSize: 13, color: const Color(0xFF4B5563)),
        ),
        Text(
          value,
          style: AppTypography.cardTitle.copyWith(fontSize: 13),
        ),
      ],
    );
  }

  void _handleRequestClosure(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Request Project Closure?',
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        content: Text(
          'This will submit a closure request to the Admin. Once confirmed by the Admin, the workspace will become read-only.',
          style: AppTypography.body.copyWith(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.label.copyWith(color: AppColors.mediumGray, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              DummyDataProvider().requestProjectClosure(projectId);
              
              // Success dialog
              showDialog(
                context: context,
                builder: (successCtx) => AlertDialog(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Closure Request Submitted',
                        style: AppTypography.cardTitle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your request was sent to the Admin team for review.',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(successCtx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Text(
              'Submit Request',
              style: AppTypography.label.copyWith(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }

  String _monthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month];
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

class _StudentSubmissionBottomSheet extends StatefulWidget {
  final String projectId;
  final String employeeId;
  final StudentSubmissionModel? submission;
  final bool initialReviewMode;

  const _StudentSubmissionBottomSheet({
    required this.projectId,
    required this.employeeId,
    this.submission,
    this.initialReviewMode = false,
  });

  @override
  State<_StudentSubmissionBottomSheet> createState() =>
      _StudentSubmissionBottomSheetState();
}

class _StudentSubmissionBottomSheetState
    extends State<_StudentSubmissionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _regController;
  late final TextEditingController _deptController;
  late final TextEditingController _collegeController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;

  String? _docName;
  String? _docPath;
  String? _docType;
  String? _docSize;

  bool _isReviewMode = false;
  bool _loading = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _isReviewMode = widget.initialReviewMode;
    final sub = widget.submission;
    _nameController = TextEditingController(text: sub?.studentName ?? '');
    _regController = TextEditingController(text: sub?.registerNumber ?? '');
    _deptController = TextEditingController(text: sub?.department ?? '');
    _collegeController = TextEditingController(text: sub?.college ?? '');
    _emailController = TextEditingController(text: sub?.email ?? '');
    _phoneController = TextEditingController(text: sub?.phone ?? '');
    _notesController = TextEditingController(text: sub?.notes ?? '');

    _docName = sub?.documentName;
    _docPath = sub?.documentPath;
    _docType = sub?.documentType;
    _docSize = sub?.documentSize;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regController.dispose();
    _deptController.dispose();
    _collegeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _pickMockDocument() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Document (Simulation)',
              style: AppTypography.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _mockDocTile('report.pdf', 'PDF', '1.2 MB'),
            _mockDocTile('transcript.pdf', 'PDF', '850 KB'),
            _mockDocTile('proposal.docx', 'DOCX', '640 KB'),
          ],
        ),
      ),
    );
  }

  Widget _mockDocTile(String name, String type, String size) {
    return ListTile(
      leading: const Icon(Icons.description_outlined, color: AppColors.primaryRed),
      title: Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text('$type • $size', style: AppTypography.bodySecondary.copyWith(fontSize: 11)),
      onTap: () {
        setState(() {
          _docName = name;
          _docPath = '/simulated/documents/$name';
          _docType = type;
          _docSize = size;
        });
        Navigator.pop(context);
      },
    );
  }

  void _onReview() {
    if (!_formKey.currentState!.validate()) return;
    if (_docName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach a document before final submission.'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }
    setState(() {
      _isReviewMode = true;
    });
  }

  void _onSubmit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Submit Student Record?',
            style: AppTypography.cardTitle.copyWith(fontSize: 17)),
        content: Text(
          'Once submitted, the student details and attached document will be permanently locked and cannot be edited.',
          style: AppTypography.bodySecondary.copyWith(fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTypography.label.copyWith(color: AppColors.mediumGray)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _performFinalSubmit();
            },
            child: Text('Submit',
                style: AppTypography.label.copyWith(
                    color: AppColors.primaryRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _performFinalSubmit() async {
    setState(() {
      _loading = true;
    });

    // Simulate short loading delay (200-300ms)
    await Future.delayed(const Duration(milliseconds: 250));

    final provider = DummyDataProvider();
    final isNew = widget.submission == null;

    final submissionId =
        widget.submission?.id ?? 'sub_${DateTime.now().millisecondsSinceEpoch}';
    final model = StudentSubmissionModel(
      id: submissionId,
      projectId: widget.projectId,
      employeeId: widget.employeeId,
      studentName: _nameController.text.trim(),
      registerNumber: _regController.text.trim(),
      department: _deptController.text.trim(),
      college: _collegeController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      notes: _notesController.text.trim(),
      documentName: _docName,
      documentPath: _docPath,
      documentType: _docType,
      documentSize: _docSize,
      status: 'DRAFT', // Saved as draft first
      createdAt: widget.submission?.createdAt ?? DateTime.now(),
    );

    if (isNew) {
      provider.addStudentSubmission(model);
    } else {
      provider.updateStudentSubmission(model);
    }

    // Perform the formal submit step
    provider.submitStudentSubmission(submissionId);

    setState(() {
      _loading = false;
      _success = true;
    });

    // Success checkmark delay (500-700ms)
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _saveDraft() {
    final provider = DummyDataProvider();
    final isNew = widget.submission == null;
    final submissionId =
        widget.submission?.id ?? 'sub_${DateTime.now().millisecondsSinceEpoch}';

    final model = StudentSubmissionModel(
      id: submissionId,
      projectId: widget.projectId,
      employeeId: widget.employeeId,
      studentName: _nameController.text.trim(),
      registerNumber: _regController.text.trim(),
      department: _deptController.text.trim(),
      college: _collegeController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      notes: _notesController.text.trim(),
      documentName: _docName,
      documentPath: _docPath,
      documentType: _docType,
      documentSize: _docSize,
      status: 'DRAFT',
      createdAt: widget.submission?.createdAt ?? DateTime.now(),
    );

    if (isNew) {
      provider.addStudentSubmission(model);
    } else {
      provider.updateStudentSubmission(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return Container(
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                'Submission Completed',
                style: AppTypography.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                'Student record locked successfully.',
                style: AppTypography.bodySecondary,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: _isReviewMode ? _buildReviewLayout() : _buildEditFormLayout(),
        ),
      ),
    );
  }

  Widget _buildEditFormLayout() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.submission == null
                    ? 'New Student Submission'
                    : 'Edit Student Submission',
                style: AppTypography.cardTitle.copyWith(fontSize: 17),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Field(
              controller: _nameController,
              label: 'Student Name',
              hint: 'Enter full name',
              required: true),
          const SizedBox(height: 12),
          _Field(
              controller: _regController,
              label: 'Register Number',
              hint: 'Enter university reg number',
              required: true),
          const SizedBox(height: 12),
          _Field(
              controller: _deptController,
              label: 'Department',
              hint: 'e.g. Computer Science',
              required: true),
          const SizedBox(height: 12),
          _Field(
              controller: _collegeController,
              label: 'College',
              hint: 'e.g. IIT Madras',
              required: true),
          const SizedBox(height: 12),
          _Field(
              controller: _emailController,
              label: 'Email (Optional)',
              hint: 'student@domain.edu'),
          const SizedBox(height: 12),
          _Field(
              controller: _phoneController,
              label: 'Phone (Optional)',
              hint: 'Enter mobile number'),
          const SizedBox(height: 12),
          _Field(
              controller: _notesController,
              label: 'Notes (Optional)',
              hint: 'Additional remarks...',
              maxLines: 3),
          const SizedBox(height: 18),

          // Document section
          Text(
            'Upload Document',
            style: AppTypography.label
                .copyWith(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (_docName == null)
            OutlinedButton.icon(
              onPressed: _pickMockDocument,
              icon: const Icon(Icons.attach_file_rounded, size: 16),
              label: const Text('Attach Document (Simulation)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: AppColors.borderGray),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGray),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf_outlined,
                      color: AppColors.primaryRed, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _docName!,
                          style: AppTypography.body
                              .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${_docType ?? "PDF"} • ${_docSize ?? "0 KB"}',
                          style: AppTypography.bodySecondary.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        size: 16, color: AppColors.mediumGray),
                    tooltip: 'Replace Document',
                    onPressed: _pickMockDocument,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: AppColors.primaryRed),
                    tooltip: 'Remove Document',
                    onPressed: () {
                      setState(() {
                        _docName = null;
                        _docPath = null;
                        _docType = null;
                        _docSize = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saveDraft,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.borderGray),
                  ),
                  child: Text('Save Draft',
                      style:
                          AppTypography.button.copyWith(color: AppColors.darkGray)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ScaleTapWidget(
                  onTap: _onReview,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Review Submission',
                        style: AppTypography.button.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewLayout() {
    final provider = DummyDataProvider();
    final project = provider.getProjectById(widget.projectId);
    final employee = provider.getEmployeeById(widget.employeeId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Review Submission',
              style: AppTypography.cardTitle.copyWith(fontSize: 17),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Read-only info sections
        _buildSectionTitle('Student Information'),
        const SizedBox(height: 8),
        _buildPreviewField('Student Name', _nameController.text),
        _buildPreviewField('Register Number', _regController.text),
        _buildPreviewField('Department', _deptController.text),
        _buildPreviewField('College', _collegeController.text),
        if (_emailController.text.isNotEmpty)
          _buildPreviewField('Email', _emailController.text),
        if (_phoneController.text.isNotEmpty)
          _buildPreviewField('Phone', _phoneController.text),
        if (_notesController.text.isNotEmpty)
          _buildPreviewField('Notes', _notesController.text),
        const SizedBox(height: 16),

        _buildSectionTitle('Attached Document'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGray),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined,
                  color: AppColors.primaryRed, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _docName ?? 'No document',
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_docType ?? "PDF"} • ${_docSize ?? "0 KB"}',
                      style: AppTypography.bodySecondary.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildSectionTitle('Submission Context'),
        const SizedBox(height: 8),
        _buildPreviewField('Project', project?.projectName ?? 'Unknown Project'),
        _buildPreviewField(
            'Employee', employee?.employeeName ?? 'Unknown Employee'),
        const SizedBox(height: 24),

        if (_loading)
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: AppColors.primaryRed, strokeWidth: 2),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isReviewMode = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.borderGray),
                  ),
                  child: Text('Back to Edit',
                      style:
                          AppTypography.button.copyWith(color: AppColors.darkGray)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ScaleTapWidget(
                  onTap: _onSubmit,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Submit Record',
                        style: AppTypography.button.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
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

  Widget _buildPreviewField(String label, String value) {
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
                fontSize: 12.5,
                color: AppColors.mediumGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentProcessBottomSheet extends StatefulWidget {
  final String projectId;
  final String employeeId;
  final List<StudentSubmissionModel> studentSubmissions;
  final String? selectedStudentId;
  final StudentProcessModel? existing;

  const _StudentProcessBottomSheet({
    required this.projectId,
    required this.employeeId,
    required this.studentSubmissions,
    this.selectedStudentId,
    this.existing,
  });

  @override
  State<_StudentProcessBottomSheet> createState() => _StudentProcessBottomSheetState();
}

class _StudentProcessBottomSheetState extends State<_StudentProcessBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _noteController;
  
  String? _chosenStudentId;
  String? _selectedDocument;
  bool _isRequired = true;
  bool _saving = false;

  final List<String> _mockFiles = ['report.pdf', 'transcript.pdf', 'proposal.docx'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existing?.title ?? '');
    _descController = TextEditingController(text: widget.existing?.description ?? '');
    _noteController = TextEditingController(text: widget.existing?.note ?? '');
    
    _isRequired = widget.existing?.isRequired ?? true;
    _selectedDocument = widget.existing?.referenceDocumentName;
    
    // Mapped student registry deduplication
    final studentIds = widget.studentSubmissions.map((s) => s.registerNumber).toSet().toList();
    if (widget.existing != null) {
      _chosenStudentId = widget.existing!.studentId;
    } else if (widget.selectedStudentId != null && studentIds.contains(widget.selectedStudentId)) {
      _chosenStudentId = widget.selectedStudentId;
    } else if (studentIds.isNotEmpty) {
      _chosenStudentId = studentIds.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSave(bool submit) async {
    if (!_formKey.currentState!.validate()) return;
    if (_chosenStudentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a student.')),
      );
      return;
    }

    final provider = DummyDataProvider();
    final student = widget.studentSubmissions.firstWhere(
      (s) => s.registerNumber == _chosenStudentId,
      orElse: () => widget.studentSubmissions.first,
    );

    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 250));

    if (widget.existing != null) {
      final updated = StudentProcessModel(
        id: widget.existing!.id,
        projectId: widget.existing!.projectId,
        employeeId: widget.existing!.employeeId,
        studentId: _chosenStudentId,
        studentName: student.studentName,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        referenceDocumentName: _selectedDocument,
        status: submit ? 'SUBMITTED' : 'DRAFT',
        isRequired: _isRequired,
        createdAt: widget.existing!.createdAt,
        submittedAt: submit ? DateTime.now() : null,
      );
      provider.updateStudentProcess(updated);
      if (submit) {
        provider.submitStudentProcess(updated.id);
      }
    } else {
      final newProcess = StudentProcessModel(
        id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
        projectId: widget.projectId,
        employeeId: widget.employeeId,
        studentId: _chosenStudentId,
        studentName: student.studentName,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        referenceDocumentName: _selectedDocument,
        status: submit ? 'SUBMITTED' : 'DRAFT',
        isRequired: _isRequired,
        createdAt: DateTime.now(),
        submittedAt: submit ? DateTime.now() : null,
      );
      provider.addStudentProcess(newProcess);
      if (submit) {
        provider.submitStudentProcess(newProcess.id);
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(submit ? 'Process log submitted and locked.' : 'Draft process update saved.'),
          backgroundColor: const Color(0xFF16A34A),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Deduplicate students
    final Map<String, String> deduplicatedList = {};
    for (var s in widget.studentSubmissions) {
      final key = s.registerNumber.trim().isNotEmpty ? s.registerNumber.trim() : s.studentName.trim();
      deduplicatedList[key] = s.studentName;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom sheet handler
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                widget.existing != null ? 'Edit Process Update' : 'Add Student Process Log',
                style: AppTypography.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),

              // Student selection dropdown
              Text(
                'Student Name',
                style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.mediumGray),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGray),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _chosenStudentId,
                    onChanged: widget.existing != null
                        ? null // lock student mapping during edit
                        : (val) => setState(() => _chosenStudentId = val),
                    items: deduplicatedList.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          style: AppTypography.body.copyWith(fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Process Title
              Text(
                'Process Title *',
                style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.mediumGray),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: AppTypography.body.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Completed initial design feedback review',
                  fillColor: AppColors.surfaceGray,
                  filled: true,
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
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Description *',
                style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.mediumGray),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: AppTypography.body.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Detail what work has been completed...',
                  fillColor: AppColors.surfaceGray,
                  filled: true,
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
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),

              // Note
              Text(
                'Note (Optional)',
                style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.mediumGray),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLines: 2,
                style: AppTypography.body.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Any extra remarks, warnings or rework instructions...',
                  fillColor: AppColors.surfaceGray,
                  filled: true,
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
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Reference Document Dropdown
              Text(
                'Reference Document (Optional)',
                style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.mediumGray),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGray,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderGray),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedDocument,
                          hint: Text('Select file reference', style: AppTypography.bodySecondary.copyWith(fontSize: 12)),
                          onChanged: (val) => setState(() => _selectedDocument = val),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('None (No document attached)'),
                            ),
                            ..._mockFiles.map((file) => DropdownMenuItem<String>(
                              value: file,
                              child: Text(file),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_selectedDocument != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.primaryRed),
                      onPressed: () => setState(() => _selectedDocument = null),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              // Required for Closure toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required for Closure',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Must be submitted to close the project.',
                        style: AppTypography.bodySecondary.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: _isRequired,
                    activeTrackColor: AppColors.primaryRedLight,
                    activeThumbColor: AppColors.primaryRed,
                    onChanged: (val) => setState(() => _isRequired = val),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form Action Buttons
              Row(
                children: [
                  // Save Draft Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving ? null : () => _onSave(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.black),
                      ),
                      child: Text(
                        'Save Draft',
                        style: AppTypography.label.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Submit Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saving ? null : () => _onSave(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                          : Text(
                              'Submit',
                              style: AppTypography.label.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
