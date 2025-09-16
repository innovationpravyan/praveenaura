import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String? _emailError;
  bool _emailSent = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoading != previous?.isLoading) return;

      if (next.error != null) {
        context.showErrorSnackBar(next.error!);
        ref.read(authProvider.notifier).clearError();
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.textHighEmphasisColor,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: context.responsiveContentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 4.h(context)),
                        _buildHeader(),
                        SizedBox(height: 6.h(context)),
                        if (!_emailSent) ...[
                          _buildResetForm(authState),
                        ] else ...[
                          _buildSuccessMessage(),
                        ],
                        SizedBox(height: 4.h(context)),
                        _buildBackToLoginLink(),
                        SizedBox(height: 2.h(context)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.lock_reset,
          size: 20.w(context),
          color: context.primaryColor,
        ),
        SizedBox(height: 3.h(context)),
        Text(
          'Forgot Password?',
          style: context.headlineLarge.copyWith(
            color: context.textHighEmphasisColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h(context)),
        Text(
          _emailSent
              ? 'Check your email for reset instructions'
              : 'Enter your email address and we\'ll send you a link to reset your password',
          style: context.bodyMedium.copyWith(
            color: context.textMediumEmphasisColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResetForm(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: context.labelLarge.copyWith(
              color: context.textHighEmphasisColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h(context)),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: _validateEmail,
            onFieldSubmitted: (_) => _handleResetPassword(),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.textMediumEmphasisColor,
                size: 5.w(context),
              ),
              errorText: _emailError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w(context)),
                borderSide: BorderSide(color: context.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w(context)),
                borderSide: BorderSide(color: context.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w(context)),
                borderSide: BorderSide(color: context.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w(context)),
                borderSide: BorderSide(color: context.errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w(context)),
                borderSide: BorderSide(color: context.errorColor, width: 2),
              ),
            ),
          ),
          SizedBox(height: 4.h(context)),
          _buildResetButton(authState),
        ],
      ),
    );
  }

  Widget _buildResetButton(AuthState authState) {
    final isFormValid = _isFormValid();
    final isLoading = authState.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 6.h(context),
      child: ElevatedButton(
        onPressed: isFormValid && !isLoading ? _handleResetPassword : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? context.primaryColor
              : context.textDisabledColor,
          foregroundColor: AppColors.white,
          elevation: isFormValid ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w(context)),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 5.w(context),
                height: 5.w(context),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                'Send Reset Link',
                style: context.titleMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: EdgeInsets.all(4.w(context)),
      decoration: BoxDecoration(
        color: AppColors.successLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3.w(context)),
        border: Border.all(color: AppColors.successLight.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.successLight,
            size: 12.w(context),
          ),
          SizedBox(height: 2.h(context)),
          Text(
            'Email Sent Successfully!',
            style: context.titleLarge.copyWith(
              color: AppColors.successLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h(context)),
          Text(
            'We\'ve sent a password reset link to ${_emailController.text.trim()}. Please check your email and follow the instructions.',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h(context)),
          TextButton(
            onPressed: _handleResendEmail,
            child: Text(
              'Didn\'t receive the email? Resend',
              style: context.bodyMedium.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Remember your password? ',
          style: context.bodyMedium.copyWith(
            color: context.textMediumEmphasisColor,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Back to Login',
            style: context.bodyMedium.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }
    });
  }

  bool _isFormValid() {
    return _emailController.text.isNotEmpty && _emailError == null;
  }

  Future<void> _handleResetPassword() async {
    if (!_isFormValid()) return;

    final email = _emailController.text.trim();
    _validateEmail(email);

    if (_emailError != null) return;

    try {
      await ref.read(authProvider.notifier).sendPasswordResetEmail(email);

      setState(() {
        _emailSent = true;
      });

      context.showSuccessSnackBar('Password reset email sent successfully!');
    } catch (e) {
      // Error handling is done in the listener
    }
  }

  void _handleResendEmail() {
    setState(() {
      _emailSent = false;
    });
  }
}
