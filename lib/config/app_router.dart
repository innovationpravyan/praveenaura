import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../presentation/about/about_screen.dart';
import '../presentation/auth/forgot_password_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/booking/booking_history_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/legal/privacy_screen.dart';
import '../presentation/legal/terms_screen.dart';
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/profile/edit_profile_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/support/support_screen.dart';
import '../presentation/wishlist/wishlist_screen.dart';
import '../providers/auth_provider.dart';

// Route Names - Organized by feature groups
abstract class AppRoutes {
  // Initial & Auth Routes
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Main App Navigation Routes
  static const String home = '/home';
  static const String search = '/search';
  static const String bookings = '/bookings';
  static const String profile = '/profile';

  // Feature Routes
  static const String salonDetail = '/salon-detail';
  static const String bookingFlow = '/booking-flow';
  static const String bookingHistory = '/booking-history';
  static const String editProfile = '/edit-profile';
  static const String wishlist = '/wishlist';
  static const String notifications = '/notifications';

  // Settings & Support Routes
  static const String settings = '/settings';
  static const String support = '/support';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';

  // Routes that require full authentication (not guest mode)
  static const List<String> premiumRoutes = [
    bookingFlow,
    bookings,
    bookingHistory,
    profile,
    editProfile,
    wishlist,
    notifications,
    settings,
  ];

  // Routes that require at least guest access
  static const List<String> guestAccessRoutes = [
    home,
    search,
    salonDetail,
    support,
    about,
    privacy,
    terms,
  ];

  // Public routes (no auth required)
  static const List<String> publicRoutes = [
    initial,
    splash,
    onboarding,
    login,
    signup,
    forgotPassword,
    privacy,
    terms,
  ];

  // Check if route requires premium authentication
  static bool requiresPremiumAuth(String? routeName) {
    return premiumRoutes.contains(routeName);
  }

  // Check if route requires at least guest access
  static bool requiresGuestAccess(String? routeName) {
    return guestAccessRoutes.contains(routeName) ||
        premiumRoutes.contains(routeName);
  }

  // Check if route is public
  static bool isPublicRoute(String? routeName) {
    return publicRoutes.contains(routeName);
  }
}

// Enhanced Route Animations
enum RouteTransition { slide, fade, scale, slideFromBottom, slideFromTop, none }

// Professional Route Builder with animations
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final RouteTransition transition;
  final Duration? duration;
  final Curve? curve;

  AppPageRoute({
    required this.child,
    this.transition = RouteTransition.slide,
    this.duration,
    this.curve,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _buildTransition(
             context,
             animation,
             secondaryAnimation,
             child,
             transition,
             curve ?? Curves.easeInOutCubic,
           );
         },
         transitionDuration: duration ?? const Duration(milliseconds: 300),
         reverseTransitionDuration:
             duration ?? const Duration(milliseconds: 250),
       );

  static Widget _buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    RouteTransition transition,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (transition) {
      case RouteTransition.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransition.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransition.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransition.fade:
        return FadeTransition(opacity: curvedAnimation, child: child);

      case RouteTransition.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: child,
        );

      case RouteTransition.none:
        return child;
    }
  }
}

// Simplified Auth Wrapper Widget
class AuthWrapper extends ConsumerWidget {
  final Widget child;
  final String routeName;

  const AuthWrapper({super.key, required this.child, required this.routeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Don't show loading for routes that don't need auth
    if (AppRoutes.isPublicRoute(routeName)) {
      return child; // Public routes are always accessible
    }

    // Show loading only for auth-required routes while auth is initializing
    if (authState.isLoading && AppRoutes.requiresGuestAccess(routeName)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Check route access permissions
    if (AppRoutes.requiresPremiumAuth(routeName)) {
      // Premium routes require full authentication
      if (!authState.isFullyAuthenticated) {
        // Return a screen that prompts login instead of auto-navigating
        return LoginRequiredScreen(
          message: 'Please login to access this feature',
          onLoginPressed: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          },
        );
      }
    } else if (AppRoutes.requiresGuestAccess(routeName)) {
      // Guest access routes require at least guest mode
      if (!authState.isAuthenticated) {
        // Return a screen that prompts login instead of auto-navigating
        return LoginRequiredScreen(
          message: 'Please login or continue as guest to access this feature',
          onLoginPressed: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          },
          showGuestOption: true,
          onGuestPressed: () {
            ref.read(authProvider.notifier).continueAsGuest();
          },
        );
      }
    }

    return child;
  }
}

// Updated Login Required Screen
class LoginRequiredScreen extends StatelessWidget {
  final String message;
  final VoidCallback onLoginPressed;
  final VoidCallback? onGuestPressed;
  final bool showGuestOption;

