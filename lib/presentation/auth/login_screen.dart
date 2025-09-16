import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _buttonController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _formSlideAnimation;
  late Animation<double> _formOpacityAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _formSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
        );

    _formOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack),
    );
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _logoController.forward();

      await Future.delayed(const Duration(milliseconds: 600));
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
    _emailController.dispose();
    _passwordController.dispose();
    _logoController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple listener for auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Handle errors
      if (next.error != null && previous?.error != next.error) {
        context.showErrorSnackBar(next.error!);
        ref.read(authProvider.notifier).clearError();
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.backgroundColor,
              context.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: context.responsiveContentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h(context)),
                  _buildAnimatedLogo(),
                  SizedBox(height: 6.h(context)),
                  _buildAnimatedForm(authState),
                  SizedBox(height: 4.h(context)),
                  _buildAnimatedSocialLogin(),
                  SizedBox(height: 4.h(context)),
                  _buildSignUpLink(),
                  SizedBox(height: 2.h(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoOpacityAnimation,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Column(
              children: [
                Container(
                  width: 20.w(context),
                  height: 20.w(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.getPrimaryColorForGender(
                          'female',
                          isDark: context.isDarkMode,
                        ),
                        AppColors.getPrimaryColorForGender(
                          'female',
                          isDark: context.isDarkMode,
                        ).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(4.w(context)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getShadowColor(
                          isDark: context.isDarkMode,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: context.headlineLarge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h(context)),
                Text(
                  'Aura',
                  style: context.headlineMedium.copyWith(
                    color: AppColors.getPrimaryColorForGender(
                      'female',
                      isDark: context.isDarkMode,
                    ),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 1.h(context)),
                Text(
                  'Your Beauty, Your Way',
                  style: context.bodyMedium.copyWith(
                    color: context.textMediumEmphasisColor,
                  ),
                ),
              ],
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
        return SlideTransition(
          position: _formSlideAnimation,
          child: FadeTransition(
            opacity: _formOpacityAnimation,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: context.headlineSmall.copyWith(
                      color: context.textHighEmphasisColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h(context)),
                  Text(
                    'Sign in to continue your beauty journey',
                    style: context.bodyMedium.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                  SizedBox(height: 4.h(context)),
                  _buildEmailField(),
                  SizedBox(height: 3.h(context)),
                  _buildPasswordField(),
                  SizedBox(height: 2.h(context)),
                  _buildForgotPasswordLink(),
                  SizedBox(height: 4.h(context)),
                  _buildAnimatedButtons(authState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButtons(AuthState authState) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: Column(
            children: [
              _buildLoginButton(authState),
              SizedBox(height: 2.h(context)),
              _buildGuestAccessButton(authState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSocialLogin() {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _buttonScaleAnimation,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Divider(color: context.dividerColor, thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w(context)),
                    child: Text(
                      'Or continue with',
                      style: context.bodySmall.copyWith(
                        color: context.textMediumEmphasisColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: context.dividerColor, thickness: 1),
                  ),
                ],
              ),
              SizedBox(height: 3.h(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    'Google',
                    Icons.g_mobiledata,
                    _handleGoogleLogin,
                  ),
                  _buildSocialButton('Apple', Icons.apple, _handleAppleLogin),
                  _buildSocialButton(
                    'Facebook',
                    Icons.facebook,
                    _handleFacebookLogin,
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
      ],
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
          textInputAction: TextInputAction.done,
          onChanged: _validatePassword,
          onFieldSubmitted: (_) => _handleLogin(),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: context.textMediumEmphasisColor,
              size: 5.w(context),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
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
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
        },
        child: Text(
          'Forgot Password?',
          style: context.bodyMedium.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthState authState) {
    final isFormValid = _isFormValid();
    final isLoading = authState.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 6.h(context),
      child: ElevatedButton(
        onPressed: isFormValid && !isLoading ? _handleLogin : null,
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
                'Login',
                style: context.titleMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildGuestAccessButton(AuthState authState) {
    return SizedBox(
      width: double.infinity,
      height: 6.h(context),
      child: OutlinedButton(
        onPressed: authState.isLoading ? null : _handleGuestAccess,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w(context)),
          ),
        ),
        child: Text(
          'Continue as Guest',
          style: context.titleMedium.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String name,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 20.w(context),
      height: 6.h(context),
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: BorderRadius.circular(3.w(context)),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(3.w(context)),
        child: Center(
          child: Icon(
            icon,
            size: 6.w(context),
            color: context.textHighEmphasisColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to Aura? ',
          style: context.bodyMedium.copyWith(
            color: context.textMediumEmphasisColor,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.signup);
          },
          child: Text(
            'Sign Up',
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

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate fields one more time before submitting
    _validateEmail(email);
    _validatePassword(password);

    if (_emailError != null || _passwordError != null) {
      return;
    }

    try {
      print('LoginScreen: Starting login process for $email');

      // Perform login
      await ref.read(authProvider.notifier).signIn(email, password);

      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Check if login was successful
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && !authState.isLoading) {
        print('LoginScreen: Login successful, navigating to home');

        // Navigate to home screen
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
        }
      }
    } catch (e) {
      print('LoginScreen: Login failed with error: $e');
      // Error handling is done in the listener
    }
  }

  void _handleGuestAccess() {
    print('LoginScreen: Starting guest access');
    ref.read(authProvider.notifier).continueAsGuest();

    // Navigate to home screen as guest
    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    }
  }

  void _handleGoogleLogin() {
    context.showInfoSnackBar('Google Sign-In coming soon!');
  }

  void _handleAppleLogin() {
    context.showInfoSnackBar('Apple Sign-In coming soon!');
  }

  void _handleFacebookLogin() {
    context.showInfoSnackBar('Facebook Sign-In coming soon!');
  }
}
