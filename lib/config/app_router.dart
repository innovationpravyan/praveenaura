import 'package:flutter/material.dart';

import '../features/about/screens/about_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/booking/screens/booking_history_screen.dart';
import '../features/explore/screens/explore_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/legal/screens/privacy_screen.dart';
import '../features/legal/screens/terms_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/support/screens/support_screen.dart';
import '../features/wishlist/screens/wishlist_screen.dart';

// Route Names
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Main app screens
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookings = '/bookings';
  static const String profile = '/profile';

  // Other screens
  static const String editProfile = '/edit-profile';
  static const String wishlist = '/wishlist';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String support = '/support';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
}


// Custom Page Route with slide animation
class SlideRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SlideRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      );
}

// Fade Route Animation
class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadeRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      );
}

// App Router Class
class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static NavigatorState get navigator => navigatorKey.currentState!;

  // Route Generation
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case AppRoutes.login:
        return SlideRoute(child: const LoginScreen());

      case AppRoutes.signup:
        return SlideRoute(child: const SignupScreen());

      case AppRoutes.forgotPassword:
        return SlideRoute(child: const ForgotPasswordScreen());

      // Main App Routes
      case AppRoutes.home:
        return SlideRoute(child: const HomeScreen());

      case AppRoutes.explore:
        return FadeRoute(child: const ExploreScreen());

      case AppRoutes.bookings:
        return SlideRoute(child: const BookingHistoryScreen());

      case AppRoutes.profile:
        return FadeRoute(child: const ProfileScreen());

      // Other Routes
      case AppRoutes.editProfile:
        return SlideRoute(child: const EditProfileScreen());

      case AppRoutes.wishlist:
        return SlideRoute(child: const WishlistScreen());

      case AppRoutes.notifications:
        return SlideRoute(child: const NotificationsScreen());

      case AppRoutes.settings:
        return SlideRoute(child: const SettingsScreen());

      case AppRoutes.support:
        return SlideRoute(child: const SupportScreen());

      case AppRoutes.about:
        return SlideRoute(child: const AboutScreen());

      case AppRoutes.privacy:
        return SlideRoute(child: const PrivacyScreen());

      case AppRoutes.terms:
        return SlideRoute(child: const TermsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }

  // Navigation Methods
  static Future<T?> push<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigator.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  static Future<T?> pushAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    return navigator.pop<T>(result);
  }

  static void popUntil(String routeName) {
    return navigator.popUntil(ModalRoute.withName(routeName));
  }

  static bool canPop() {
    return navigator.canPop();
  }

  static Future<bool> maybePop<T extends Object?>([T? result]) {
    return navigator.maybePop<T>(result);
  }
}

// Not Found Screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Not Found"),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Clear navigation stack and go to home
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
