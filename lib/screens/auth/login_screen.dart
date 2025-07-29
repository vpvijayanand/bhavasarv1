import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/animated/fade_in_animation.dart';
import '../../widgets/animated/slide_animation.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildRegistrationForm(),
                  const SizedBox(height: 24),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.textLight.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textLight.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_add,
              size: 60,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Join Our Community',
            style: AppStyles.heading1.copyWith(
              color: AppColors.textLight,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Register to connect with ${AppStrings.appName}',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return SlideAnimation(
      delay: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.textLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.register,
                style: AppStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: AppStrings.mobileNumber,
                controller: _phoneController,
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                maxLength: 10,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.password,
                controller: _passwordController,
                prefixIcon: Icons.lock,
                suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                onSuffixIconTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                prefixIcon: Icons.lock_outline,
                suffixIcon: _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                onSuffixIconTap: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                obscureText: _obscureConfirmPassword,
                validator: (value) => Validators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
              ),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: AppStrings.register,
                    onPressed: () => _handleRegistration(authProvider),
                    isLoading: authProvider.isLoading,
                    icon: Icons.person_add,
                  );
                },
              ),
              if (context.watch<AuthProvider>().errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Text(
                    context.watch<AuthProvider>().errorMessage!,
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return SlideAnimation(
      delay: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(
              AppStrings.login,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegistration(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      bool success = await authProvider.sendOTP(_phoneController.text.trim());

      if (success && mounted) {
        Navigator.of(context).pushNamed(
          '/otp-verification',
          arguments: {
            'phoneNumber': _phoneController.text.trim(),
            'password': _passwordController.text,
            'isLogin': false,
          },
        );
      }
    }
  }
}