import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  String _selectedGender = AppConstants.female;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        context.showErrorSnackBar('Please accept terms and conditions');
        return;
      }

      context.unfocus();

      try {
        await ref
            .read(authProvider.notifier)
            .signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              displayName: _nameController.text.trim(),
              phoneNumber: _phoneController.text.trim(),
              gender: _selectedGender,
            );

        if (mounted) {
          context.showSuccessSnackBar(AppConstants.signupSuccessMessage);
          context.navigateToHome();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.mediumSpacing),

                // Header
                _buildHeader(),

                const SizedBox(height: AppConstants.largeSpacing),

                // Full Name field
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  enabled: !authState.isLoading,
                  validator: Validators.name,
                  decoration: context.getInputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                ),

                const SizedBox(height: AppConstants.mediumSpacing),

                // Phone Number field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  enabled: !authState.isLoading,
                  validator: Validators.phoneNumber,
                  decoration: context.getInputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),

                const SizedBox(height: AppConstants.mediumSpacing),

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

                // Gender selection
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(context.defaultRadius),
                  ),
                  padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Female'),
                              value: AppConstants.female,
                              groupValue: _selectedGender,
                              onChanged: authState.isLoading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                              activeColor: AppColors.primaryBlue,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Male'),
                              value: AppConstants.male,
                              groupValue: _selectedGender,
                              onChanged: authState.isLoading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                              activeColor: AppColors.primaryBlue,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.mediumSpacing),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.next,
                  enabled: !authState.isLoading,
                  validator: Validators.password,
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

                const SizedBox(height: AppConstants.mediumSpacing),

                // Confirm Password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !authState.isLoading,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  onFieldSubmitted: (_) => _signUp(),
                  decoration: context.getInputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.smallSpacing),

                // Terms and conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: authState.isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                      activeColor: AppColors.primaryPink,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: AppTextStyles.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryPink,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryPink,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.largeSpacing),

                // Sign up button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _signUp,
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
                      : const Text('Create Account'),
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

                const SizedBox(height: AppConstants.mediumSpacing),

                // Google sign up button (commented out)
                // OutlinedButton.icon(
                //   onPressed: authState.isLoading ? null : _signUpWithGoogle,
                //   icon: Image.asset(
                //     'assets/images/google_logo.png',
                //     width: 20,
                //     height: 20,
                //     errorBuilder: (context, error, stackTrace) {
                //       return const Icon(Icons.g_mobiledata, size: 20);
                //     },
                //   ),
                //   label: const Text('Sign up with Google'),
                //   style: OutlinedButton.styleFrom(
                //     side: const BorderSide(color: AppColors.grey300),
                //     foregroundColor: AppColors.grey700,
                //   ),
                // ),
                const SizedBox(height: AppConstants.largeSpacing),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.navigateToLogin(),
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
        // Fixed back button
        IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
        ),

        const SizedBox(height: AppConstants.mediumSpacing),

        // Create account text
        Text(
          'Create Account',
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
          ),
        ),

        const SizedBox(height: AppConstants.smallSpacing),

        Text(
          'Join us and discover the best beauty services near you',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }
}
