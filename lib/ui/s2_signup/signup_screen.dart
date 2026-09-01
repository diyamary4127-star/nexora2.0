import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/soft_3d_button.dart';
import '../../core/widgets/soft_3d_card.dart';
import '../../core/widgets/soft_3d_text_field.dart';
import '../../data/services/mock_data_service.dart';
import '../s3_profile_setup/profile_setup_screen.dart';

/// S2: Signup Page with college email & password
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onProceedToProfileSetup() {
    if (_formKey.currentState?.validate() ?? false) {
      MockDataService().startSignup(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(
            initialEmail: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Indicator Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.iceBlue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                    boxShadow: AppShadows.soft3dChip,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.looks_one_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'STEP 1 OF 2 : CREDENTIALS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Join the CET\nCommunity',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up using your official CET college email address to unlock student discovery, clubs, and activity tracking.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Form Card
                Soft3DCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Soft3DTextField(
                        label: 'College Email Address',
                        hintText: 'name.rollno@cet.ac.in',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.school_outlined, color: AppColors.primary),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your college email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Soft3DTextField(
                        label: 'Create Password',
                        hintText: 'At least 6 characters',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Soft3DTextField(
                        label: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        prefixIcon: const Icon(Icons.shield_outlined, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Soft3DButton(
                        text: 'Continue to Profile Setup (S3)',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _onProceedToProfileSetup,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Quick hint
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
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
