import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/project_card.dart';
import '../../widgets/primary_button.dart';
import 'create_project_modal.dart';
import 'project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final filteredProjects = data.projects.where((p) {
          final q = _searchQuery.toLowerCase();
          return p.projectName.toLowerCase().contains(q) ||
              p.collegeName.toLowerCase().contains(q) ||
              p.domain.toLowerCase().contains(q) ||
              (p.assignedEmployee != null &&
                  p.assignedEmployee!.toLowerCase().contains(q));
        }).toList();

        return Scaffold(
          appBar: const CustomAppBar(title: "Projects"),
          floatingActionButton: SizedBox(
            height: 34,
            child: FloatingActionButton.extended(
              heroTag: 'projects_fab',
              onPressed: () => CreateProjectModal.show(context),
              backgroundColor: AppColors.primaryRed,
              elevation: 3,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              icon: const Icon(Icons.add_rounded, color: AppColors.white, size: 14),
              label: Text(
                "Create Project",
                style: AppTypography.button.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Projects Summary Badge Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderGray),
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
                      // Subtle Glassmorphism Project Layers Icon Container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(8.5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primaryRed.withAlpha(51),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryRed.withAlpha(13),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.layers_outlined,
                              color: AppColors.primaryRed,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Projects",
                            style: AppTypography.label.copyWith(fontSize: 12),
                          ),
                          Text(
                            "${data.totalProjects}",
                            style: AppTypography.summaryNumber.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

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
                      hintText: "Search by project name, college, domain or assignee...",
                      hintStyle: AppTypography.bodySecondary,
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.mediumGray),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Projects (${filteredProjects.length})",
                      style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredProjects.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.folder_off_outlined,
                                size: 56,
                                color: AppColors.lightGray,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No projects found",
                                style: AppTypography.cardTitle,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 180,
                                child: PrimaryButton(
                                  text: "Create Project",
                                  onPressed: () => CreateProjectModal.show(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredProjects.length,
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: index * 80),
                              child: ProjectCard(
                                project: project,
                                onTap: () {
                                  Navigator.of(context).push(
                                    AppPageRoute.create(
                                      ProjectDetailsScreen(projectId: project.id),
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
