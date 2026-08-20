import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/task_card.dart';
import '../../widgets/primary_button.dart';
import 'create_task_modal.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final filteredTasks = data.tasks.where((t) {
          final q = _searchQuery.toLowerCase();
          return t.taskTitle.toLowerCase().contains(q) ||
              t.projectType.toLowerCase().contains(q) ||
              t.taskType.toLowerCase().contains(q) ||
              t.assignedEmployee.toLowerCase().contains(q);
        }).toList();

        return Scaffold(
          appBar: const CustomAppBar(title: "Tasks"),
          floatingActionButton: SizedBox(
            height: 34,
            child: FloatingActionButton.extended(
              heroTag: 'tasks_fab',
              onPressed: () => CreateTaskModal.show(context),
              backgroundColor: AppColors.primaryRed,
              elevation: 3,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              icon: const Icon(Icons.add_task_rounded, color: AppColors.white, size: 14),
              label: Text(
                "Create Task",
                style: AppTypography.button.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search tasks by title, type or employee...",
                      hintStyle: AppTypography.bodySecondary,
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.mediumGray),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "All Assigned Tasks (${filteredTasks.length})",
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                size: 56,
                                color: AppColors.lightGray,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No tasks found",
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 180,
                                child: PrimaryButton(
                                  text: "Create Task",
                                  onPressed: () => CreateTaskModal.show(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: index * 80),
                              child: TaskCard(
                                task: task,
                                onTap: () {
                                  Navigator.of(context).push(
                                    AppPageRoute.create(
                                      TaskDetailsScreen(taskId: task.id),
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
