class AppConstants {
  // App Information
  static const String appName = 'Aura Beauty Connect';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your personal beauty service companion';

  // Animation Durations
  static const Duration fastAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Spacing & Sizes
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Button Heights
  static const double buttonHeight = 50.0;
  static const double smallButtonHeight = 40.0;
  static const double largeButtonHeight = 60.0;

  // Image Sizes
  static const double smallImageSize = 60.0;
  static const double mediumImageSize = 100.0;
  static const double largeImageSize = 150.0;

  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;

  // Gender Constants
  static const String male = 'male';
  static const String female = 'female';

  // Service Types
  static const String salonService = 'salon';
  static const String homeService = 'home';

  // Booking Status
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  // Payment Status
  static const String paymentPending = 'payment_pending';
  static const String paymentSuccess = 'payment_success';
  static const String paymentFailed = 'payment_failed';

  // SharedPreferences Keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyThemeMode = 'theme_mode';
  static const String keySelectedGender = 'selected_gender';
  static const String keyLanguage = 'selected_language';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLocationPermission = 'location_permission';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String salonsCollection = 'salons';
  static const String servicesCollection = 'services';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';
  static const String couponsCollection = 'coupons';
  static const String notificationsCollection = 'notifications';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String salonImagesPath = 'salon_images';
  static const String serviceImagesPath = 'service_images';
  static const String reviewImagesPath = 'review_images';

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;

  // Network
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Maps
  static const double defaultLatitude = 25.3176; // Varanasi
  static const double defaultLongitude = 82.9739;
  static const double defaultZoom = 14.0;
  static const double searchRadius = 10.0; // 10 km

  // Pagination
  static const int pageSize = 20;
  static const int maxRetries = 3;

  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 3.0;

  // Notification Types
  static const String bookingConfirmation = 'booking_confirmation';
  static const String bookingReminder = 'booking_reminder';
  static const String serviceUpdate = 'service_update';
  static const String promotional = 'promotional';

  // Deep Links
  static const String baseUrl = 'https://aurabeauty.com';
  static const String shareBookingPath = '/booking';
  static const String shareSalonPath = '/salon';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String genericError = 'Something went wrong. Please try again';
  static const String authError = 'Authentication failed. Please login again';
  static const String locationError = 'Unable to get your location';
  static const String paymentError = 'Payment failed. Please try again';

  // Success Messages
  static const String loginSuccessMessage = 'Logged in successfully';
  static const String signupSuccessMessage = 'Account created successfully';
  static const String bookingSuccessMessage = 'Booking confirmed successfully';
  static const String paymentSuccessMessage = 'Payment completed successfully';

  // Service Categories
  static const List<String> serviceCategories = [
    'Hair Care',
    'Skin Care',
    'Nail Art',
    'Makeup',
    'Massage',
    'Bridal',
    'Men\'s Grooming',
  ];

  // Languages (for future multilingual support)
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'Hindi'},
  ];

  // Social Media Links
  static const String instagramUrl = 'https://instagram.com/aurabeauty';
  static const String facebookUrl = 'https://facebook.com/aurabeauty';
  static const String twitterUrl = 'https://twitter.com/aurabeauty';

  // Contact Information
  static const String supportEmail = 'support@aurabeauty.com';
  static const String supportPhone = '+91-9876543210';
  static const String privacyPolicyUrl = 'https://aurabeauty.com/privacy';
  static const String termsOfServiceUrl = 'https://aurabeauty.com/terms';
}
