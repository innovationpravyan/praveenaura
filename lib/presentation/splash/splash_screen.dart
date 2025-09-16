import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _loadingAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Text animations
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Loading animation
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startAnimationSequence() async {
    // Start logo animation
    _logoController.forward();

    // Wait a bit then start text animation
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      _textController.forward();
    }

    // Wait for animations to complete then check navigation
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      await _checkAndNavigate();
    }
  }

  Future<void> _checkAndNavigate() async {
    if (!mounted || _hasNavigated) return;

    print('SplashScreen: Starting navigation check');

    try {
      // Check if it's the first time opening the app
      final hasSeenOnboarding = await _hasSeenOnboarding();
      print('SplashScreen: Has seen onboarding: $hasSeenOnboarding');

      if (!hasSeenOnboarding) {
        // First time user - show onboarding
        print('SplashScreen: Navigating to onboarding (first time user)');
        _navigateToRoute(AppRoutes.onboarding);
        return;
      }

      // Wait for auth state to initialize with timeout
      final authState = await _waitForAuthInitialization();
      print('SplashScreen: Auth state initialized: $authState');

      if (!mounted || _hasNavigated) return;

      // Navigate based on authentication status
      if (authState.isAuthenticated) {
        print('SplashScreen: User is authenticated, navigating to home');
        _navigateToRoute(AppRoutes.home);
      } else {
        print('SplashScreen: User is not authenticated, navigating to login');
        _navigateToRoute(AppRoutes.login);
      }
    } catch (e) {
      print('SplashScreen: Error during navigation check: $e');
      // If there's any error, default to login screen
      if (mounted && !_hasNavigated) {
        _navigateToRoute(AppRoutes.login);
      }
    }
  }

  Future<AuthState> _waitForAuthInitialization() async {
    const maxWaitTime = Duration(seconds: 3); // Reduced from 5 to 3 seconds
    const checkInterval = Duration(milliseconds: 50); // Reduced from 100ms
    final startTime = DateTime.now();

    while (DateTime.now().difference(startTime) < maxWaitTime) {
      final authState = ref.read(authProvider);
      if (authState.isInitialized) {
        print('SplashScreen: Auth state is initialized: $authState');
        return authState;
      }
      await Future.delayed(checkInterval);
      if (!mounted) break;
    }

    // Return current state if timeout
    final finalState = ref.read(authProvider);
    print(
      'SplashScreen: Auth initialization timeout, returning current state: $finalState',
    );
    return finalState;
  }

  void _navigateToRoute(String route) {
    if (_hasNavigated || !mounted) return;

    _hasNavigated = true;
    print('SplashScreen: Navigating to $route');

    // Use immediate navigation instead of post frame callback for more reliable timing
    Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false, // Clear all previous routes
    );
  }

  Future<bool> _hasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool('has_seen_onboarding') ?? false;
      print('SplashScreen: SharedPreferences has_seen_onboarding: $result');
      return result;
    } catch (e) {
      print('SplashScreen: SharedPreferences error: $e');
      return false; // If SharedPreferences fails, show onboarding
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes but don't trigger navigation from here
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Only log meaningful changes, not every loading state change
      if (previous?.isInitialized != next.isInitialized ||
          previous?.isAuthenticated != next.isAuthenticated) {
        print('SplashScreen: Auth state changed from $previous to $next');
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.getPrimaryColorForGender(
                'female',
                isDark: context.isDarkMode,
              ).withOpacity(0.1),
              AppColors.getBackgroundColor(isDark: context.isDarkMode),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotationAnimation.value * 0.1,
                        child: _buildLogo(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h(context)),

                // Animated Text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Column(
                          children: [
                            _buildAppName(),
                            SizedBox(height: 1.h(context)),
                            _buildTagline(),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 8.h(context)),

                // Animated Loading Indicator
                AnimatedBuilder(
                  animation: _loadingAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_loadingAnimation.value * 0.2),
                      child: _buildLoadingIndicator(),
                    );
                  },
                ),

                SizedBox(height: 2.h(context)),

                // Loading text with fade animation
                AnimatedBuilder(
                  animation: _loadingAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.5 + (_loadingAnimation.value * 0.3),
                      child: Text(
                        'Preparing your beauty experience...',
                        style: context.bodySmall.copyWith(
                          color: context.textMediumEmphasisColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w(context),
      height: 25.w(context),
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
        borderRadius: BorderRadius.circular(5.w(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowColor(isDark: context.isDarkMode),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          // Add inner glow effect
          BoxShadow(
            color: AppColors.getPrimaryColorForGender(
              'female',
              isDark: context.isDarkMode,
            ).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 0),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'A',
          style: context.headlineLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.w(context),
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      'Aura',
      style: context.headlineLarge.copyWith(
        color: AppColors.getPrimaryColorForGender(
          'female',
          isDark: context.isDarkMode,
        ),
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
        fontSize: 8.w(context),
        shadows: [
          Shadow(
            color: AppColors.getPrimaryColorForGender(
              'female',
              isDark: context.isDarkMode,
            ).withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      'Your Beauty, Your Way',
      style: context.bodyLarge.copyWith(
        color: context.textMediumEmphasisColor,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 8.w(context),
      height: 8.w(context),
      padding: EdgeInsets.all(0.5.w(context)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.getPrimaryColorForGender(
            'female',
            isDark: context.isDarkMode,
          ).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.getPrimaryColorForGender(
            'female',
            isDark: context.isDarkMode,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
