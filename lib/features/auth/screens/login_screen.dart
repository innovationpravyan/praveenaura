import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      context.unfocus();

      try {
        await ref
            .read(authProvider.notifier)
            .signIn(_emailController.text.trim(), _passwordController.text);

        if (mounted) {
          context.showSuccessSnackBar(AppConstants.loginSuccessMessage);
          context.navigateToHome();
        }
      } catch (e) {
        if (mounted) {
          context.showErrorSnackBar(e.toString());
        }
      }
    }
  }

  void _continueAsGuest() {
    ref.read(authProvider.notifier).continueAsGuest();
    context.showSuccessSnackBar(
      'Browsing as guest - Login anytime for full access!',
    );
    context.navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.extraLargeSpacing),

                // Welcome header
                _buildHeader(),

                const SizedBox(height: AppConstants.extraLargeSpacing),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !authState.isLoading,
                  validator: Validators.email,
                  decoration: context.getInputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: AppConstants.mediumSpacing),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !authState.isLoading,
                  validator: Validators.required,
                  onFieldSubmitted: (_) => _signIn(),
                  decoration: context.getInputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.smallSpacing),

                // Remember me & Forgot password row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: authState.isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                          activeColor: AppColors.primaryPink,
                        ),
                        Text('Remember me', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.navigateToForgotPassword(),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.largeSpacing),

                // Sign in button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _signIn,
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
                      : const Text('Sign In'),
                ),

                const SizedBox(height: AppConstants.mediumSpacing),

                // Continue as Guest button
                OutlinedButton(
                  onPressed: authState.isLoading ? null : _continueAsGuest,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryPink),
                    foregroundColor: AppColors.primaryPink,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Continue as Guest'),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.mediumSpacing),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.mediumSpacing,
                      ),
                      child: Text(
                        'or',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: AppConstants.extraLargeSpacing),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.navigateToSignup(),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.largeSpacing),

                // Guest mode info
                Container(
                  padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withAlpha(26),
                    borderRadius: BorderRadius.circular(
                      AppConstants.mediumRadius,
                    ),
                    border: Border.all(
                      color: AppColors.primaryPink.withAlpha(77),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.primaryPink,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Guest Mode Benefits',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primaryPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Browse all services and salons\n• View prices and reviews\n• Explore beauty categories\n• Get inspired by trends',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login anytime to book services, save favorites, and unlock premium features!',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey600,
                          fontStyle: FontStyle.italic,
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App logo
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: AppColors.pinkGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPink.withAlpha(77),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.spa_outlined,
              size: 40,
              color: AppColors.white,
            ),
          ),
        ),

        const SizedBox(height: AppConstants.largeSpacing),

        // Welcome text
        Text(
          'Welcome Back!',
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
          ),
        ),

        const SizedBox(height: AppConstants.smallSpacing),

        Text(
          'Sign in to your account or continue as guest to explore our beauty services',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }
}
