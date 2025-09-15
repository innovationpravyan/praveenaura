import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      context.unfocus();

      try {
        await ref
            .read(authProvider.notifier)
            .sendPasswordResetEmail(_emailController.text.trim());

        if (mounted) {
          setState(() {
            _isEmailSent = true;
          });
          context.showSuccessSnackBar(
            'Password reset email sent successfully!',
          );
        }
      } catch (e) {
        if (mounted) {
          context.showErrorSnackBar(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: _isEmailSent
              ? _buildSuccessContent()
              : _buildFormContent(authState),
        ),
      ),
    );
  }

  Widget _buildFormContent(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.largeSpacing),

          // Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPink.withAlpha(26),
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 50,
                color: AppColors.primaryPink,
              ),
            ),
          ),

          const SizedBox(height: AppConstants.largeSpacing),

          // Title and description
          Text(
            'Forgot Password?',
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.smallSpacing),

          Text(
            'Don\'t worry! It happens. Please enter the email address associated with your account.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.extraLargeSpacing),

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !authState.isLoading,
            validator: Validators.email,
            onFieldSubmitted: (_) => _sendResetEmail(),
            decoration: context.getInputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),

          const SizedBox(height: AppConstants.largeSpacing),

          // Send reset email button
          ElevatedButton(
            onPressed: authState.isLoading ? null : _sendResetEmail,
            child: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : const Text('Send Reset Email'),
          ),

          const SizedBox(height: AppConstants.mediumSpacing),

          // Back to login button
          TextButton(
            onPressed: authState.isLoading
                ? null
                : () => context.navigateToLogin(),
            child: Text(
              'Back to Login',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryPink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppConstants.largeSpacing),

        // Success icon
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withAlpha(26),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 50,
              color: AppColors.success,
            ),
          ),
        ),

        const SizedBox(height: AppConstants.largeSpacing),

        // Success message
        Text(
          'Email Sent!',
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.smallSpacing),

        Text(
          'We have sent a password reset email to:',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.smallSpacing),

        Text(
          _emailController.text.trim(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryPink,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.mediumSpacing),

        Container(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          decoration: BoxDecoration(
            color: AppColors.info.withAlpha(26),
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(color: AppColors.info.withAlpha(77)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.info),
                  const SizedBox(width: 8),
                  Text(
                    'What to do next:',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '1. Check your email inbox\n2. Click the reset link in the email\n3. Create a new password\n4. Login with your new password',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Didn\'t receive the email? Check your spam folder or try again.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.grey600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.extraLargeSpacing),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isEmailSent = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPink),
                  foregroundColor: AppColors.primaryPink,
                ),
                child: const Text('Resend Email'),
              ),
            ),
            const SizedBox(width: AppConstants.mediumSpacing),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.navigateToLogin(),
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
