import 'package:flutter/material.dart';

import '../../config/app_router.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

extension BuildContextExtensions on BuildContext {
  // Navigation Extensions
  NavigatorState get navigator => Navigator.of(this);

  // Auth Navigation
  Future<void> navigateToSplash() async {
    await navigator.pushNamedAndRemoveUntil(AppRoutes.splash, (route) => false);
  }

  Future<void> navigateToLogin() async {
    await navigator.pushReplacementNamed(AppRoutes.login);
  }

  Future<void> navigateToSignup() async {
    await navigator.pushNamed(AppRoutes.signup);
  }

  Future<void> navigateToForgotPassword() async {
    await navigator.pushNamed(AppRoutes.forgotPassword);
  }

  // Main App Navigation (for bottom navigation tabs)
  Future<void> navigateToHome() async {
    await navigator.pushReplacementNamed(AppRoutes.home);
  }

  Future<void> navigateToExplore() async {
    await navigator.pushReplacementNamed(AppRoutes.explore);
  }

  Future<void> navigateToBookings() async {
    await navigator.pushReplacementNamed(AppRoutes.bookings);
  }

  Future<void> navigateToProfile() async {
    await navigator.pushReplacementNamed(AppRoutes.profile);
  }

  // Main App Navigation (for initial login/splash)
  Future<void> navigateToHomeInitial() async {
    await navigator.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  // Other Navigation
  Future<void> navigateToEditProfile() async {
    await navigator.pushNamed(AppRoutes.editProfile);
  }

  Future<void> navigateToWishlist() async {
    await navigator.pushNamed(AppRoutes.wishlist);
  }

  Future<void> navigateToNotifications() async {
    await navigator.pushNamed(AppRoutes.notifications);
  }

  Future<void> navigateToSettings() async {
    await navigator.pushNamed(AppRoutes.settings);
  }

  Future<void> navigateToSupport() async {
    await navigator.pushNamed(AppRoutes.support);
  }

  Future<void> navigateToAbout() async {
    await navigator.pushNamed(AppRoutes.about);
  }

  Future<void> navigateToPrivacy() async {
    await navigator.pushNamed(AppRoutes.privacy);
  }

  Future<void> navigateToTerms() async {
    await navigator.pushNamed(AppRoutes.terms);
  }

  // Navigation utilities
  void pop<T>([T? result]) {
    navigator.pop<T>(result);
  }

  Future<bool> maybePop<T>([T? result]) {
    return navigator.maybePop<T>(result);
  }

  bool canPop() {
    return navigator.canPop();
  }

  void popUntil(String routeName) {
    navigator.popUntil(ModalRoute.withName(routeName));
  }

  void popToRoot() {
    navigator.popUntil((route) => route.isFirst);
  }

  // Theme Extensions
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  // Screen Dimensions
  Size get screenSize =>
      MediaQuery
          .of(this)
          .size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  // Safe Area
  EdgeInsets get safeAreaPadding =>
      MediaQuery
          .of(this)
          .padding;

  double get statusBarHeight => safeAreaPadding.top;

  double get bottomPadding => safeAreaPadding.bottom;

  // Responsive Dimensions
  bool get isSmallScreen => screenWidth < 600;

  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  bool get isLargeScreen => screenWidth >= 1200;

  // Device Type Detection
  bool get isMobile => screenWidth < 600;

  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  bool get isDesktop => screenWidth >= 1200;

  // Responsive spacing
  double get responsiveSpacing {
    if (isSmallScreen) return AppConstants.smallSpacing;
    if (isMediumScreen) return AppConstants.mediumSpacing;
    return AppConstants.largeSpacing;
  }

  // Responsive Values Helper
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // App Bar Height
  double get appBarHeight => AppBar().preferredSize.height;

  // Keyboard
  bool get isKeyboardOpen =>
      MediaQuery
          .of(this)
          .viewInsets
          .bottom > 0;

  double get keyboardHeight =>
      MediaQuery
          .of(this)
          .viewInsets
          .bottom;

  // Orientation
  bool get isPortrait =>
      MediaQuery
          .of(this)
          .orientation == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery
          .of(this)
          .orientation == Orientation.landscape;

  // Snackbar Extensions
  void showSnackBar(String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: textColor ?? AppColors.white,
          ),
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? colorScheme.surface,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.mediumSpacing),
      ),
    );
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.success,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  void showErrorSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showWarningSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.warning,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  void showInfoSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.info,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  // Dialog Extensions
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }

  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) {
    return showAppDialog<bool>(
      child: AlertDialog(
        title: Text(title, style: AppTextStyles.headlineSmall),
        content: Text(message, style: AppTextStyles.bodyMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(this).pop(false),
            child: Text(
              cancelText,
              style: AppTextStyles.labelLarge.copyWith(
                color: colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(this).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous
                  ? AppColors.error
                  : (confirmColor ?? colorScheme.primary),
            ),
            child: Text(
              confirmText,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Loading Dialog
  void showLoadingDialog({String message = 'Loading...'}) {
    showAppDialog(
      barrierDismissible: false,
      child: PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppConstants.mediumSpacing),
              Text(
                message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          ),
        ),
      ),
    );
  }

  void hideLoadingDialog() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  // Bottom Sheet Extensions
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            height: height,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.largeRadius),
              ),
            ),
            child: child,
          ),
    );
  }

  // Focus Extensions
  void unfocus() => FocusScope.of(this).unfocus();

  void requestFocus(FocusNode focusNode) =>
      FocusScope.of(this).requestFocus(focusNode);

  // Color Helpers
  Color get primaryColor => colorScheme.primary;

  Color get secondaryColor => colorScheme.secondary;

  Color get errorColor => colorScheme.error;

  Color get surfaceColor => colorScheme.surface;

  Color get backgroundColor => colorScheme.surface;

  // Text Style Helpers
  TextStyle get headlineLarge =>
      textTheme.headlineLarge ?? AppTextStyles.headlineLarge;

  TextStyle get headlineMedium =>
      textTheme.headlineMedium ?? AppTextStyles.headlineMedium;

  TextStyle get headlineSmall =>
      textTheme.headlineSmall ?? AppTextStyles.headlineSmall;

  TextStyle get titleLarge => textTheme.titleLarge ?? AppTextStyles.titleLarge;

  TextStyle get titleMedium =>
      textTheme.titleMedium ?? AppTextStyles.titleMedium;

  TextStyle get titleSmall => textTheme.titleSmall ?? AppTextStyles.titleSmall;

  TextStyle get bodyLarge => textTheme.bodyLarge ?? AppTextStyles.bodyLarge;

  TextStyle get bodyMedium => textTheme.bodyMedium ?? AppTextStyles.bodyMedium;

  TextStyle get bodySmall => textTheme.bodySmall ?? AppTextStyles.bodySmall;

  TextStyle get labelLarge => textTheme.labelLarge ?? AppTextStyles.labelLarge;

  TextStyle get labelMedium =>
      textTheme.labelMedium ?? AppTextStyles.labelMedium;

  TextStyle get labelSmall => textTheme.labelSmall ?? AppTextStyles.labelSmall;

  // Padding Helpers
  EdgeInsets get defaultPadding =>
      const EdgeInsets.all(AppConstants.mediumSpacing);

  EdgeInsets get smallPadding =>
      const EdgeInsets.all(AppConstants.smallSpacing);

  EdgeInsets get largePadding =>
      const EdgeInsets.all(AppConstants.largeSpacing);

  EdgeInsets get horizontalPadding =>
      const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing);

  EdgeInsets get verticalPadding =>
      const EdgeInsets.symmetric(vertical: AppConstants.mediumSpacing);

  // Safe Area Aware Padding
  EdgeInsets get safeAreaAwarePadding =>
      EdgeInsets.only(
        top: statusBarHeight + AppConstants.smallSpacing,
        bottom: bottomPadding + AppConstants.smallSpacing,
        left: AppConstants.mediumSpacing,
        right: AppConstants.mediumSpacing,
      );

  // Animation Duration Helpers
  Duration get fastAnimation => AppConstants.fastAnimationDuration;

  Duration get mediumAnimation => AppConstants.mediumAnimationDuration;

  Duration get slowAnimation => AppConstants.slowAnimationDuration;

  // Locale Extensions
  Locale get locale => Localizations.localeOf(this);

  bool get isRTL => Directionality.of(this) == TextDirection.rtl;

  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  // Quick Access Values
  double get defaultRadius => AppConstants.mediumRadius;

  double get defaultElevation => 2.0;

  // Quick Spacing Widgets
  Widget get smallVerticalSpace =>
      const SizedBox(height: AppConstants.smallSpacing);

  Widget get mediumVerticalSpace =>
      const SizedBox(height: AppConstants.mediumSpacing);

  Widget get largeVerticalSpace =>
      const SizedBox(height: AppConstants.largeSpacing);

  Widget get smallHorizontalSpace =>
      const SizedBox(width: AppConstants.smallSpacing);

  Widget get mediumHorizontalSpace =>
      const SizedBox(width: AppConstants.mediumSpacing);

  Widget get largeHorizontalSpace =>
      const SizedBox(width: AppConstants.largeSpacing);

  // Input Decoration Helper
  InputDecoration getInputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
    );
  }

  // Card Decoration Helper
  BoxDecoration get cardDecoration =>
      BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Gradient Helper
  LinearGradient get primaryGradient =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, primaryColor.withAlpha(204)],
      );
}
