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
  String _selectedDomain = 'All';

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

        // Collect unique domains
        final domains = ['All', ...{...myProjects.map((p) => p.domain)}];

        final filteredProjects = myProjects.where((p) {
          final matchesDomain = _selectedDomain == 'All' || p.domain.toLowerCase() == _selectedDomain.toLowerCase();
          if (!matchesDomain) return false;

          if (_searchQuery.trim().isEmpty) return true;
          final query = _searchQuery.trim().toLowerCase();
          return p.projectName.toLowerCase().contains(query) ||
              p.collegeName.toLowerCase().contains(query) ||
              p.domain.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  "My Projects",
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
                    "${myProjects.length}",
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
                  hint: "Search projects by name, college or domain...",
                  controller: _searchController,
                  prefixIcon: Icons.search_rounded,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Domain Filter Chips
                if (domains.length > 2) ...[
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
                            onSelected: (selected) {
                              setState(() {
                                _selectedDomain = domain;
                              });
                            },
                            backgroundColor: AppColors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
                ] else
                  const SizedBox(height: 4),

                // Project Cards List
                Expanded(
                  child: filteredProjects.isEmpty
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
                                  Icons.folder_off_outlined,
                                  size: 38,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No projects found",
                                style: AppTypography.cardTitle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _searchQuery.isNotEmpty || _selectedDomain != 'All'
                                    ? "Try refining your search or filter"
                                    : "Projects assigned by Admin will appear here",
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
                              delay: Duration(milliseconds: 60 * index),
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
