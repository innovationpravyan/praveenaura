import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Font Family
  static const String fontFamily = 'Inter';

  // Helper method to build responsive text styles with Google Fonts
  static TextStyle _buildTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Display Text Styles - for hero sections
  static TextStyle displayLarge({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: -0.25,
      height: 1.12,
    );
  }

  static TextStyle displayMedium({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.16,
    );
  }

  static TextStyle displaySmall({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.22,
    );
  }

  // Headline Text Styles - for section headers
  static TextStyle headlineLarge({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.25,
    );
  }

  static TextStyle headlineMedium({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.29,
    );
  }

  static TextStyle headlineSmall({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.33,
    );
  }

  // Title Text Styles - for cards and components
  static TextStyle titleLarge({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.27,
    );
  }

  static TextStyle titleMedium({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.15,
      height: 1.50,
    );
  }

  static TextStyle titleSmall({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.1,
      height: 1.43,
    );
  }

  // Body Text Styles - for content
  static TextStyle bodyLarge({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.5,
      height: 1.50,
    );
  }

  static TextStyle bodyMedium({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.25,
      height: 1.43,
    );
  }

  static TextStyle bodySmall({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.getTextMediumEmphasisColor(isDark: isDark),
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  // Label Text Styles - for UI elements
  static TextStyle labelLarge({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.1,
      height: 1.43,
    );
  }

  static TextStyle labelMedium({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextMediumEmphasisColor(isDark: isDark),
      letterSpacing: 0.5,
      height: 1.33,
    );
  }

  static TextStyle labelSmall({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextDisabledColor(isDark: isDark),
      letterSpacing: 0.5,
      height: 1.45,
    );
  }

  // Button Text Styles
  static TextStyle buttonLarge({Color? color}) {
    return _buildTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 0.15,
      height: 1.25,
    );
  }

  static TextStyle buttonMedium({Color? color}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 0.1,
      height: 1.43,
    );
  }

  static TextStyle buttonSmall({Color? color}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 0.5,
      height: 1.33,
    );
  }

  // Custom App-specific Text Styles
  static TextStyle appBarTitle({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.15,
      height: 1.2,
    );
  }

  static TextStyle cardTitle({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.3,
    );
  }

  static TextStyle cardSubtitle({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.getTextMediumEmphasisColor(isDark: isDark),
      letterSpacing: 0.1,
      height: 1.4,
    );
  }

  static TextStyle price({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0,
      height: 1.2,
    );
  }

  static TextStyle rating({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.getTextHighEmphasisColor(isDark: isDark),
      letterSpacing: 0.1,
      height: 1.3,
    );
  }

  static TextStyle caption({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.getTextMediumEmphasisColor(isDark: isDark),
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  static TextStyle overline({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.getTextMediumEmphasisColor(isDark: isDark),
      letterSpacing: 1.5,
      height: 1.6,
    );
  }

  static TextStyle error({bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.getErrorColor(isDark: isDark),
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  static TextStyle success({bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.getSuccessColor(isDark: isDark),
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  static TextStyle warning({bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.getWarningColor(isDark: isDark),
      letterSpacing: 0.4,
      height: 1.33,
    );
  }

  static TextStyle link({Color? color, bool isDark = false}) {
    return _buildTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color:
          color ?? AppColors.getPrimaryColorForGender('female', isDark: isDark),
      letterSpacing: 0.1,
      height: 1.43,
    ).copyWith(decoration: TextDecoration.underline);
  }

  // Helper methods
  static TextStyle getButtonStyleForSize(String size, {Color? color}) {
    switch (size) {
      case 'large':
        return buttonLarge(color: color);
      case 'small':
        return buttonSmall(color: color);
      default:
        return buttonMedium(color: color);
    }
  }

  static TextStyle getTitleStyleForLevel(
    int level, {
    Color? color,
    bool isDark = false,
  }) {
    switch (level) {
      case 1:
        return headlineLarge(color: color, isDark: isDark);
      case 2:
        return headlineMedium(color: color, isDark: isDark);
      case 3:
        return headlineSmall(color: color, isDark: isDark);
      case 4:
        return titleLarge(color: color, isDark: isDark);
      case 5:
        return titleMedium(color: color, isDark: isDark);
      case 6:
        return titleSmall(color: color, isDark: isDark);
      default:
        return titleMedium(color: color, isDark: isDark);
    }
  }

  static TextStyle getBodyStyleForSize(
    String size, {
    Color? color,
    bool isDark = false,
  }) {
    switch (size) {
      case 'large':
        return bodyLarge(color: color, isDark: isDark);
      case 'small':
        return bodySmall(color: color, isDark: isDark);
      default:
        return bodyMedium(color: color, isDark: isDark);
    }
  }

  // Build complete text theme for ThemeData
  static TextTheme buildTextTheme({required bool isDark}) {
    return TextTheme(
      displayLarge: displayLarge(isDark: isDark),
      displayMedium: displayMedium(isDark: isDark),
      displaySmall: displaySmall(isDark: isDark),
      headlineLarge: headlineLarge(isDark: isDark),
      headlineMedium: headlineMedium(isDark: isDark),
      headlineSmall: headlineSmall(isDark: isDark),
      titleLarge: titleLarge(isDark: isDark),
      titleMedium: titleMedium(isDark: isDark),
      titleSmall: titleSmall(isDark: isDark),
      bodyLarge: bodyLarge(isDark: isDark),
      bodyMedium: bodyMedium(isDark: isDark),
      bodySmall: bodySmall(isDark: isDark),
      labelLarge: labelLarge(isDark: isDark),
      labelMedium: labelMedium(isDark: isDark),
      labelSmall: labelSmall(isDark: isDark),
    );
  }
}
