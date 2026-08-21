import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/task_status_badge.dart';
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
    'TESTING',
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
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              "My Tasks",
              style: AppTypography.pageTitle.copyWith(fontSize: 22),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.borderGray, height: 1),
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
                const SizedBox(height: 14),

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
                          backgroundColor: AppColors.surfaceGray,
                          selectedColor: AppColors.primaryRed,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.darkGray,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryRed : AppColors.borderGray,
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
                                  color: AppColors.surfaceGray,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.assignment_turned_in_outlined,
                                  size: 40,
                                  color: AppColors.lightGray,
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
                              delay: Duration(milliseconds: 60 * index),
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
                                              style: AppTypography.cardTitle.copyWith(
                                                fontSize: 15,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TaskStatusBadge(status: task.status),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        task.taskDescription,
                                        style: AppTypography.bodySecondary.copyWith(
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.surfaceGray,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: AppColors.borderGray,
                                                  width: 0.8,
                                                ),
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
                                              const Icon(
                                                Icons.event_outlined,
                                                size: 13,
                                                color: AppColors.mediumGray,
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
