import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // Female Light Theme
  static ThemeData get femaleLightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.femaleBackgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.light,
        primary: AppColors.primaryPink,
        onPrimary: AppColors.white,
        secondary: AppColors.femaleSecondary,
        onSecondary: AppColors.white,
        surface: AppColors.femaleCardLight,
        onSurface: AppColors.grey800,
        outline: AppColors.grey400,
        error: AppColors.error,
      ),
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.femaleBackgroundLight,
        foregroundColor: AppColors.grey800,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(AppColors.primaryPink),
      outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.primaryPink),
      textButtonTheme: _buildTextButtonTheme(AppColors.primaryPink),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.white,
        borderColor: AppColors.grey300,
        focusColor: AppColors.primaryPink,
      ),
      cardTheme: _buildCardTheme(
        color: AppColors.femaleCardLight,
        shadowColor: AppColors.shadowLight,
      ),
      bottomNavigationBarTheme: _buildBottomNavTheme(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryPink,
      ),
    );
  }

  // Female Dark Theme
  static ThemeData get femaleDarkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.femaleBackgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.dark,
        primary: AppColors.primaryPink,
        onPrimary: AppColors.white,
        secondary: AppColors.femaleSecondary,
        onSecondary: AppColors.white,
        surface: AppColors.femaleCardDark,
        onSurface: AppColors.white,
        outline: AppColors.grey500,
        error: AppColors.error,
      ),
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.femaleBackgroundDark,
        foregroundColor: AppColors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(AppColors.primaryPink),
      outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.primaryPink),
      textButtonTheme: _buildTextButtonTheme(AppColors.primaryPink),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.femaleCardDark,
        borderColor: AppColors.grey600,
        focusColor: AppColors.primaryPink,
      ),
      cardTheme: _buildCardTheme(
        color: AppColors.femaleCardDark,
        shadowColor: AppColors.shadowDark,
      ),
      bottomNavigationBarTheme: _buildBottomNavTheme(
        backgroundColor: AppColors.femaleCardDark,
        selectedItemColor: AppColors.primaryPink,
      ),
    );
  }

  // Male Light Theme
  static ThemeData get maleLightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.maleBackgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.white,
        secondary: AppColors.maleSecondary,
        onSecondary: AppColors.white,
        surface: AppColors.maleCardLight,
        onSurface: AppColors.grey800,
        outline: AppColors.grey400,
        error: AppColors.error,
      ),
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.maleBackgroundLight,
        foregroundColor: AppColors.grey800,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(AppColors.primaryBlue),
      outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.primaryBlue),
      textButtonTheme: _buildTextButtonTheme(AppColors.primaryBlue),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.white,
        borderColor: AppColors.grey300,
        focusColor: AppColors.primaryBlue,
      ),
      cardTheme: _buildCardTheme(
        color: AppColors.maleCardLight,
        shadowColor: AppColors.shadowLight,
      ),
      bottomNavigationBarTheme: _buildBottomNavTheme(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryBlue,
      ),
    );
  }

  // Male Dark Theme
  static ThemeData get maleDarkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.maleBackgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.dark,
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.white,
        secondary: AppColors.maleSecondary,
        onSecondary: AppColors.white,
        surface: AppColors.maleCardDark,
        onSurface: AppColors.white,
        outline: AppColors.grey500,
        error: AppColors.error,
      ),
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.maleBackgroundDark,
        foregroundColor: AppColors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(AppColors.primaryBlue),
      outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.primaryBlue),
      textButtonTheme: _buildTextButtonTheme(AppColors.primaryBlue),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.maleCardDark,
        borderColor: AppColors.grey600,
        focusColor: AppColors.primaryBlue,
      ),
      cardTheme: _buildCardTheme(
        color: AppColors.maleCardDark,
        shadowColor: AppColors.shadowDark,
      ),
      bottomNavigationBarTheme: _buildBottomNavTheme(
        backgroundColor: AppColors.maleCardDark,
        selectedItemColor: AppColors.primaryBlue,
      ),
    );
  }

  // Helper methods for building theme components
  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: systemOverlayStyle,
      iconTheme: IconThemeData(
        color: foregroundColor,
        size: AppConstants.mediumIconSize,
      ),
      surfaceTintColor: Colors.transparent,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(Color primaryColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
        elevation: 2,
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        textStyle: AppTextStyles.buttonMedium,
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Color primaryColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        textStyle: AppTextStyles.buttonMedium.copyWith(color: primaryColor),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(Color primaryColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: AppTextStyles.buttonMedium.copyWith(color: primaryColor),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusColor,
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
        borderSide: BorderSide(color: focusColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
      labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.grey700),
      errorStyle: AppTextStyles.error,
    );
  }

  static CardThemeData _buildCardTheme({
    required Color color,
    required Color shadowColor,
  }) {
    return CardThemeData(
      color: color,
      elevation: 2,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme({
    required Color backgroundColor,
    required Color selectedItemColor,
  }) {
    return BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
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
