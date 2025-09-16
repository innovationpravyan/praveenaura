import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // Female Light Theme
  static ThemeData get femaleLightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      gender: 'female',
      isDark: false,
    );
  }

  // Female Dark Theme
  static ThemeData get femaleDarkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      gender: 'female',
      isDark: true,
    );
  }

  // Male Light Theme
  static ThemeData get maleLightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      gender: 'male',
      isDark: false,
    );
  }

  // Male Dark Theme
  static ThemeData get maleDarkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      gender: 'male',
      isDark: true,
    );
  }

  // Main theme builder method
  static ThemeData _buildTheme({
    required Brightness brightness,
    required String gender,
    required bool isDark,
  }) {
    final primaryColor = AppColors.getPrimaryColorForGender(
      gender,
      isDark: isDark,
    );
    final backgroundColor = AppColors.getBackgroundColor(isDark: isDark);
    final surfaceColor = AppColors.getSurfaceColor(isDark: isDark);
    final textHighEmphasis = AppColors.getTextHighEmphasisColor(isDark: isDark);
    final textMediumEmphasis = AppColors.getTextMediumEmphasisColor(
      isDark: isDark,
    );
    final textDisabled = AppColors.getTextDisabledColor(isDark: isDark);
    final dividerColor = AppColors.getDividerColor(isDark: isDark);
    final shadowColor = AppColors.getShadowColor(isDark: isDark);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: isDark ? AppColors.textHighEmphasisDark : AppColors.white,
        primaryContainer: isDark
            ? AppColors.secondaryDark
            : AppColors.secondaryLight,
        onPrimaryContainer: textHighEmphasis,
        secondary: isDark ? AppColors.accentDark : AppColors.accentLight,
        onSecondary: isDark
            ? AppColors.textHighEmphasisDark
            : AppColors.textHighEmphasisLight,
        secondaryContainer: isDark
            ? AppColors.secondaryVariantDark
            : AppColors.secondaryVariantLight,
        onSecondaryContainer: textHighEmphasis,
        tertiary: AppColors.getSuccessColor(isDark: isDark),
        onTertiary: isDark ? AppColors.textHighEmphasisDark : AppColors.white,
        tertiaryContainer: AppColors.getSuccessColor(
          isDark: isDark,
        ).withOpacity(isDark ? 0.2 : 0.1),
        onTertiaryContainer: AppColors.getSuccessColor(isDark: isDark),
        error: AppColors.getErrorColor(isDark: isDark),
        onError: isDark ? AppColors.textHighEmphasisDark : AppColors.white,
        surface: surfaceColor,
        onSurface: textHighEmphasis,
        onSurfaceVariant: textMediumEmphasis,
        outline: dividerColor,
        outlineVariant: dividerColor.withOpacity(0.5),
        shadow: shadowColor,
        scrim: shadowColor,
        inverseSurface: isDark ? AppColors.surfaceLight : AppColors.surfaceDark,
        onInverseSurface: isDark
            ? AppColors.textHighEmphasisLight
            : AppColors.textHighEmphasisDark,
        inversePrimary: isDark
            ? AppColors.getPrimaryColorForGender(gender, isDark: false)
            : AppColors.getPrimaryColorForGender(gender, isDark: true),
      ),

      // AppBar theme for beauty services - clean and professional
      appBarTheme: _buildAppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textHighEmphasis,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        shadowColor: shadowColor,
        isDark: isDark,
      ),

      // Card theme with subtle elevation
      cardTheme: _buildCardTheme(color: surfaceColor, shadowColor: shadowColor),

      // Bottom navigation optimized for beauty services
      bottomNavigationBarTheme: _buildBottomNavTheme(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMediumEmphasis,
        isDark: isDark,
      ),

      // Floating action button for primary booking actions
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(
        backgroundColor: primaryColor,
        foregroundColor: isDark
            ? AppColors.textHighEmphasisDark
            : AppColors.white,
      ),

      // Button themes with warm professional styling
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: primaryColor,
        foregroundColor: isDark
            ? AppColors.textHighEmphasisDark
            : AppColors.white,
        shadowColor: shadowColor,
      ),

      outlinedButtonTheme: _buildOutlinedButtonTheme(primaryColor),

      textButtonTheme: _buildTextButtonTheme(primaryColor),

      // Typography with Google Fonts Inter
      textTheme: AppTextStyles.buildTextTheme(isDark: isDark),

      // Input decoration for booking forms
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: surfaceColor,
        borderColor: dividerColor.withOpacity(0.5),
        focusColor: primaryColor,
        isDark: isDark,
      ),

      // Interactive elements
      switchTheme: _buildSwitchTheme(
        primaryColor: primaryColor,
        trackColor: textMediumEmphasis,
      ),

      checkboxTheme: _buildCheckboxTheme(
        primaryColor: primaryColor,
        borderColor: textMediumEmphasis,
      ),

      radioTheme: _buildRadioTheme(
        primaryColor: primaryColor,
        unselectedColor: textMediumEmphasis,
      ),

      progressIndicatorTheme: _buildProgressIndicatorTheme(
        color: primaryColor,
        trackColor: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
      ),

      sliderTheme: _buildSliderTheme(
        primaryColor: primaryColor,
        trackColor: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
      ),

      // Tab bar theme for service categories
      tabBarTheme: _buildTabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textMediumEmphasis,
        indicatorColor: primaryColor,
        isDark: isDark,
      ),

      tooltipTheme: _buildTooltipTheme(
        backgroundColor: textHighEmphasis.withOpacity(0.9),
        textColor: surfaceColor,
        isDark: isDark,
      ),

      snackBarTheme: _buildSnackBarTheme(
        backgroundColor: textHighEmphasis,
        contentTextColor: surfaceColor,
        actionTextColor: isDark ? AppColors.accentDark : AppColors.accentLight,
      ),

      // Chip theme for service tags
      chipTheme: _buildChipTheme(
        backgroundColor: isDark
            ? AppColors.secondaryDark
            : AppColors.secondaryLight,
        selectedColor: primaryColor,
        labelColor: textHighEmphasis,
        secondaryLabelColor: isDark
            ? AppColors.textHighEmphasisDark
            : AppColors.white,
        isDark: isDark,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.dialogDark : AppColors.dialogLight,
      ),

      dividerColor: dividerColor,
    );
  }

  // Helper methods for building theme components
  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required SystemUiOverlayStyle systemOverlayStyle,
    required Color shadowColor,
    required bool isDark,
  }) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      shadowColor: shadowColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTextStyles.appBarTitle(
        color: foregroundColor,
        isDark: isDark,
      ),
      iconTheme: IconThemeData(
        color: foregroundColor,
        size: AppConstants.mediumIconSize,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor,
        size: AppConstants.mediumIconSize,
      ),
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  static CardThemeData _buildCardTheme({
    required Color color,
    required Color shadowColor,
  }) {
    return CardThemeData(
      color: color,
      elevation: 2.0,
      shadowColor: shadowColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme({
    required Color backgroundColor,
    required Color selectedItemColor,
    required Color unselectedItemColor,
    required bool isDark,
  }) {
    return BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTextStyles.labelSmall(
        isDark: isDark,
      ).copyWith(fontWeight: FontWeight.w500),
      unselectedLabelStyle: AppTextStyles.labelSmall(
        isDark: isDark,
      ).copyWith(fontWeight: FontWeight.w400),
    );
  }

  static FloatingActionButtonThemeData _buildFloatingActionButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return FloatingActionButtonThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 6.0,
      highlightElevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color shadowColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 2.0,
        shadowColor: shadowColor,
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.largeSpacing,
          vertical: AppConstants.mediumSpacing,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        textStyle: AppTextStyles.buttonMedium(color: foregroundColor),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Color primaryColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.largeSpacing,
          vertical: AppConstants.mediumSpacing,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        textStyle: AppTextStyles.buttonMedium(color: primaryColor),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(Color primaryColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.mediumSpacing,
          vertical: AppConstants.smallSpacing,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: AppTextStyles.buttonSmall(color: primaryColor),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusColor,
    required bool isDark,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: AppConstants.mediumSpacing,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: BorderSide(color: focusColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: BorderSide(
          color: AppColors.getErrorColor(isDark: isDark),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: BorderSide(
          color: AppColors.getErrorColor(isDark: isDark),
          width: 2.0,
        ),
      ),
      labelStyle: AppTextStyles.labelMedium(
        color: AppColors.getTextMediumEmphasisColor(isDark: isDark),
        isDark: isDark,
      ),
      hintStyle: AppTextStyles.bodyMedium(
        color: AppColors.getTextDisabledColor(isDark: isDark),
        isDark: isDark,
      ),
      errorStyle: AppTextStyles.error(isDark: isDark),
    );
  }

  static SwitchThemeData _buildSwitchTheme({
    required Color primaryColor,
    required Color trackColor,
  }) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return trackColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withOpacity(0.3);
        }
        return trackColor.withOpacity(0.3);
      }),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme({
    required Color primaryColor,
    required Color borderColor,
  }) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: BorderSide(color: borderColor, width: 2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    );
  }

  static RadioThemeData _buildRadioTheme({
    required Color primaryColor,
    required Color unselectedColor,
  }) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return unselectedColor;
      }),
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme({
    required Color color,
    required Color trackColor,
  }) {
    return ProgressIndicatorThemeData(
      color: color,
      linearTrackColor: trackColor,
      circularTrackColor: trackColor,
    );
  }

  static SliderThemeData _buildSliderTheme({
    required Color primaryColor,
    required Color trackColor,
  }) {
    return SliderThemeData(
      activeTrackColor: primaryColor,
      thumbColor: primaryColor,
      overlayColor: primaryColor.withOpacity(0.2),
      inactiveTrackColor: trackColor,
      trackHeight: 4.0,
    );
  }

  static TabBarThemeData _buildTabBarTheme({
    required Color labelColor,
    required Color unselectedLabelColor,
    required Color indicatorColor,
    required bool isDark,
  }) {
    return TabBarThemeData(
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      indicatorColor: indicatorColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: AppTextStyles.labelLarge(
        isDark: isDark,
      ).copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyles.labelLarge(
        isDark: isDark,
      ).copyWith(fontWeight: FontWeight.w400),
    );
  }

  static TooltipThemeData _buildTooltipTheme({
    required Color backgroundColor,
    required Color textColor,
    required bool isDark,
  }) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: AppTextStyles.bodySmall(color: textColor, isDark: isDark),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme({
    required Color backgroundColor,
    required Color contentTextColor,
    required Color actionTextColor,
  }) {
    return SnackBarThemeData(
      backgroundColor: backgroundColor,
      contentTextStyle: GoogleFonts.inter(
        color: contentTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: actionTextColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
    );
  }

  static ChipThemeData _buildChipTheme({
    required Color backgroundColor,
    required Color selectedColor,
    required Color labelColor,
    required Color secondaryLabelColor,
    required bool isDark,
  }) {
    return ChipThemeData(
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      labelStyle: AppTextStyles.labelSmall(
        color: labelColor,
        isDark: isDark,
      ).copyWith(fontWeight: FontWeight.w500),
      secondaryLabelStyle: AppTextStyles.labelSmall(
        color: secondaryLabelColor,
        isDark: isDark,
      ).copyWith(fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  // Helper methods for theme selection
  static ThemeData getThemeForGender(String gender, {bool isDark = false}) {
    if (gender == AppConstants.female) {
      return isDark ? femaleDarkTheme : femaleLightTheme;
    } else {
      return isDark ? maleDarkTheme : maleLightTheme;
    }
  }

  static SystemUiOverlayStyle getSystemUiOverlayStyle(
    String gender, {
    bool isDark = false,
  }) {
    return isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  }
}
