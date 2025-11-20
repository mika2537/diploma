import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

import 'widgets/app_logo_widget.dart';
import 'widgets/biometric_prompt_widget.dart';
import 'widgets/login_form_widget.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  bool _isLoading = false;
  bool _showBiometricPrompt = false;
  final ScrollController _scrollController = ScrollController();

  final Map<String, String> _mockCredentials = {
    'admin': 'admin123',
    '99123456': 'driver123',
    '88765432': 'test123',
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String phone, String password) async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    final fullPhone = phone.startsWith('+976') ? phone : '+976$phone';
    final phoneWithoutCode = phone.replaceAll('+976', '');

    bool valid = false;

    if (_mockCredentials[phone] == password) valid = true;
    if (_mockCredentials[phoneWithoutCode] == password) valid = true;
    if (_mockCredentials[fullPhone] == password) valid = true;

    setState(() => _isLoading = false);

    if (valid) {
      HapticFeedback.heavyImpact();
      setState(() => _showBiometricPrompt = true);
    } else {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Утасны дугаар эсвэл нууц үг буруу байна'),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }
  }

  void _handleBiometricSetup() {
    setState(() => _showBiometricPrompt = false);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/driver-dashboard',
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Биометрик нэвтрэлт идэвхжлээ'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _handleSkipBiometric() {
    setState(() => _showBiometricPrompt = false);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/driver-dashboard',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8.h),

                        const AppLogoWidget(),
                        SizedBox(height: 6.h),

                        LoginFormWidget(
                          onLogin: _handleLogin,
                          isLoading: _isLoading,
                          onForgotPassword: () {
                            Navigator.pushNamed(context, '/forgot_password');
                          },
                          onRegister: () {
                            Navigator.pushNamed(context, '/driver_register');
                          },
                        ),

                        const Spacer(),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (_showBiometricPrompt)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: BiometricPromptWidget(
                      onEnableBiometric: _handleBiometricSetup,
                      onSkip: _handleSkipBiometric,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}