import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  EnvHelper._();

  // Initialize environment variables
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: kDebugMode ? '.env.dev' : '.env.prod');
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Could not load .env file: $e');
      }
    }
  }

  // Get environment variable with fallback
  static String _getEnvVar(String key, {String fallback = ''}) {
    return dotenv.env[key] ?? fallback;
  }

  // App Configuration
  static String get appName => _getEnvVar('APP_NAME', fallback: 'Aura Beauty Connect');
  static String get appVersion => _getEnvVar('APP_VERSION', fallback: '1.0.0');
  static bool get isDebugMode => kDebugMode;
  static bool get isProductionMode => kReleaseMode;

  // Firebase Configuration
  static String get firebaseProjectId => _getEnvVar('FIREBASE_PROJECT_ID');
  static String get firebaseApiKey => _getEnvVar('FIREBASE_API_KEY');
  static String get firebaseAppId => _getEnvVar('FIREBASE_APP_ID');
  static String get firebaseMessagingSenderId => _getEnvVar('FIREBASE_MESSAGING_SENDER_ID');
  static String get firebaseStorageBucket => _getEnvVar('FIREBASE_STORAGE_BUCKET');

  // Razorpay Configuration
  static String get razorpayKeyId => _getEnvVar('RAZORPAY_KEY_ID');
  static String get razorpayKeySecret => _getEnvVar('RAZORPAY_KEY_SECRET');

  // Google Maps Configuration
  static String get googleMapsApiKey => _getEnvVar('GOOGLE_MAPS_API_KEY');
  static String get googlePlacesApiKey => _getEnvVar('GOOGLE_PLACES_API_KEY');

  // API Configuration
  static String get apiBaseUrl => _getEnvVar('API_BASE_URL', fallback: 'https://api.aurabeauty.com');
  static String get apiVersion => _getEnvVar('API_VERSION', fallback: 'v1');
  static int get apiTimeout => int.tryParse(_getEnvVar('API_TIMEOUT')) ?? 30000;

  // Database Configuration
  static String get databaseUrl => _getEnvVar('DATABASE_URL');
  static String get databaseName => _getEnvVar('DATABASE_NAME', fallback: 'aura_beauty');

  // Storage Configuration
  static String get storageUrl => _getEnvVar('STORAGE_URL');
  static String get storageBucket => _getEnvVar('STORAGE_BUCKET');

  // Third-party Services
  static String get twilioAccountSid => _getEnvVar('TWILIO_ACCOUNT_SID');
  static String get twilioAuthToken => _getEnvVar('TWILIO_AUTH_TOKEN');
  static String get twilioPhoneNumber => _getEnvVar('TWILIO_PHONE_NUMBER');

  static String get sendgridApiKey => _getEnvVar('SENDGRID_API_KEY');
  static String get sendgridFromEmail => _getEnvVar('SENDGRID_FROM_EMAIL');

  // Analytics Configuration
  static String get googleAnalyticsId => _getEnvVar('GOOGLE_ANALYTICS_ID');
  static String get mixpanelToken => _getEnvVar('MIXPANEL_TOKEN');
  static String get amplitudeApiKey => _getEnvVar('AMPLITUDE_API_KEY');

  // Social Media Integration
  static String get facebookAppId => _getEnvVar('FACEBOOK_APP_ID');
  static String get googleClientId => _getEnvVar('GOOGLE_CLIENT_ID');
  static String get appleClientId => _getEnvVar('APPLE_CLIENT_ID');

  // Push Notification Configuration
  static String get fcmServerKey => _getEnvVar('FCM_SERVER_KEY');
  static String get apnsCertificate => _getEnvVar('APNS_CERTIFICATE');

  // Feature Flags
  static bool get enableCrashlytics => _getEnvVar('ENABLE_CRASHLYTICS').toLowerCase() == 'true';
  static bool get enableAnalytics => _getEnvVar('ENABLE_ANALYTICS').toLowerCase() == 'true';
  static bool get enablePushNotifications => _getEnvVar('ENABLE_PUSH_NOTIFICATIONS').toLowerCase() == 'true';
  static bool get enableLocationTracking => _getEnvVar('ENABLE_LOCATION_TRACKING').toLowerCase() == 'true';
  static bool get enableBiometricAuth => _getEnvVar('ENABLE_BIOMETRIC_AUTH').toLowerCase() == 'true';

  // App Store Configuration
  static String get appStoreId => _getEnvVar('APP_STORE_ID');
  static String get playStoreId => _getEnvVar('PLAY_STORE_ID');

  // Support Configuration
  static String get supportEmail => _getEnvVar('SUPPORT_EMAIL', fallback: 'support@aurabeauty.com');
  static String get supportPhone => _getEnvVar('SUPPORT_PHONE', fallback: '+91-9876543210');
  static String get helpCenterUrl => _getEnvVar('HELP_CENTER_URL', fallback: 'https://help.aurabeauty.com');

  // Legal Configuration
  static String get privacyPolicyUrl => _getEnvVar('PRIVACY_POLICY_URL', fallback: 'https://aurabeauty.com/privacy');
  static String get termsOfServiceUrl => _getEnvVar('TERMS_OF_SERVICE_URL', fallback: 'https://aurabeauty.com/terms');

  // CDN Configuration
  static String get cdnUrl => _getEnvVar('CDN_URL');
  static String get imagesCdnUrl => _getEnvVar('IMAGES_CDN_URL');

  // Rate Limiting Configuration
  static int get maxRequestsPerMinute => int.tryParse(_getEnvVar('MAX_REQUESTS_PER_MINUTE')) ?? 60;
  static int get maxRequestsPerHour => int.tryParse(_getEnvVar('MAX_REQUESTS_PER_HOUR')) ?? 1000;

  // Cache Configuration
  static int get cacheMaxSize => int.tryParse(_getEnvVar('CACHE_MAX_SIZE')) ?? 100; // MB
  static int get cacheExpiryHours => int.tryParse(_getEnvVar('CACHE_EXPIRY_HOURS')) ?? 24;

  // Image Configuration
  static int get maxImageUploadSize => int.tryParse(_getEnvVar('MAX_IMAGE_UPLOAD_SIZE')) ?? 5242880; // 5MB
  static String get allowedImageFormats => _getEnvVar('ALLOWED_IMAGE_FORMATS', fallback: 'jpg,jpeg,png,webp');
  static int get imageCompressionQuality => int.tryParse(_getEnvVar('IMAGE_COMPRESSION_QUALITY')) ?? 80;

  // Booking Configuration
  static int get maxAdvanceBookingDays => int.tryParse(_getEnvVar('MAX_ADVANCE_BOOKING_DAYS')) ?? 30;
  static int get minBookingAdvanceHours => int.tryParse(_getEnvVar('MIN_BOOKING_ADVANCE_HOURS')) ?? 2;
  static int get bookingTimeSlotMinutes => int.tryParse(_getEnvVar('BOOKING_TIME_SLOT_MINUTES')) ?? 30;

  // Payment Configuration
  static double get minPaymentAmount => double.tryParse(_getEnvVar('MIN_PAYMENT_AMOUNT')) ?? 1.0;
  static double get maxPaymentAmount => double.tryParse(_getEnvVar('MAX_PAYMENT_AMOUNT')) ?? 500000.0;
  static double get platformCommissionPercent => double.tryParse(_getEnvVar('PLATFORM_COMMISSION_PERCENT')) ?? 5.0;

  // Location Configuration
  static double get defaultLatitude => double.tryParse(_getEnvVar('DEFAULT_LATITUDE')) ?? 25.3176;
  static double get defaultLongitude => double.tryParse(_getEnvVar('DEFAULT_LONGITUDE')) ?? 82.9739;
  static double get maxSearchRadiusKm => double.tryParse(_getEnvVar('MAX_SEARCH_RADIUS_KM')) ?? 50.0;

  // Review Configuration
  static int get maxReviewLength => int.tryParse(_getEnvVar('MAX_REVIEW_LENGTH')) ?? 500;
  static int get minReviewLength => int.tryParse(_getEnvVar('MIN_REVIEW_LENGTH')) ?? 10;

  // Notification Configuration
  static bool get enableBookingReminders => _getEnvVar('ENABLE_BOOKING_REMINDERS').toLowerCase() == 'true';
  static bool get enablePromotionalNotifications => _getEnvVar('ENABLE_PROMOTIONAL_NOTIFICATIONS').toLowerCase() == 'true';
  static List<int> get reminderHours => _getEnvVar('REMINDER_HOURS', fallback: '24,2')
      .split(',')
      .map((h) => int.tryParse(h.trim()) ?? 24)
      .toList();

  // Security Configuration
  static int get passwordMinLength => int.tryParse(_getEnvVar('PASSWORD_MIN_LENGTH')) ?? 8;
  static int get maxLoginAttempts => int.tryParse(_getEnvVar('MAX_LOGIN_ATTEMPTS')) ?? 5;
  static int get sessionTimeoutMinutes => int.tryParse(_getEnvVar('SESSION_TIMEOUT_MINUTES')) ?? 1440; // 24 hours

  // Debug Configuration
  static bool get enableDetailedLogging => _getEnvVar('ENABLE_DETAILED_LOGGING').toLowerCase() == 'true';
  static bool get showDebugBanner => _getEnvVar('SHOW_DEBUG_BANNER').toLowerCase() == 'true' && kDebugMode;

  // Business Hours Configuration
  static int get businessStartHour => int.tryParse(_getEnvVar('BUSINESS_START_HOUR')) ?? 9;
  static int get businessEndHour => int.tryParse(_getEnvVar('BUSINESS_END_HOUR')) ?? 21;
  static List<String> get businessDays => _getEnvVar('BUSINESS_DAYS', fallback: 'monday,tuesday,wednesday,thursday,friday,saturday')
      .split(',')
      .map((d) => d.trim().toLowerCase())
      .toList();

  // Utility Methods

  // Check if a feature is enabled
  static bool isFeatureEnabled(String feature) {
    return _getEnvVar('ENABLE_${feature.toUpperCase()}').toLowerCase() == 'true';
  }

  // Get API endpoint
  static String getApiEndpoint(String path) {
    return '$apiBaseUrl/$apiVersion/$path';
  }

  // Get full image URL from CDN
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    return '${imagesCdnUrl ?? cdnUrl}/$imagePath';
  }

  // Validate required environment variables
  static List<String> validateRequiredVars() {
    final List<String> missing = [];
    final required = [
      'FIREBASE_PROJECT_ID',
      'FIREBASE_API_KEY',
      'RAZORPAY_KEY_ID',
      'GOOGLE_MAPS_API_KEY',
    ];

    for (final key in required) {
      if (_getEnvVar(key).isEmpty) {
        missing.add(key);
      }
    }

    return missing;
  }

  // Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'app': {
        'name': appName,
        'version': appVersion,
        'isDebug': isDebugMode,
        'isProduction': isProductionMode,
      },
      'api': {
        'baseUrl': apiBaseUrl,
        'version': apiVersion,
        'timeout': apiTimeout,
      },
      'features': {
        'crashlytics': enableCrashlytics,
        'analytics': enableAnalytics,
        'pushNotifications': enablePushNotifications,
        'locationTracking': enableLocationTracking,
        'biometricAuth': enableBiometricAuth,
      },
      'business': {
        'startHour': businessStartHour,
        'endHour': businessEndHour,
        'workingDays': businessDays,
      },
      'limits': {
        'maxAdvanceBookingDays': maxAdvanceBookingDays,
        'minBookingAdvanceHours': minBookingAdvanceHours,
        'maxPaymentAmount': maxPaymentAmount,
      },
    };
  }
}