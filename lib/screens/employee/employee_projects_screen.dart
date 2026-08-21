import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/employee_project_card.dart';
import '../../widgets/custom_text_field.dart';
import 'employee_project_details_screen.dart';

class EmployeeProjectsScreen extends StatefulWidget {
  final EmployeeModel loggedInEmployee;

  const EmployeeProjectsScreen({
    super.key,
    required this.loggedInEmployee,
  });

  @override
  State<EmployeeProjectsScreen> createState() => _EmployeeProjectsScreenState();
}

class _EmployeeProjectsScreenState extends State<EmployeeProjectsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

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
        final myProjects = provider.getProjectsByEmployee(widget.loggedInEmployee.employeeName);
        final filteredProjects = myProjects.where((p) {
          if (_searchQuery.trim().isEmpty) return true;
          final query = _searchQuery.trim().toLowerCase();
          return p.projectName.toLowerCase().contains(query) ||
              p.collegeName.toLowerCase().contains(query) ||
              p.domain.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              "My Projects",
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
                  hint: "Search projects by name, college or domain...",
                  controller: _searchController,
                  prefixIcon: Icons.search_rounded,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredProjects.isEmpty
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
                                  Icons.folder_off_outlined,
                                  size: 40,
                                  color: AppColors.lightGray,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No projects assigned yet",
                                style: AppTypography.cardTitle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? "No projects matching \"$_searchQuery\""
                                    : "Projects assigned to you by Admin will appear here",
                                style: AppTypography.bodySecondary,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredProjects.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
                            return FadeSlideTransition(
                              delay: Duration(milliseconds: 70 * index),
                              child: EmployeeProjectCard(
                                project: project,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    AppPageRoute.create(
                                      EmployeeProjectDetailsScreen(
                                        project: project,
                                        loggedInEmployee: widget.loggedInEmployee,
                                      ),
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
