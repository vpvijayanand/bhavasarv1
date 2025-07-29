import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/animated/fade_in_animation.dart';
import '../../widgets/animated/slide_animation.dart';

class OTPVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const OTPVerificationScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late AnimationController _timerController;
  late Animation<double> _timerAnimation;
  int _resendTimer = 60;
  bool _canResend = false;

  String get phoneNumber => widget.arguments['phoneNumber'] as String;
  String? get password => widget.arguments['password'] as String?;
  bool get isLogin => widget.arguments['isLogin'] as bool;

  @override
  void initState() {
    super.initState();
    _setupTimer();
    _startResendTimer();
  }

  void _setupTimer() {
    _timerController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );

    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_timerController);

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _startResendTimer() {
    _timerController.forward();
    _resendTimer = 60;
    _canResend = false;

    // Update timer display
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timerController.dispose();
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
                  _buildOTPForm(),
                  const SizedBox(height: 24),
                  _buildResendSection(),
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
              Icons.sms,
              size: 60,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.verifyOtp,
            style: AppStyles.heading1.copyWith(
              color: AppColors.textLight,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the 6-digit code sent to',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '+91 $phoneNumber',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOTPForm() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.enterOtp,
              style: AppStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOTPDigit(index)),
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomButton(
                  text: AppStrings.verifyOtp,
                  onPressed: () => _handleOTPVerification(authProvider),
                  isLoading: authProvider.isLoading,
                  icon: Icons.verified_user,
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
    );
  }

  Widget _buildOTPDigit(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primary
              : AppColors.divider,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: AppStyles.heading2.copyWith(
          color: AppColors.primary,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _buildResendSection() {
    return SlideAnimation(
      delay: const Duration(milliseconds: 600),
      child: Column(
        children: [
          if (!_canResend) ...[
            AnimatedBuilder(
              animation: _timerAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: _timerAnimation.value,
                        backgroundColor: AppColors.textLight.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.accent,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resend in $_resendTimer seconds',
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.textLight.withOpacity(0.8),
                      ),
                    ),
                  ],
                );
              },
            ),
          ] else ...[
            CustomButton(
              text: AppStrings.resendOtp,
              onPressed: _handleResendOTP,
              isSecondary: true,
              icon: Icons.refresh,
              width: 200,
            ),
          ],
        ],
      ),
    );
  }

  void _handleOTPVerification(AuthProvider authProvider) async {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    bool success;
    if (isLogin) {
      success = await authProvider.verifyLoginOTP(otp);
    } else {
      success = await authProvider.verifyOTPAndRegister(
        otp,
        phoneNumber,
        password!,
      );
    }

    if (success && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
            (route) => false,
      );
    }
  }

  void _handleResendOTP() async {
    final authProvider = context.read<AuthProvider>();
    bool success = await authProvider.sendOTP(phoneNumber);

    if (success) {
      _startResendTimer();
      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}