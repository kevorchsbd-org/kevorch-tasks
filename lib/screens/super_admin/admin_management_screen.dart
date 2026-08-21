import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/success_state_dialog.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddAdminModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final scopeCtrl = TextEditingController(text: "Project & Employee Administration");
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Register New System Admin",
                      style: AppTypography.cardTitle.copyWith(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.mediumGray),
                      onPressed: () => Navigator.pop(modalCtx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Admin Full Name",
                  hint: "e.g. Elena Rostova",
                  controller: nameCtrl,
                  validator: (val) => val == null || val.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: "Email Address",
                  hint: "e.g. elena@kevorch.com",
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || val.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: "Access Scope",
                  hint: "e.g. Operations & Compliance",
                  controller: scopeCtrl,
                  validator: (val) => val == null || val.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: "Create Admin Account",
                  icon: Icons.person_add_rounded,
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final newAdmin = AdminUserModel(
                        id: 'a_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        role: 'ADMIN',
                        accessScope: scopeCtrl.text.trim(),
                        createdDate: 'Today',
                        isActive: true,
                      );
                      DummyDataProvider().addAdminUser(newAdmin);
                      Navigator.pop(modalCtx);
                      SuccessStateDialog.show(
                        context,
                        title: "Admin Registered",
                        message: "${newAdmin.name} has been added as System Admin.",
                        onDismiss: () {},
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DummyDataProvider(),
      builder: (context, _) {
        final provider = DummyDataProvider();
        final admins = provider.adminUsers;
        final filteredAdmins = admins.where((a) {
          if (_searchQuery.trim().isEmpty) return true;
          final query = _searchQuery.trim().toLowerCase();
          return a.name.toLowerCase().contains(query) ||
              a.email.toLowerCase().contains(query) ||
              a.role.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              "Admin Management",
              style: AppTypography.pageTitle.copyWith(fontSize: 22),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: const Icon(Icons.person_add_outlined, color: AppColors.primaryRed),
                  onPressed: () => _showAddAdminModal(context),
                  tooltip: "Add Admin",
                ),
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.borderGray, height: 1),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: "",
                  hint: "Search admins by name, email or role...",
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
                  child: filteredAdmins.isEmpty
                      ? Center(
                          child: Text(
                            "No administrators found",
                            style: AppTypography.bodySecondary,
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredAdmins.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final admin = filteredAdmins[index];
                            final isSuper = admin.role.toUpperCase() == 'SUPER ADMIN';

                            return FadeSlideTransition(
                              delay: Duration(milliseconds: 60 * index),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSuper ? AppColors.primaryRed.withAlpha(80) : AppColors.borderGray,
                                    width: isSuper ? 1.5 : 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.cardShadow,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: isSuper ? AppColors.black : AppColors.surfaceGray,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSuper ? AppColors.primaryRed : AppColors.borderGray,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          admin.initials,
                                          style: TextStyle(
                                            color: isSuper ? AppColors.white : AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  admin.name,
                                                  style: AppTypography.cardTitle.copyWith(
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isSuper ? AppColors.primaryRedLight : AppColors.surfaceGray,
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: isSuper ? AppColors.primaryRed : AppColors.borderGray,
                                                  ),
                                                ),
                                                child: Text(
                                                  admin.role,
                                                  style: TextStyle(
                                                    color: isSuper ? AppColors.primaryRed : AppColors.darkGray,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            admin.email,
                                            style: AppTypography.bodySecondary.copyWith(
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Scope: ${admin.accessScope}",
                                            style: AppTypography.label.copyWith(
                                              fontSize: 11,
                                              color: AppColors.mediumGray,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!isSuper) ...[
                                      const SizedBox(width: 8),
                                      Switch(
                                        value: admin.isActive,
                                        activeThumbColor: AppColors.primaryRed,
                                        onChanged: (_) {
                                          provider.toggleAdminStatus(admin.id);
                                        },
                                      ),
                                    ],
                                  ],
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
