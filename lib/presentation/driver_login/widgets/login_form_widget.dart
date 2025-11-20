import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String phone, String password) onLogin;
  final bool isLoading;

  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    required this.isLoading,
    required this.onForgotPassword,
    required this.onRegister,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        _phoneController.text.length >= 8 && _passwordController.text.length >= 6;

    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Утасны дугаар оруулна уу';
    if (value.length < 8) return 'Утасны дугаар хамгийн багадаа 8 оронтой байх ёстой';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Нууц үг оруулна уу';
    if (value.length < 6) return 'Нууц үг хамгийн багадаа 6 тэмдэгттэй байх ёстой';
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.lightImpact();
      widget.onLogin(_phoneController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Утасны дугаар',
              hintText: '99123456',
              prefixIcon: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'phone',
                      color: colors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '+976',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      color: colors.outline,
                    ),
                  ],
                ),
              ),
              contentPadding:
              EdgeInsets.only(left: 20.w, right: 4.w, top: 2.h, bottom: 2.h),
            ),
            validator: _validatePhone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
          ),

          SizedBox(height: 2.h),

          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            onFieldSubmitted: (_) => _handleLogin(),
            decoration: InputDecoration(
              labelText: 'Нууц үг',
              hintText: 'Нууц үгээ оруулна уу',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: colors.primary,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName:
                  _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: colors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: widget.isLoading
                    ? null
                    : () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: _validatePassword,
          ),

          SizedBox(height: 1.h),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                'Нууц үгээ мартсан уу?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onRegister,
              child: Text(
                'Шинээр бүртгүүлэх',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed:
              (_isFormValid && !widget.isLoading) ? _handleLogin : null,
              child: widget.isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(colors.onPrimary),
                ),
              )
                  : Text(
                'Нэвтрэх',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}