import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/animations/app_animations.dart';
import '../../data/dummy_data.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../navigation/super_admin_navigation.dart';
import '../../navigation/admin_navigation.dart';
import '../../navigation/employee_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "superadmin@kevorch.com");
  final _passwordController = TextEditingController(text: "super123");
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate subtle auth delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      // 1. Check Super Admin Credentials
      if (email == "superadmin@kevorch.com" && (password == "super123" || password == "admin123")) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          AppPageRoute.create(const SuperAdminNavigation()),
        );
        return;
      }

      // 2. Check Admin Credentials
      if (email == "admin@kevorch.com" && password == "admin123") {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          AppPageRoute.create(const AdminNavigation()),
        );
        return;
      }

      // 3. Check Employee Credentials via DummyDataProvider
      final provider = DummyDataProvider();
      final employee = provider.getEmployeeByEmail(email);
      final isValidEmpPassword = password == "emp@123" || password == "emp123" || password == "admin123";

      if (employee != null && isValidEmpPassword) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          AppPageRoute.create(
            EmployeeNavigation(loggedInEmployee: employee),
          ),
        );
        return;
      }

      // 4. Invalid credentials error state
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid email or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 100),
                      child: Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primaryRed.withAlpha(80),
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.bolt_rounded,
                              color: AppColors.primaryRed,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          Text(
                            "KEVOCH PRO",
                            style: AppTypography.pageTitle.copyWith(
                              fontSize: 28,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Sign in to manage projects, employees and tasks",
                            style: AppTypography.bodySecondary,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    if (_errorMessage != null) ...[
                      FadeSlideTransition(
                        delay: Duration.zero,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRedLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryRed.withAlpha(100)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppColors.primaryRed, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.primaryRedDark,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 300),
                      child: CustomTextField(
                        label: "Email Address",
                        hint: "Enter email (e.g. superadmin@kevorch.com)",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter email address";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 400),
                      child: CustomTextField(
                        label: "Password",
                        hint: "Enter your password",
                        controller: _passwordController,
                        isPassword: true,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 500),
                      child: PrimaryButton(
                        text: "Login",
                        icon: Icons.arrow_forward_rounded,
                        isLoading: _isLoading,
                        onPressed: _handleLogin,
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeSlideTransition(
                      delay: const Duration(milliseconds: 600),
                      child: Column(
                        children: [
                          Text(
                            "Protected KEVOCH PRO SaaS Portal v1.0",
                            style: AppTypography.bodySecondary.copyWith(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Super Admin: superadmin@kevorch.com (super123)\nAdmin: admin@kevorch.com (admin123)  •  Emp: employee@kevorch.com (emp@123)",
                            style: AppTypography.bodySecondary.copyWith(
                              fontSize: 10,
                              color: AppColors.mediumGray.withAlpha(180),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
