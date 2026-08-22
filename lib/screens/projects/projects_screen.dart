import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/project_card.dart';
import 'create_project_modal.dart';
import 'project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _searchQuery = "";
  String _selectedDomain = "All";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final data = DummyDataProvider();
        final domains = ["All", ...data.projects.map((p) => p.domain).toSet()];

        final filteredProjects = data.projects.where((p) {
          final q = _searchQuery.toLowerCase();
          final matchesQuery = p.projectName.toLowerCase().contains(q) ||
              p.collegeName.toLowerCase().contains(q) ||
              p.domain.toLowerCase().contains(q) ||
              (p.assignedEmployee != null &&
                  p.assignedEmployee!.toLowerCase().contains(q));
          final matchesDomain = _selectedDomain == "All" || p.domain == _selectedDomain;
          return matchesQuery && matchesDomain;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: "Projects"),
          floatingActionButton: SizedBox(
            height: 40,
            child: FloatingActionButton.extended(
              heroTag: 'projects_fab',
              onPressed: () => CreateProjectModal.show(context),
              backgroundColor: AppColors.primary,
              elevation: 4,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              icon: const Icon(Icons.add_rounded, color: AppColors.white, size: 18),
              label: Text(
                "Create Project",
                style: AppTypography.button.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Metrics & Search Bar
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
                          Icons.folder_open_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Projects",
                            style: AppTypography.label.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                          Text(
                            "${data.totalProjects}",
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
                          "${data.projects.length} Active",
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

                // Search Box
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
                      hintText: "Search projects, colleges or leads...",
                      hintStyle: AppTypography.bodySecondary.copyWith(fontSize: 13),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Domain Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: domains.map((domain) {
                      final isSelected = _selectedDomain == domain;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(domain),
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
                              _selectedDomain = domain;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // Projects List
                Expanded(
                  child: filteredProjects.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder_off_outlined, size: 40, color: AppColors.textMuted),
                              const SizedBox(height: 12),
                              Text("No projects found", style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                              const SizedBox(height: 4),
                              Text("Try adjusting your search or domain filter", style: AppTypography.bodySecondary),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredProjects.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: 40 * index),
                              child: ProjectCard(
                                project: project,
                                onTap: () {
                                  Navigator.push(
                                    context,
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
