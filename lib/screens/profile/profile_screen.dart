import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/session/session_roles.dart';
import '../../core/session/session_service.dart';
import '../../data/dummy_data.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String role;
  final String? employeeId;

  const ProfileScreen({
    super.key,
    required this.role,
    this.employeeId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _appVersion = "1.0.0";
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  void _loadVersionInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (_) {
      // Fallback
    }
  }

  void _handleLogout(BuildContext context) {
    if (_loggingOut) return;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Logout?',
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTypography.body.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.label.copyWith(color: AppColors.mediumGray),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              setState(() {
                _loggingOut = true;
              });

              final navigator = Navigator.of(context);

              // Clear session
              await SessionService.clearSession();

              // Clear entire navigation stack and redirect to LoginScreen
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              'Logout',
              style: AppTypography.label.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolve user display info
    String displayName = "";
    String email = SessionService.getEmail() ?? "";
    String roleBadgeText = "";

    if (widget.role == SessionRoles.employee) {
      final empId = widget.employeeId ?? SessionService.getEmployeeId();
      final employee = empId != null ? DummyDataProvider().getEmployeeById(empId) : null;
      displayName = employee?.employeeName ?? "Employee User";
      email = employee?.email ?? email;
      roleBadgeText = "Employee";
    } else if (widget.role == SessionRoles.admin) {
      displayName = "Admin User";
      roleBadgeText = "Admin";
    } else if (widget.role == SessionRoles.superAdmin) {
      displayName = "Super Admin";
      roleBadgeText = "Super Admin";
    } else {
      displayName = "Kevorch User";
      roleBadgeText = "User";
    }

    final String initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : "K";

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: AppTypography.sectionTitle.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Premium Profile Header Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderGray),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar representation with initials
                      Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        displayName,
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: AppTypography.bodySecondary.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: Text(
                          roleBadgeText,
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 2. Profile Information Header
                Text(
                  'Account Settings',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 14, color: AppColors.mediumGray),
                ),
                const SizedBox(height: 8),

                // 3. Information & Logout Section
                Material(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.borderGray),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded, color: AppColors.mediumGray),
                        title: Text(
                          'App Version',
                          style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        trailing: Text(
                          _appVersion,
                          style: AppTypography.bodySecondary.copyWith(fontSize: 14),
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderGray),
                      ListTile(
                        onTap: () => _handleLogout(context),
                        leading: const Icon(Icons.logout_rounded, color: AppColors.primaryRed),
                        title: Text(
                          'Logout',
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
