import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/task_card.dart';
import 'create_task_modal.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = "";
  String _selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final statuses = ["All", "To Do", "In Progress", "Review", "Rework", "Done"];

        final filteredTasks = data.tasks.where((t) {
          final q = _searchQuery.toLowerCase();
          final matchesQuery = t.taskTitle.toLowerCase().contains(q) ||
              t.projectType.toLowerCase().contains(q) ||
              t.taskType.toLowerCase().contains(q) ||
              t.assignedEmployee.toLowerCase().contains(q);
          final matchesStatus = _selectedStatus == "All" ||
              t.status.toUpperCase() == _selectedStatus.toUpperCase() ||
              (_selectedStatus == "Review" && t.status.toUpperCase() == "TESTING");
          return matchesQuery && matchesStatus;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: "Tasks"),
          floatingActionButton: SizedBox(
            height: 40,
            child: FloatingActionButton.extended(
              heroTag: 'tasks_fab',
              onPressed: () => CreateTaskModal.show(context),
              backgroundColor: AppColors.primary,
              elevation: 4,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              icon: const Icon(Icons.add_task_rounded, color: AppColors.white, size: 18),
              label: Text(
                "Create Task",
                style: AppTypography.button.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Summary Badge Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Tasks",
                            style: AppTypography.label.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                          Text(
                            "${data.tasks.length}",
                            style: AppTypography.summaryNumber.copyWith(fontSize: 22, height: 1.1),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${data.tasks.where((t) => t.status != 'DONE').length} Pending",
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTypography.body.copyWith(fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: "Search tasks by title, project or employee...",
                      hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 13),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: statuses.map((status) {
                      final isSelected = _selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: AppColors.primary,
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                          labelStyle: AppTypography.label.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // Tasks List
                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                size: 40,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 12),
                              Text("No tasks found", style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                              const SizedBox(height: 4),
                              Text("Try adjusting your search or status filter", style: AppTypography.bodySecondary),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredTasks.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: 40 * index),
                              child: TaskCard(
                                task: task,
                                onTap: () {
                                  Navigator.of(context).push(
                                    AppPageRoute.create(
                                      TaskDetailsScreen(task: task),
                                    ),
                                  );
                                },
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
