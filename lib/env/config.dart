import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // Razorpay Configuration
  static String get razorpayKey => dotenv.env['RAZORPAY_KEY'] ?? '';

  static String get razorpaySecret => dotenv.env['RAZORPAY_SECRET'] ?? '';

  // Google Maps Configuration
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static bool get isRazorpayConfigured {
    return razorpayKey.isNotEmpty && razorpaySecret.isNotEmpty;
  }

  static bool get isGoogleMapsConfigured {
    return googleMapsApiKey.isNotEmpty;
  }

  // Get configuration status
  static Map<String, bool> get configurationStatus {
    return {
      'razorpay': isRazorpayConfigured,
      'googleMaps': isGoogleMapsConfigured,
    };
  }
}
