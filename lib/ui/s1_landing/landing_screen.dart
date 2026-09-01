import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/soft_3d_button.dart';
import '../../core/widgets/soft_3d_card.dart';
import '../../core/widgets/soft_3d_text_field.dart';
import '../../data/services/mock_data_service.dart';
import '../s2_signup/signup_screen.dart';
import '../s4_discover/discover_screen.dart';
import '../admin/developer_admin_screen.dart';

/// S1: Welcome / Login / Signup Landing Screen
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  final MockDataService _dataService = MockDataService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showLoginSheet(BuildContext context) {
    final emailController = TextEditingController(text: 'aditya.varma@cet.ac.in');
    final passwordController = TextEditingController(text: 'cet12345');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Log in with your CET college email credentials',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Soft3DTextField(
                label: 'College Email ID',
                hintText: 'e.g. yourname@cet.ac.in',
                controller: emailController,
                prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 14),
              Soft3DTextField(
                label: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                controller: passwordController,
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              Soft3DButton(
                text: 'Sign In to Campus Hub',
                icon: Icons.login_rounded,
                onPressed: () {
                  _dataService.login(emailController.text, passwordController.text);
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DiscoverScreen()),
                  );
                },
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'Quick Demo Personas',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Soft3DButton(
                      text: 'Student Demo',
                      type: Soft3DButtonType.secondary,
                      height: 42,
                      icon: Icons.school_rounded,
                      onPressed: () {
                        _dataService.loginAsDemo('student');
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DiscoverScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Soft3DButton(
                      text: 'Club Leader',
                      type: Soft3DButtonType.secondary,
                      height: 42,
                      icon: Icons.groups_rounded,
                      onPressed: () {
                        _dataService.loginAsDemo('clubLeader');
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DiscoverScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Campus Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.iceBlue,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1.2),
                          boxShadow: AppShadows.soft3dChip,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.hub_rounded, size: 16, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'COLLEGE OF ENGINEERING TRIVANDRUM',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Center 3D Branding & Welcome Illustration
                  Column(
                    children: [
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft 3D Glow Ring
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: 0.08),
                              ),
                            ),
                            // Elevated 3D Center Emblem
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.soft3dButton,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.school_rounded,
                                  size: 54,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to CET',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Your campus hub to connect with peers, discover dynamic clubs, schedule activities, and collaborate.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary.withValues(alpha: 0.9),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Main Action Cards
                  Column(
                    children: [
                      Soft3DCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Soft3DButton(
                              text: 'Create New Account (Sign Up)',
                              icon: Icons.person_add_alt_1_rounded,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Soft3DButton(
                              text: 'Already have an account? Sign In',
                              type: Soft3DButtonType.secondary,
                              icon: Icons.login_rounded,
                              onPressed: () => _showLoginSheet(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Developer Admin Option
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DeveloperAdminScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.lightBlueTint),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.admin_panel_settings_rounded, size: 16, color: AppColors.textSecondary),
                              SizedBox(width: 6),
                              Text(
                                'Developer & Admin Console',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