  const LoginRequiredScreen({
    super.key,
    required this.message,
    required this.onLoginPressed,
    this.onGuestPressed,
    this.showGuestOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Authentication Required',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onLoginPressed,
                    child: const Text('Login'),
                  ),
                ),
                if (showGuestOption && onGuestPressed != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onGuestPressed,
                      child: const Text('Continue as Guest'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Main App Router Class
class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Current context (use with caution)
  static BuildContext? get context => navigatorKey.currentContext;

  // Navigator state
  static NavigatorState? get navigator => navigatorKey.currentState;

  // Route observer for analytics and logging
  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  // Generate routes with security checks
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? AppRoutes.initial;
    return _generateSecureRoute(routeName, settings);
  }

  // Generate secure routes with proper animations
  static Route<dynamic> _generateSecureRoute(
    String routeName,
    RouteSettings settings,
  ) {
    final screen = _getScreenForRoute(routeName);
    final transition = _getTransitionForRoute(routeName);

    return AppPageRoute(
      child: AuthWrapper(routeName: routeName, child: screen),
      transition: transition,
      settings: settings,
      duration: _getDurationForRoute(routeName),
    );
  }

  // Get screen widget for route
  static Widget _getScreenForRoute(String routeName) {
    switch (routeName) {
      // Initial & Auth Routes
      case AppRoutes.initial:
      case AppRoutes.splash:
        return const SplashScreen();
      case AppRoutes.onboarding:
        return const OnboardingScreen();
      case AppRoutes.login:
        return const LoginScreen();
      case AppRoutes.signup:
        return const SignupScreen();
      case AppRoutes.forgotPassword:
        return const ForgotPasswordScreen();

      // Main App Routes
      case AppRoutes.home:
        return const HomeScreen();
      // case AppRoutes.explore:
      //   return const ExploreScreen();
      case AppRoutes.bookingHistory:
        return const BookingHistoryScreen();
      case AppRoutes.profile:
        return const ProfileScreen();

      // Feature Routes
      case AppRoutes.editProfile:
        return const EditProfileScreen();
      case AppRoutes.wishlist:
        return const WishlistScreen();
      case AppRoutes.notifications:
        return const NotificationsScreen();

      // Settings & Support Routes
      case AppRoutes.settings:
        return const SettingsScreen();
      case AppRoutes.support:
        return const SupportScreen();
      case AppRoutes.about:
        return const AboutScreen();
      case AppRoutes.privacy:
        return const PrivacyScreen();
      case AppRoutes.terms:
        return const TermsScreen();

      default:
        return const NotFoundScreen();
    }
  }

  // Get transition animation for route
  static RouteTransition _getTransitionForRoute(String routeName) {
    switch (routeName) {
      // Auth routes - fade transition
      case AppRoutes.splash:
      case AppRoutes.onboarding:
      case AppRoutes.login:
        return RouteTransition.fade;

      // Main navigation - slide transition
      case AppRoutes.home:
      case AppRoutes.search:
      case AppRoutes.bookings:
      case AppRoutes.profile:
        return RouteTransition.slide;

      // Modal-like screens - slide from bottom
      case AppRoutes.bookingFlow:
      case AppRoutes.bookingHistory:
      case AppRoutes.editProfile:
      case AppRoutes.settings:
        return RouteTransition.slideFromBottom;

      default:
        return RouteTransition.slide;
    }
  }

  // Get animation duration for route
  static Duration _getDurationForRoute(String routeName) {
    switch (routeName) {
      case AppRoutes.splash:
      case AppRoutes.onboarding:
        return const Duration(milliseconds: 500);

      case AppRoutes.bookingFlow:
      case AppRoutes.bookingHistory:
      case AppRoutes.editProfile:
        return const Duration(milliseconds: 400);

      default:
        return const Duration(milliseconds: 300);
    }
  }

  // Navigation Helper Methods
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    if (navigator == null) return null;

    try {
      return await navigator!.pushNamed<T>(routeName, arguments: arguments);
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) async {
    if (navigator == null) return null;

    try {
      return await navigator!.pushReplacementNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }

  static Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    if (navigator == null) return null;

    try {
      return await navigator!.pushNamedAndRemoveUntil<T>(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }

  static void pop<T extends Object?>([T? result]) {
    if (navigator?.canPop() == true) {
      navigator!.pop<T>(result);
    }
  }

  static void popUntil(String routeName) {
    if (navigator != null) {
      navigator!.popUntil(ModalRoute.withName(routeName));
    }
  }

  static bool canPop() {
    return navigator?.canPop() ?? false;
  }

  static Future<bool> maybePop<T extends Object?>([T? result]) async {
    return await navigator?.maybePop<T>(result) ?? false;
  }

  // Handle back button for Android
  static Future<bool> handleBackPress() async {
    if (navigator == null || !navigator!.canPop()) {
      // Show exit confirmation dialog
      return await _showExitDialog() ?? false;
    }

    navigator!.pop();
    return true;
  }

  // Show exit confirmation dialog
  static Future<bool?> _showExitDialog() async {
    if (context == null) return false;

    return showDialog<bool>(
      context: context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

// Professional 404 Not Found Screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: AppColors.getErrorColor(
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Page Not Found',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'The page you are looking for doesn\'t exist or has been moved.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    AppRouter.pushNamedAndClearStack(AppRoutes.home);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
