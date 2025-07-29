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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient().hasMatch(value)) {
    return 'Enter a valid mobile number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional in our case
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}
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
    _buildLoginForm(),
    const SizedBox(height: 24),
    _buildRegisterLink(),
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
              Icons.account_balance,
              size: 60,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.appName,
            style: AppStyles.heading1.copyWith(
              color: AppColors.textLight,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tagline,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
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
                AppStrings.login,
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
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: AppStrings.login,
                    onPressed: () => _handleLogin(authProvider),
                    isLoading: authProvider.isLoading,
                    icon: Icons.login,
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

  Widget _buildRegisterLink() {
    return SlideAnimation(
      delay: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: Text(
              AppStrings.register,
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

  void _handleLogin(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      bool success = await authProvider.login(
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushNamed(
          '/otp-verification',
          arguments: {
            'phoneNumber': _phoneController.text.trim(),
            'isLogin': true,
          },
        );
      }
    }
  }
}