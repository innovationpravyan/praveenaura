import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Warm Professional Palette - Beauty Services Color System

  // Brand Colors - Light Theme
  static const Color primaryPinkLight = Color(0xFF8B5A3C); // Warm professional brown for female
  static const Color primaryPinkDark = Color(0xFFD4A574); // Golden for female dark mode
  static const Color primaryPinkVariantLight = Color(0xFF6B4228);
  static const Color primaryPinkVariantDark = Color(0xFF8B5A3C);

  static const Color primaryBlueLight = Color(0xFF2196F3); // Keep original blue for male
  static const Color primaryBlueDark = Color(0xFF64B5F6); // Lighter blue for male dark mode
  static const Color primaryBlueVariantLight = Color(0xFF1976D2);
  static const Color primaryBlueVariantDark = Color(0xFF2196F3);

  // Secondary Colors
  static const Color secondaryLight = Color(0xFFF4E6D9); // Soft cream
  static const Color secondaryDark = Color(0xFF2C2C2C); // Dark surface
  static const Color secondaryVariantLight = Color(0xFFE8D5C4);
  static const Color secondaryVariantDark = Color(0xFF3A3A3A);

  // Accent Colors
  static const Color accentLight = Color(0xFFD4A574); // Golden highlight
  static const Color accentDark = Color(0xFFD4A574);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F8F8); // Eye strain reducing background
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white for cards
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Text Colors with proper opacity for mobile readability
  static const Color textHighEmphasisLight = Color(0xFF2C2C2C); // Primary text
  static const Color textMediumEmphasisLight = Color(0xFF6B6B6B); // Secondary text
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xFFE0E0E0);
  static const Color textMediumEmphasisDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  // Female Theme Colors
  static const Color femaleBackgroundLight = Color(0xFFF8F8F8);
  static const Color femaleBackgroundDark = Color(0xFF1A1A1A);
  static const Color femaleCardLight = Color(0xFFFFFFFF);
  static const Color femaleCardDark = Color(0xFF2C2C2C);
  static const Color femaleSecondary = Color(0xFFF4E6D9);

  // Male Theme Colors
  static const Color maleBackgroundLight = Color(0xFFF8F8F8);
  static const Color maleBackgroundDark = Color(0xFF1A1A1A);
  static const Color maleCardLight = Color(0xFFFFFFFF);
  static const Color maleCardDark = Color(0xFF2C2C2C);
  static const Color maleSecondary = Color(0xFF03A9F4);

  // Status Colors
  static const Color successLight = Color(0xFF4A7C59); // Booking confirmations
  static const Color successDark = Color(0xFF81C784);
  static const Color warningLight = Color(0xFFD4A574); // Time-sensitive alerts
  static const Color warningDark = Color(0xFFD4A574);
  static const Color errorLight = Color(0xFFB85450); // Muted red for validation
  static const Color errorDark = Color(0xFFE57373);
  static const Color infoLight = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF64B5F6);

  // Shadow Colors - subtle elevation for spatial minimalism
  static const Color shadowLight = Color(0x33000000); // 20% opacity black
  static const Color shadowDark = Color(0x33FFFFFF); // 20% opacity white

  // Divider Colors
  static const Color dividerLight = Color(0x1A000000); // 10% opacity
  static const Color dividerDark = Color(0x1AFFFFFF); // 10% opacity

  // Dialog Colors
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF2C2C2C);

  // Special Colors
  static const Color starColor = Color(0xFFFFC107);

  // Gradients
  static const List<Color> pinkGradientLight = [
    Color(0xFF8B5A3C),
    Color(0xFFD4A574),
  ];

  static const List<Color> pinkGradientDark = [
    Color(0xFFD4A574),
    Color(0xFF8B5A3C),
  ];

  static const List<Color> blueGradientLight = [
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
  ];

  static const List<Color> blueGradientDark = [
    Color(0xFF64B5F6),
    Color(0xFF2196F3),
  ];

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Hair Care': Color(0xFF8B5A3C),
    'Skin Care': Color(0xFF4A7C59),
    'Nail Art': Color(0xFFD4A574),
    'Makeup': Color(0xFF9C27B0),
    'Massage': Color(0xFF2196F3),
    'Bridal': Color(0xFFB85450),
    'Men\'s Grooming': Color(0xFF607D8B),
  };

  // Booking Status Colors
  static const Map<String, Color> bookingStatusColors = {
    'pending': Color(0xFFD4A574),
    'confirmed': Color(0xFF2196F3),
    'in_progress': Color(0xFF9C27B0),
    'completed': Color(0xFF4A7C59),
    'cancelled': Color(0xFFB85450),
  };

  // Helper methods
  static Color getColorWithAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }

  static Color getPrimaryColorForGender(String gender, {bool isDark = false}) {
    if (gender == 'female') {
      return isDark ? primaryPinkDark : primaryPinkLight;
    } else {
      return isDark ? primaryBlueDark : primaryBlueLight;
    }
  }

  static List<Color> getGradientForGender(String gender, {bool isDark = false}) {
    if (gender == 'female') {
      return isDark ? pinkGradientDark : pinkGradientLight;
    } else {
      return isDark ? blueGradientDark : blueGradientLight;
    }
  }

  static Color getSecondaryColorForGender(String gender) {
    return gender == 'female' ? femaleSecondary : maleSecondary;
  }

  static Color getBackgroundColor({bool isDark = false}) {
    return isDark ? backgroundDark : backgroundLight;
  }

  static Color getSurfaceColor({bool isDark = false}) {
    return isDark ? surfaceDark : surfaceLight;
  }

  static Color getTextHighEmphasisColor({bool isDark = false}) {
    return isDark ? textHighEmphasisDark : textHighEmphasisLight;
  }

  static Color getTextMediumEmphasisColor({bool isDark = false}) {
    return isDark ? textMediumEmphasisDark : textMediumEmphasisLight;
  }

  static Color getTextDisabledColor({bool isDark = false}) {
    return isDark ? textDisabledDark : textDisabledLight;
  }

  static Color getSuccessColor({bool isDark = false}) {
    return isDark ? successDark : successLight;
  }

  static Color getWarningColor({bool isDark = false}) {
    return isDark ? warningDark : warningLight;
  }

  static Color getErrorColor({bool isDark = false}) {
    return isDark ? errorDark : errorLight;
  }

  static Color getInfoColor({bool isDark = false}) {
    return isDark ? infoDark : infoLight;
  }

  static Color getDividerColor({bool isDark = false}) {
    return isDark ? dividerDark : dividerLight;
  }

  static Color getShadowColor({bool isDark = false}) {
    return isDark ? shadowDark : shadowLight;
  }
}