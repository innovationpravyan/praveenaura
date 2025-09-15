import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

  runApp(const ProviderScope(child: AuraBeautyApp()));
}

class AuraBeautyApp extends ConsumerWidget {
  const AuraBeautyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Theme based on gender or default
    ThemeData lightTheme;
    ThemeData darkTheme;

    if (authState.user?.gender == 'male') {
      lightTheme = AppTheme.maleLightTheme;
      darkTheme = AppTheme.maleDarkTheme;
    } else {
      lightTheme = AppTheme.femaleLightTheme;
      darkTheme = AppTheme.femaleDarkTheme;
    }

    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Aura Beauty',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
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
