import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Luxurious Purple Palette - Premium Beauty Services

  // Brand Colors - Rich Purple Spectrum
  static const Color primaryPinkLight = Color(0xFF6B46C1); // Rich purple primary
  static const Color primaryPinkDark = Color(0xFF6B46C1); // Same for consistency
  static const Color primaryPinkVariantLight = Color(0xFF8B5CF6); // Lighter purple variant
  static const Color primaryPinkVariantDark = Color(0xFF8B5CF6);

  static const Color primaryBlueLight = Color(0xFF6B46C1); // Rich purple for all themes
  static const Color primaryBlueDark = Color(0xFF6B46C1); // Same for consistency
  static const Color primaryBlueVariantLight = Color(0xFF8B5CF6);
  static const Color primaryBlueVariantDark = Color(0xFF8B5CF6);

  // Secondary Colors - Purple Harmony
  static const Color secondaryLight = Color(0xFFF3F0FF); // Very light purple background
  static const Color secondaryDark = Color(0xFFF3F0FF); // Same for light theme
  static const Color secondaryVariantLight = Color(0xFFE9E4FF); // Light purple surface
  static const Color secondaryVariantDark = Color(0xFFE9E4FF);

  // Accent Colors - Purple Complements
  static const Color accentLight = Color(0xFFA855F7); // Medium purple accent
  static const Color accentDark = Color(0xFFA855F7);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Background Colors - Purple Elegance
  static const Color backgroundLight = Color(0xFFFCFBFF); // Ultra light purple background
  static const Color backgroundDark = Color(0xFFFCFBFF); // Same for light theme
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white for cards
  static const Color surfaceDark = Color(0xFFFFFFFF); // Same for light theme

  // Text Colors with proper opacity for mobile readability
  static const Color textHighEmphasisLight = Color(0xFF212121); // Dark text for light theme
  static const Color textMediumEmphasisLight = Color(0xFF757575); // Medium gray text
  static const Color textDisabledLight = Color(0xFFBDBDBD); // Light gray for disabled

  static const Color textHighEmphasisDark = Color(0xFF212121); // Same for light theme
  static const Color textMediumEmphasisDark = Color(0xFF757575); // Same for light theme
  static const Color textDisabledDark = Color(0xFFBDBDBD); // Same for light theme

  // Female Theme Colors - Feminine Purple Elegance
  static const Color femaleBackgroundLight = Color(0xFFFCFBFF);
  static const Color femaleBackgroundDark = Color(0xFFFCFBFF);
  static const Color femaleCardLight = Color(0xFFFFFFFF);
  static const Color femaleCardDark = Color(0xFFFFFFFF);
  static const Color femaleSecondary = Color(0xFFF3F0FF);

  // Male Theme Colors - Sophisticated Purple
  static const Color maleBackgroundLight = Color(0xFFFCFBFF);
  static const Color maleBackgroundDark = Color(0xFFFCFBFF);
  static const Color maleCardLight = Color(0xFFFFFFFF);
  static const Color maleCardDark = Color(0xFFFFFFFF);
  static const Color maleSecondary = Color(0xFFF3F0FF);

  // Status Colors - Purple Harmony
  static const Color successLight = Color(0xFF10B981); // Emerald green for success
  static const Color successDark = Color(0xFF10B981);
  static const Color warningLight = Color(0xFFF59E0B); // Amber for warnings
  static const Color warningDark = Color(0xFFF59E0B);
  static const Color errorLight = Color(0xFFEF4444); // Red for errors
  static const Color errorDark = Color(0xFFEF4444);
  static const Color infoLight = Color(0xFF8B5CF6); // Light purple for info
  static const Color infoDark = Color(0xFF8B5CF6);

  // Shadow Colors - subtle elevation for spatial minimalism
  static const Color shadowLight = Color(0x1A000000); // 10% opacity black for light theme
  static const Color shadowDark = Color(0x1A000000); // Same for consistency

  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0); // Light gray dividers
  static const Color dividerDark = Color(0xFFE0E0E0); // Same for light theme

  // Dialog Colors
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFFFFFFFF);

  // Special Colors
  static const Color starColor = Color(0xFFFFC107);

  // Gradients - Rich Purple Spectrum
  static const List<Color> pinkGradientLight = [
    Color(0xFF6B46C1),
    Color(0xFFA855F7),
  ];

  static const List<Color> pinkGradientDark = [
    Color(0xFF6B46C1),
    Color(0xFFA855F7),
  ];

  static const List<Color> blueGradientLight = [
    Color(0xFF6B46C1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> blueGradientDark = [
    Color(0xFF6B46C1),
    Color(0xFF8B5CF6),
  ];

  // Category Colors - Purple Spectrum
  static const Map<String, Color> categoryColors = {
    'Hair Care': Color(0xFF6B46C1),
    'Skin Care': Color(0xFF10B981),
    'Nail Art': Color(0xFFA855F7),
    'Makeup': Color(0xFFD946EF),
    'Massage': Color(0xFF8B5CF6),
    'Bridal': Color(0xFFEC4899),
    'Men\'s Grooming': Color(0xFF7C3AED),
  };

  // Booking Status Colors - Purple Theme Harmony
  static const Map<String, Color> bookingStatusColors = {
    'pending': Color(0xFFF59E0B),
    'confirmed': Color(0xFF6B46C1),
    'in_progress': Color(0xFFA855F7),
    'completed': Color(0xFF10B981),
    'cancelled': Color(0xFFEF4444),
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