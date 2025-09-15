import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Start animations
    _logoController.forward();

    // Start text animation after logo animation begins
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (authState.isAuthenticated) {
      context.navigateToHomeInitial();
    } else {
      context.navigateToLogin();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryPink.withAlpha(26),
              AppColors.primaryBlue.withAlpha(26),
              AppColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // App Logo/Icon
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: AppColors.pinkGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryPink.withAlpha(
                                        77,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.spa_outlined,
                                  size: 60,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: AppConstants.largeSpacing),
                              // App Name
                              Text(
                                AppConstants.appName,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  background: Paint()
                                    ..shader =
                                        LinearGradient(
                                          colors: AppColors.pinkGradient,
                                        ).createShader(
                                          const Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Loading indicator
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryPink,
                      ),
                    ),
                    const SizedBox(height: AppConstants.largeSpacing),
                    // App description with animation
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textFade,
                            child: Padding(
                              padding: context.horizontalPadding,
                              child: Text(
                                AppConstants.appDescription,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.grey600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Bottom branding
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.largeSpacing,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Made with ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        const Icon(
                          Icons.favorite,
                          size: 12,
                          color: AppColors.error,
                        ),
                        Text(
                          ' for beautiful you',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
