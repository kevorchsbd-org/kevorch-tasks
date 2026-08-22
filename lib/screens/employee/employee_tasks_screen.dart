import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/task_status_badge.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/custom_text_field.dart';
import 'employee_task_details_screen.dart';

class EmployeeTasksScreen extends StatefulWidget {
  final EmployeeModel loggedInEmployee;

  const EmployeeTasksScreen({
    super.key,
    required this.loggedInEmployee,
  });

  @override
  State<EmployeeTasksScreen> createState() => _EmployeeTasksScreenState();
}

class _EmployeeTasksScreenState extends State<EmployeeTasksScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';

  final List<String> _statusFilters = [
    'All',
    'TO DO',
    'IN PROGRESS',
    'REVIEW',
    'REWORK',
    'DONE',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final myTasks = provider.getTasksByEmployee(widget.loggedInEmployee.employeeName);

        final filteredTasks = myTasks.where((t) {
          final matchesStatus = _selectedStatus == 'All' ||
              t.status.toUpperCase() == _selectedStatus.toUpperCase();

          if (!matchesStatus) return false;

          if (_searchQuery.trim().isEmpty) return true;
          final query = _searchQuery.trim().toLowerCase();
          return t.taskTitle.toLowerCase().contains(query) ||
              t.taskDescription.toLowerCase().contains(query) ||
              t.projectType.toLowerCase().contains(query) ||
              t.taskType.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  "My Tasks",
                  style: AppTypography.pageTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${myTasks.length}",
                    style: AppTypography.label.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.border, height: 1),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                CustomTextField(
                  label: "",
                  hint: "Search tasks by title, category, project...",
                  controller: _searchController,
                  prefixIcon: Icons.search_rounded,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statusFilters.map((status) {
                      final isSelected = _selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                          backgroundColor: AppColors.white,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Task List
                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.assignment_turned_in_outlined,
                                  size: 38,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No tasks found",
                                style: AppTypography.cardTitle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _selectedStatus != 'All'
                                    ? "No tasks with status \"$_selectedStatus\""
                                    : "No tasks assigned to you yet",
                                style: AppTypography.bodySecondary,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredTasks.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: 50 * index),
                              child: ScaleTapWidget(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    AppPageRoute.create(
                                      EmployeeTaskDetailsScreen(
                                        task: task,
                                        loggedInEmployee: widget.loggedInEmployee,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border, width: 1),
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
                                              style: AppTypography.cardTitle.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TaskStatusBadge(status: task.status),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          PriorityBadge(priority: widget.loggedInEmployee.priority),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.surfaceGray,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: AppColors.border, width: 0.8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.folder_outlined, size: 12, color: AppColors.textSecondary),
                                                const SizedBox(width: 4),
                                                Text(
                                                  task.projectType,
                                                  style: AppTypography.label.copyWith(
                                                    fontSize: 11,
                                                    color: AppColors.textPrimary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.event_outlined,
                                                size: 13,
                                                color: AppColors.textMuted,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "Due ${task.dueDate}",
                                                style: AppTypography.bodySecondary.copyWith(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Open",
                                                style: AppTypography.label.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 13,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
