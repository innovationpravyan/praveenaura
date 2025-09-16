import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  String _selectedGender = 'female';

  String? _displayNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _phoneError;

  late AnimationController _headerController;
  late AnimationController _formController;
  late AnimationController _buttonController;

  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _formStaggerAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );

    _formStaggerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _headerController.forward();

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _formController.forward();

        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          _buttonController.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _headerController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoading != previous?.isLoading) return;

      if (next.error != null) {
        context.showErrorSnackBar(next.error!);
        ref.read(authProvider.notifier).clearError();
      }

      if (next.isAuthenticated && !next.isLoading) {
        // Clear form data
        _clearFormData();

        // Show success message
        context.showSuccessSnackBar('Account created successfully!');

        // Navigate back to login screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.backgroundColor,
              context.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAnimatedHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: context.responsiveContentPadding,
                    child: Column(
                      children: [
                        SizedBox(height: 2.h(context)),
                        _buildAnimatedForm(authState),
                        SizedBox(height: 3.h(context)),
                        _buildLoginLink(),
                        SizedBox(height: 2.h(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return SlideTransition(
          position: _headerSlideAnimation,
          child: FadeTransition(
            opacity: _headerFadeAnimation,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w(context),
                vertical: 2.h(context),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: context.textHighEmphasisColor,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: context.backgroundColor,
                      padding: EdgeInsets.all(3.w(context)),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Create Account',
                          style: context.headlineLarge.copyWith(
                            color: context.textHighEmphasisColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h(context)),
                        Text(
                          'Join Aura and discover your beauty journey',
                          style: context.bodyMedium.copyWith(
                            color: context.textMediumEmphasisColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w(context)), // Balance the back button
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedForm(AuthState authState) {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _buildStaggeredField(0, _buildDisplayNameField()),
              SizedBox(height: 3.h(context)),
              _buildStaggeredField(1, _buildEmailField()),
              SizedBox(height: 3.h(context)),
              _buildStaggeredField(2, _buildPhoneField()),
              SizedBox(height: 3.h(context)),
              _buildStaggeredField(3, _buildGenderSelection()),
              SizedBox(height: 3.h(context)),
              _buildStaggeredField(4, _buildPasswordField()),
              SizedBox(height: 3.h(context)),
              _buildStaggeredField(5, _buildConfirmPasswordField()),
              SizedBox(height: 2.h(context)),
              _buildStaggeredField(6, _buildTermsCheckbox()),
              SizedBox(height: 4.h(context)),
              _buildAnimatedButton(authState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaggeredField(int index, Widget child) {
    const delay = 100;
    final staggeredValue = _formStaggerAnimation.value - (index * 0.1);
    final opacity = (staggeredValue).clamp(0.0, 1.0);
    final slideValue = (1.0 - opacity) * 50;

    return AnimatedContainer(
      duration: Duration(milliseconds: delay + (index * 100)),
      transform: Matrix4.translationValues(0, slideValue, 0),
      child: Opacity(opacity: opacity, child: child),
    );
  }

  Widget _buildAnimatedButton(AuthState authState) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: _buildSignupButton(authState),
        );
      },
    );
  }

  Widget _buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: context.labelLarge.copyWith(
            color: context.textHighEmphasisColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h(context)),
        TextFormField(
          controller: _displayNameController,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          onChanged: _validateDisplayName,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(
              Icons.person_outlined,
              color: context.textMediumEmphasisColor,
              size: 5.w(context),
            ),
            errorText: _displayNameError,
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
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
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
          textInputAction: TextInputAction.next,
          onChanged: _validateEmail,
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
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: context.labelLarge.copyWith(
            color: context.textHighEmphasisColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h(context)),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: _validatePhone,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: context.textMediumEmphasisColor,
              size: 5.w(context),
            ),
            errorText: _phoneError,
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
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: context.labelLarge.copyWith(
            color: context.textHighEmphasisColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h(context)),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('Female', 'female', Icons.female),
            ),
            SizedBox(width: 4.w(context)),
            Expanded(child: _buildGenderOption('Male', 'male', Icons.male)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, String value, IconData icon) {
    final isSelected = _selectedGender == value;
    final primaryColor = AppColors.getPrimaryColorForGender(
      value,
      isDark: context.isDarkMode,
    );

    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w(context)),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : context.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(3.w(context)),
          color: isSelected
              ? primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? primaryColor
                  : context.textMediumEmphasisColor,
              size: 5.w(context),
            ),
            SizedBox(width: 2.w(context)),
            Text(
              label,
              style: context.labelLarge.copyWith(
                color: isSelected
                    ? primaryColor
                    : context.textMediumEmphasisColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: context.labelLarge.copyWith(
            color: context.textHighEmphasisColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h(context)),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.next,
          onChanged: _validatePassword,
          decoration: InputDecoration(
            hintText: 'Create a password',
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: context.textMediumEmphasisColor,
              size: 5.w(context),
            ),
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: context.textMediumEmphasisColor,
                size: 5.w(context),
              ),
            ),
            errorText: _passwordError,
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
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: context.labelLarge.copyWith(
            color: context.textHighEmphasisColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h(context)),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
          onChanged: _validateConfirmPassword,
          onFieldSubmitted: (_) => _handleSignup(),
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: context.textMediumEmphasisColor,
              size: 5.w(context),
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              ),
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: context.textMediumEmphasisColor,
                size: 5.w(context),
              ),
            ),
            errorText: _confirmPasswordError,
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
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
          activeColor: context.primaryColor,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: context.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: context.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(AuthState authState) {
    final isFormValid = _isFormValid();
    final isLoading = authState.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 6.h(context),
      child: ElevatedButton(
        onPressed: isFormValid && !isLoading ? _handleSignup : null,
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
                'Create Account',
                style: context.titleMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: context.bodyMedium.copyWith(
            color: context.textMediumEmphasisColor,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Sign In',
            style: context.bodyMedium.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _validateDisplayName(String value) {
    setState(() {
      if (value.isEmpty) {
        _displayNameError = 'Full name is required';
      } else if (value.length < 2) {
        _displayNameError = 'Name must be at least 2 characters';
      } else {
        _displayNameError = null;
      }
    });
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

  void _validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (value.length < 10) {
        _phoneError = 'Please enter a valid phone number';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }

      // Re-validate confirm password if it exists
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _displayNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _displayNameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _agreeToTerms;
  }

  void _clearFormData() {
    _displayNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _selectedGender = 'female';
    _agreeToTerms = false;

    setState(() {
      _displayNameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _isPasswordVisible = false;
      _isConfirmPasswordVisible = false;
    });
  }

  Future<void> _handleSignup() async {
    if (!_isFormValid()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final displayName = _displayNameController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    // Validate all fields one more time before submitting
    _validateDisplayName(displayName);
    _validateEmail(email);
    _validatePhone(phoneNumber);
    _validatePassword(password);
    _validateConfirmPassword(_confirmPasswordController.text);

    if (_displayNameError != null ||
        _emailError != null ||
        _phoneError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .signUp(
            email: email,
            password: password,
            displayName: displayName,
            phoneNumber: phoneNumber,
            gender: _selectedGender,
          );

      HapticFeedback.lightImpact();
    } catch (e) {
      // Error handling is done in the listener
    }
  }
}
