import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color primaryPinkLight = Color(0xFFF48FB1);
  static const Color primaryPinkDark = Color(0xFFC2185B);

  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueLight = Color(0xFF64B5F6);
  static const Color primaryBlueDark = Color(0xFF1976D2);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Grey Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Female Theme Colors
  static const Color femaleBackgroundLight = Color(0xFFFCF8F9);
  static const Color femaleBackgroundDark = Color(0xFF1A0E14);
  static const Color femaleCardLight = Color(0xFFFFFFFF);
  static const Color femaleCardDark = Color(0xFF2D1B24);
  static const Color femaleSecondary = Color(0xFFFF4081);

  // Male Theme Colors
  static const Color maleBackgroundLight = Color(0xFFF8FAFE);
  static const Color maleBackgroundDark = Color(0xFF0E1419);
  static const Color maleCardLight = Color(0xFFFFFFFF);
  static const Color maleCardDark = Color(0xFF1B252D);
  static const Color maleSecondary = Color(0xFF03A9F4);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFBBDEFB);
  static const Color infoDark = Color(0xFF1976D2);

  // Shadow Colors
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowMedium = Color(0x3D000000);
  static const Color shadowDark = Color(0x66000000);

  // Special Colors
  static const Color starColor = Color(0xFFFFC107);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Gradients
  static const List<Color> pinkGradient = [
    Color(0xFFE91E63),
    Color(0xFFF06292),
  ];

  static const List<Color> blueGradient = [
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
  ];

  static const List<Color> purpleGradient = [
    Color(0xFF9C27B0),
    Color(0xFFBA68C8),
  ];

  static const List<Color> orangeGradient = [
    Color(0xFFFF9800),
    Color(0xFFFFB74D),
  ];

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Hair Care': Color(0xFFE91E63),
    'Skin Care': Color(0xFF4CAF50),
    'Nail Art': Color(0xFFFF9800),
    'Makeup': Color(0xFF9C27B0),
    'Massage': Color(0xFF2196F3),
    'Bridal': Color(0xFFF44336),
    'Men\'s Grooming': Color(0xFF607D8B),
  };

  // Booking Status Colors
  static const Map<String, Color> bookingStatusColors = {
    'pending': Color(0xFFFF9800),
    'confirmed': Color(0xFF2196F3),
    'in_progress': Color(0xFF9C27B0),
    'completed': Color(0xFF4CAF50),
    'cancelled': Color(0xFFF44336),
  };

  // Helper methods
  static Color getColorWithAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }

  static Color getPrimaryColorForGender(String gender) {
    return gender == 'female' ? primaryPink : primaryBlue;
  }

  static List<Color> getGradientForGender(String gender) {
    return gender == 'female' ? pinkGradient : blueGradient;
  }
}