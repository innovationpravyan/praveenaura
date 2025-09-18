import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_router.dart';
import 'core/services/database_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize database with sample data if needed
  try {
    final databaseService = DatabaseService.instance;
    // The getAllSalons() method will automatically seed data if collections are empty
    await databaseService.getAllSalons();
    await databaseService.getAllServices();
    debugPrint('Database initialization completed');
  } catch (e) {
    debugPrint('Database initialization failed: $e');
    // Continue app startup even if seeding fails
  }

  // System UI styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Orientation lock
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Performance optimizations
  if (kDebugMode) {
    // Enable performance monitoring in debug mode will be done later
    debugPrint('Debug mode: Performance monitoring enabled');
  }

  runApp(const ProviderScope(child: AuraBeautyApp()));
}

class AuraBeautyApp extends ConsumerWidget {
  const AuraBeautyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state for theme updates
    final authState = ref.watch(authProvider);

    // Theme based on gender and system theme
    ThemeData lightTheme;
    ThemeData darkTheme;

    if (authState.user?.gender == 'male') {
      lightTheme = AppTheme.maleLightTheme;
      darkTheme = AppTheme.maleDarkTheme;
    } else {
      // Default to female theme for new users or when gender is not set
      lightTheme = AppTheme.femaleLightTheme;
      darkTheme = AppTheme.femaleDarkTheme;
    }

    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Aura Beauty',
      theme: lightTheme,
      darkTheme: lightTheme,
      themeMode: ThemeMode.light,
      // Use route-based navigation instead of fixed home
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [AppRouter.routeObserver],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Ensure text scaling is within reasonable limits for beauty app UI
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
