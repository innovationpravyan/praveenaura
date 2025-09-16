import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _hasNavigated = false;

  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonSlideAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Discover Your Beauty',
      description:
          'Find the perfect salon and beauty services tailored to your style and preferences.',
      icon: Icons.spa_outlined,
      color: AppColors.primaryPinkLight,
    ),
    OnboardingPage(
      title: 'Book with Confidence',
      description:
          'Easy booking, verified professionals, and transparent pricing for all your beauty needs.',
      icon: Icons.event_available_outlined,
      color: AppColors.accentLight,
    ),
    OnboardingPage(
      title: 'Your Beauty Journey',
      description:
          'Track your appointments, save favorites, and build your personalized beauty profile.',
      icon: Icons.favorite_outline,
      color: AppColors.successLight,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startInitialAnimation();
  }

  void _initAnimations() {
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _iconRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutCubic),
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _buttonSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack),
    );
  }

  void _startInitialAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _iconController.forward();

      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        _textController.forward();

        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) {
          _buttonController.forward();
        }
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _resetAnimations();
    _startPageAnimation();
  }

  void _resetAnimations() {
    _iconController.reset();
    _textController.reset();
    _buttonController.reset();
  }

  void _startPageAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      _iconController.forward();

      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        _textController.forward();

        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _buttonController.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildSkipButton(),
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) => _buildPage(_pages[index]),
                ),
              ),
              Expanded(flex: 1, child: _buildBottomSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.all(4.w(context)),
        child: TextButton(
          onPressed: _finishOnboarding,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w(context),
              vertical: 2.h(context),
            ),
          ),
          child: Text(
            'Skip',
            style: context.labelLarge.copyWith(
              color: context.textMediumEmphasisColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedIcon(page),
          SizedBox(height: 6.h(context)),
          _buildAnimatedTitle(page),
          SizedBox(height: 3.h(context)),
          _buildAnimatedDescription(page),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(OnboardingPage page) {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return Transform.scale(
          scale: _iconScaleAnimation.value,
          child: Transform.rotate(
            angle: _iconRotationAnimation.value,
            child: Container(
              width: 30.w(context),
              height: 30.w(context),
              decoration: BoxDecoration(
                color: page.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.w(context)),
                border: Border.all(
                  color: page.color.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: page.color.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(page.icon, size: 15.w(context), color: page.color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle(OnboardingPage page) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Text(
              page.title,
              style: context.headlineMedium.copyWith(
                color: context.textHighEmphasisColor,
                fontWeight: FontWeight.w700,
                fontSize: 7.w(context),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDescription(OnboardingPage page) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Text(
              page.description,
              style: context.bodyLarge.copyWith(
                color: context.textMediumEmphasisColor,
                height: 1.6,
                fontSize: 4.w(context),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        // Clamp the animation value to ensure it stays within valid bounds
        final animationValue = _buttonSlideAnimation.value.clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Padding(
              padding: EdgeInsets.all(6.w(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPageIndicator(),
                  SizedBox(height: 4.h(context)),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => _buildIndicatorDot(index),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 1.w(context)),
      width: isActive ? 8.w(context) : 2.w(context),
      height: 2.w(context),
      decoration: BoxDecoration(
        color: isActive ? context.primaryColor : context.textDisabledColor,
        borderRadius: BorderRadius.circular(1.w(context)),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentPage > 0) Expanded(child: _buildBackButton()),
        if (_currentPage > 0) SizedBox(width: 4.w(context)),
        Expanded(flex: _currentPage > 0 ? 1 : 2, child: _buildNextButton()),
      ],
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      height: 6.h(context),
      child: OutlinedButton(
        onPressed: _previousPage,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w(context)),
          ),
        ),
        child: Text(
          'Back',
          style: context.titleMedium.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentPage == _pages.length - 1;

    return SizedBox(
      height: 6.h(context),
      child: ElevatedButton(
        onPressed: isLastPage ? _finishOnboarding : _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primaryColor,
          foregroundColor: AppColors.white,
          elevation: 3,
          shadowColor: context.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w(context)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Next',
              style: context.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isLastPage) ...[
              SizedBox(width: 2.w(context)),
              Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 5.w(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    if (_hasNavigated) return;
    _hasNavigated = true;

    print('OnboardingScreen: Finishing onboarding');

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);
      print('OnboardingScreen: SharedPreferences updated successfully');

      if (mounted) {
        print('OnboardingScreen: Navigating to login screen');
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    } catch (e) {
      print('OnboardingScreen: SharedPreferences error: $e');
      // If SharedPreferences fails, still navigate to login
      if (mounted) {
        print('OnboardingScreen: Navigating to login screen (after error)');
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
