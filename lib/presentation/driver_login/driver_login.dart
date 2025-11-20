import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/login_form_widget.dart';
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

  // Mock credentials for testing
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
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    final fullPhone = phone.startsWith('+976') ? phone : '+976$phone';
    final phoneWithoutCode = phone.replaceAll('+976', '');

    bool isValidCredentials = false;

    // Check various phone number formats
    if (_mockCredentials.containsKey(phone) &&
        _mockCredentials[phone] == password) {
      isValidCredentials = true;
    } else if (_mockCredentials.containsKey(phoneWithoutCode) &&
        _mockCredentials[phoneWithoutCode] == password) {
      isValidCredentials = true;
    } else if (_mockCredentials.containsKey(fullPhone) &&
        _mockCredentials[fullPhone] == password) {
      isValidCredentials = true;
    }

    setState(() {
      _isLoading = false;
    });

    if (isValidCredentials) {
      // Success haptic feedback
      HapticFeedback.heavyImpact();

      // Show biometric prompt for first-time login
      setState(() {
        _showBiometricPrompt = true;
      });
    } else {
      // Error haptic feedback
      HapticFeedback.vibrate();

      // Show error message
      if (mounted) {
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
  }

  void _handleBiometricSetup() {
    setState(() {
      _showBiometricPrompt = false;
    });

    // Navigate to dashboard
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/driver-dashboard',
          (route) => false,
    );

    // Show success message
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
    setState(() {
      _showBiometricPrompt = false;
    });

    // Navigate to dashboard
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/driver-dashboard',
          (route) => false,
    );
  }

  void _handleRegisterNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Бүртгэлийн хуудас удахгүй нэмэгдэнэ'),
        duration: Duration(seconds: 2),
      ),
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
            // Main Content
            // Main Content
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

                        // App Logo
                        const AppLogoWidget(),

                        SizedBox(height: 6.h),

                        // Login Form
                        LoginFormWidget(
                          onLogin: _handleLogin,
                          isLoading: _isLoading,
                        ),

                        Spacer(),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Шинэ жолооч уу? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading ? null : _handleRegisterNavigation,
                              child: Text(
                                'Бүртгүүлэх',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Biometric Prompt Overlay
            if (_showBiometricPrompt)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
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