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

  Future<void> navigateToBookingHistory() async {
    await navigator.pushNamed(AppRoutes.bookingHistory);
  }

  Future<void> navigateToProfile() async {
    await navigator.pushReplacementNamed(AppRoutes.profile);
  }

  // Main App Navigation (for initial login/splash)
  Future<void> navigateToHomeInitial() async {
    await navigator.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  // Payment & Booking Navigation
  Future<void> navigateToPaymentCheckout({
    Map<String, dynamic>? bookingData,
  }) async {
    await navigator.pushNamed(
      AppRoutes.paymentCheckout,
      arguments: {'bookingData': bookingData},
    );
  }

  Future<void> navigateToBookingFlow({
    String? salonId,
    String? serviceId,
  }) async {
    await navigator.pushNamed(
      AppRoutes.bookingFlow,
      arguments: {'salonId': salonId, 'serviceId': serviceId},
    );
  }

  Future<void> navigateToSalonDetail(String salonId) async {
    await navigator.pushNamed(AppRoutes.salonDetail, arguments: salonId);
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

  // Dark Mode Detection
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Screen Dimensions
  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  // Sizer-like Width Percentage Extension (w)
  double get _baseWidth => screenWidth / 100;

  // Sizer-like Height Percentage Extension (h)
  double get _baseHeight => screenHeight / 100;

  // Safe Area
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  double get statusBarHeight => safeAreaPadding.top;

  double get bottomPadding => safeAreaPadding.bottom;

  // Advanced Responsive Dimensions
  bool get isSmallMobile => screenWidth < 375;

  bool get isMobile => screenWidth < 768;

  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;

  bool get isDesktop => screenWidth >= 1024;

  bool get isLargeDesktop => screenWidth >= 1440;

  bool get isUltraWide => screenWidth >= 1920;

  // Enhanced Device Detection
  bool get isPortraitMobile => isMobile && isPortrait;

  bool get isLandscapeMobile => isMobile && isLandscape;

  bool get isCompactDevice => screenWidth < 360 || screenHeight < 640;

  // App Bar Height
  double get appBarHeight => AppBar().preferredSize.height;

  // Keyboard
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  // Orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  // Professional Responsive Values Helper
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? smallMobile,
    T? largeDesktop,
    T? ultraWide,
  }) {
    if (isUltraWide && ultraWide != null) return ultraWide;
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    if (isSmallMobile && smallMobile != null) return smallMobile;
    return mobile;
  }

  // Sizer-like Responsive Spacing with percentage-based calculations
  double get responsiveSpacing => responsive<double>(
    mobile: 4.0 * _baseWidth,
    // ~16px on mobile
    tablet: 3.5 * _baseWidth,
    // ~20px on tablet
    desktop: 2.0 * _baseWidth,
    // ~24px on desktop
    smallMobile: 4.5 * _baseWidth,
    // ~12px on small mobile
    largeDesktop: 1.8 * _baseWidth, // ~28px on large desktop
  );

  double get responsiveSmallSpacing => responsive<double>(
    mobile: 2.0 * _baseWidth,
    // ~8px on mobile
    tablet: 1.8 * _baseWidth,
    // ~10px on tablet
    desktop: 1.0 * _baseWidth,
    // ~12px on desktop
    smallMobile: 2.5 * _baseWidth,
    // ~6px on small mobile
    largeDesktop: 1.0 * _baseWidth, // ~16px on large desktop
  );

  double get responsiveLargeSpacing => responsive<double>(
    mobile: 6.0 * _baseWidth,
    // ~24px on mobile
    tablet: 5.5 * _baseWidth,
    // ~32px on tablet
    desktop: 3.0 * _baseWidth,
    // ~40px on desktop
    smallMobile: 7.0 * _baseWidth,
    // ~20px on small mobile
    largeDesktop: 2.5 * _baseWidth, // ~48px on large desktop
  );

  double get responsiveExtraLargeSpacing => responsive<double>(
    mobile: 8.0 * _baseWidth,
    // ~32px on mobile
    tablet: 7.0 * _baseWidth,
    // ~48px on tablet
    desktop: 4.0 * _baseWidth,
    // ~64px on desktop
    smallMobile: 9.0 * _baseWidth,
    // ~24px on small mobile
    largeDesktop: 3.5 * _baseWidth, // ~72px on large desktop
  );

  // Sizer-like Responsive Padding
  EdgeInsets get responsivePadding => EdgeInsets.symmetric(
    horizontal: responsive<double>(
      mobile: 4.0 * _baseWidth,
      // ~16px
      tablet: 3.5 * _baseWidth,
      // ~24px
      desktop: 2.5 * _baseWidth,
      // ~32px
      smallMobile: 4.5 * _baseWidth,
      // ~12px
      largeDesktop: 2.0 * _baseWidth, // ~40px
    ),
    vertical: responsive<double>(
      mobile: 2.0 * _baseHeight,
      // ~16px
      tablet: 1.8 * _baseHeight,
      // ~20px
      desktop: 1.5 * _baseHeight,
      // ~24px
      smallMobile: 2.2 * _baseHeight,
      // ~12px
      largeDesktop: 1.3 * _baseHeight, // ~28px
    ),
  );

  EdgeInsets get responsiveHorizontalPadding => EdgeInsets.symmetric(
    horizontal: responsive<double>(
      mobile: 4.0 * _baseWidth,
      // ~16px
      tablet: 3.5 * _baseWidth,
      // ~24px
      desktop: 2.5 * _baseWidth,
      // ~32px
      smallMobile: 4.5 * _baseWidth,
      // ~12px
      largeDesktop: 2.0 * _baseWidth, // ~40px
    ),
  );

  EdgeInsets get responsiveVerticalPadding => EdgeInsets.symmetric(
    vertical: responsive<double>(
      mobile: 2.0 * _baseHeight,
      // ~16px
      tablet: 1.8 * _baseHeight,
      // ~20px
      desktop: 1.5 * _baseHeight,
      // ~24px
      smallMobile: 2.2 * _baseHeight,
      // ~12px
      largeDesktop: 1.3 * _baseHeight, // ~28px
    ),
  );

  EdgeInsets get responsiveCardPadding => EdgeInsets.all(
    responsive<double>(
      mobile: 4.0 * _baseWidth,
      // ~16px
      tablet: 3.5 * _baseWidth,
      // ~20px
      desktop: 2.5 * _baseWidth,
      // ~24px
      smallMobile: 4.5 * _baseWidth,
      // ~12px
      largeDesktop: 2.0 * _baseWidth, // ~28px
    ),
  );

  EdgeInsets get responsiveContentPadding => EdgeInsets.symmetric(
    horizontal: responsive<double>(
      mobile: 5.0 * _baseWidth,
      // ~20px
      tablet: 4.5 * _baseWidth,
      // ~32px
      desktop: 3.5 * _baseWidth,
      // ~48px
      smallMobile: 6.0 * _baseWidth,
      // ~16px
      largeDesktop: 3.0 * _baseWidth, // ~64px
    ),
    vertical: responsive<double>(
      mobile: 2.0 * _baseHeight,
      // ~16px
      tablet: 1.8 * _baseHeight,
      // ~24px
      desktop: 1.5 * _baseHeight,
      // ~32px
      smallMobile: 2.2 * _baseHeight,
      // ~12px
      largeDesktop: 1.3 * _baseHeight, // ~40px
    ),
  );

  // Sizer-like Responsive Border Radius
  BorderRadius get responsiveBorderRadius => BorderRadius.circular(
    responsive<double>(
      mobile: 3.0 * _baseWidth,
      // ~12px
      tablet: 2.8 * _baseWidth,
      // ~16px
      desktop: 1.8 * _baseWidth,
      // ~20px
      smallMobile: 3.5 * _baseWidth,
      // ~10px
      largeDesktop: 1.5 * _baseWidth, // ~24px
    ),
  );

  BorderRadius get responsiveSmallBorderRadius => BorderRadius.circular(
    responsive<double>(
      mobile: 2.0 * _baseWidth,
      // ~8px
      tablet: 1.8 * _baseWidth,
      // ~10px
      desktop: 1.2 * _baseWidth,
      // ~12px
      smallMobile: 2.5 * _baseWidth,
      // ~6px
      largeDesktop: 1.0 * _baseWidth, // ~16px
    ),
  );

  BorderRadius get responsiveLargeBorderRadius => BorderRadius.circular(
    responsive<double>(
      mobile: 5.0 * _baseWidth,
      // ~20px
      tablet: 4.0 * _baseWidth,
      // ~24px
      desktop: 2.5 * _baseWidth,
      // ~28px
      smallMobile: 6.0 * _baseWidth,
      // ~16px
      largeDesktop: 2.0 * _baseWidth, // ~32px
    ),
  );

  // Sizer-like Responsive Icon Sizes
  double get responsiveIconSize => responsive<double>(
    mobile: 6.0 * _baseWidth,
    // ~24px
    tablet: 4.5 * _baseWidth,
    // ~28px
    desktop: 2.5 * _baseWidth,
    // ~32px
    smallMobile: 7.0 * _baseWidth,
    // ~20px
    largeDesktop: 2.2 * _baseWidth, // ~36px
  );

  double get responsiveSmallIconSize => responsive<double>(
    mobile: 4.0 * _baseWidth,
    // ~16px
    tablet: 3.0 * _baseWidth,
    // ~18px
    desktop: 1.8 * _baseWidth,
    // ~20px
    smallMobile: 5.0 * _baseWidth,
    // ~14px
    largeDesktop: 1.5 * _baseWidth, // ~24px
  );

  double get responsiveLargeIconSize => responsive<double>(
    mobile: 8.0 * _baseWidth,
    // ~32px
    tablet: 6.0 * _baseWidth,
    // ~40px
    desktop: 3.5 * _baseWidth,
    // ~48px
    smallMobile: 9.0 * _baseWidth,
    // ~28px
    largeDesktop: 3.0 * _baseWidth, // ~56px
  );

  // Sizer-like Responsive Elevation
  double get responsiveElevation => responsive<double>(
    mobile: 2.0,
    tablet: 3.0,
    desktop: 4.0,
    smallMobile: 1.0,
    largeDesktop: 6.0,
  );

  double get responsiveCardElevation => responsive<double>(
    mobile: 4.0,
    tablet: 6.0,
    desktop: 8.0,
    smallMobile: 2.0,
    largeDesktop: 12.0,
  );

  // Grid and Layout Helpers
  int get responsiveGridCrossAxisCount => responsive<int>(
    mobile: 2,
    tablet: 3,
    desktop: 4,
    smallMobile: 1,
    largeDesktop: 5,
    ultraWide: 6,
  );

  int getResponsiveGridColumns({
    int mobile = 2,
    int? tablet,
    int? desktop,
    int? smallMobile,
    int? largeDesktop,
    int? ultraWide,
  }) => responsive<int>(
    mobile: mobile,
    tablet: tablet ?? mobile + 1,
    desktop: desktop ?? mobile + 2,
    smallMobile: smallMobile ?? (mobile > 1 ? mobile - 1 : 1),
    largeDesktop: largeDesktop ?? mobile + 3,
    ultraWide: ultraWide ?? mobile + 4,
  );

  double get responsiveCardAspectRatio => responsive<double>(
    mobile: 1.0,
    tablet: 1.1,
    desktop: 1.2,
    smallMobile: 0.9,
    largeDesktop: 1.3,
  );

  double get responsiveListTileHeight => responsive<double>(
    mobile: 9.0 * _baseHeight,
    // ~72px
    tablet: 7.5 * _baseHeight,
    // ~80px
    desktop: 6.0 * _baseHeight,
    // ~88px
    smallMobile: 10.0 * _baseHeight,
    // ~64px
    largeDesktop: 5.5 * _baseHeight, // ~96px
  );

  // Max Content Width
  double get responsiveMaxContentWidth => responsive<double>(
    mobile: double.infinity,
    tablet: 600.0,
    desktop: 800.0,
    largeDesktop: 1000.0,
    ultraWide: 1200.0,
  );

  // Sizer-like Responsive Typography Scale
  double getResponsiveFontSize(double baseFontSize) {
    final scaleFactor = responsive<double>(
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
      smallMobile: 0.9,
      largeDesktop: 1.3,
    );
    return baseFontSize * scaleFactor;
  }

  double getResponsiveLineHeight(double baseLineHeight) => responsive<double>(
    mobile: baseLineHeight,
    tablet: baseLineHeight * 1.05,
    desktop: baseLineHeight * 1.1,
    smallMobile: baseLineHeight * 0.95,
    largeDesktop: baseLineHeight * 1.15,
  );

  double getResponsiveLetterSpacing(double baseLetterSpacing) =>
      responsive<double>(
        mobile: baseLetterSpacing,
        tablet: baseLetterSpacing * 1.1,
        desktop: baseLetterSpacing * 1.2,
        smallMobile: baseLetterSpacing * 0.9,
        largeDesktop: baseLetterSpacing * 1.3,
      );

  // Professional Layout Constraints
  BoxConstraints get responsiveConstraints => BoxConstraints(
    maxWidth: responsiveMaxContentWidth,
    maxHeight: double.infinity,
  );

  BoxConstraints getResponsiveConstraints({
    double? maxWidth,
    double? maxHeight,
    double? minWidth,
    double? minHeight,
  }) => BoxConstraints(
    maxWidth: maxWidth ?? responsiveMaxContentWidth,
    maxHeight: maxHeight ?? double.infinity,
    minWidth: minWidth ?? 0.0,
    minHeight: minHeight ?? 0.0,
  );

  // Beauty App Specific Responsive Values using sizer-like calculations
  double get responsiveServiceCardHeight => responsive<double>(
    mobile: 15.0 * _baseHeight,
    // ~120px
    tablet: 13.0 * _baseHeight,
    // ~140px
    desktop: 11.0 * _baseHeight,
    // ~160px
    smallMobile: 17.0 * _baseHeight,
    // ~100px
    largeDesktop: 10.0 * _baseHeight, // ~180px
  );

  double get responsiveProfileImageSize => responsive<double>(
    mobile: 20.0 * _baseWidth,
    // ~80px
    tablet: 15.0 * _baseWidth,
    // ~100px
    desktop: 8.5 * _baseWidth,
    // ~120px
    smallMobile: 25.0 * _baseWidth,
    // ~64px
    largeDesktop: 7.0 * _baseWidth, // ~140px
  );

  double get responsiveBottomNavigationHeight => responsive<double>(
    mobile: 7.5 * _baseHeight, // ~60px
    tablet: 6.5 * _baseHeight, // ~70px
    desktop: 5.5 * _baseHeight, // ~80px
    smallMobile: 8.5 * _baseHeight, // ~56px
  );

  // Snackbar Extensions
  void showSnackBar(
    String message, {
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
          style: AppTextStyles.bodyMedium(
            color: textColor ?? AppColors.white,
            isDark: isDarkMode,
          ),
        ),
        duration: duration,
        backgroundColor:
            backgroundColor ??
            AppColors.getTextHighEmphasisColor(isDark: isDarkMode),
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: responsiveSmallBorderRadius,
        ),
        margin: EdgeInsets.all(responsiveSmallSpacing),
      ),
    );
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.getSuccessColor(isDark: isDarkMode),
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  void showErrorSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.getErrorColor(isDark: isDarkMode),
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showWarningSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.getWarningColor(isDark: isDarkMode),
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  void showInfoSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.getInfoColor(isDark: isDarkMode),
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
        title: Text(
          title,
          style: AppTextStyles.headlineSmall(isDark: isDarkMode),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium(isDark: isDarkMode),
        ),
        shape: RoundedRectangleBorder(borderRadius: responsiveBorderRadius),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(this).pop(false),
            child: Text(
              cancelText,
              style: AppTextStyles.labelLarge(
                color: AppColors.getTextMediumEmphasisColor(isDark: isDarkMode),
                isDark: isDarkMode,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(this).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous
                  ? AppColors.getErrorColor(isDark: isDarkMode)
                  : (confirmColor ?? colorScheme.primary),
            ),
            child: Text(
              confirmText,
              style: AppTextStyles.labelLarge(color: AppColors.white),
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
              CircularProgressIndicator(color: colorScheme.primary),
              SizedBox(height: responsiveSpacing),
              Text(
                message,
                style: AppTextStyles.bodyMedium(isDark: isDarkMode),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: responsiveBorderRadius),
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
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.getSurfaceColor(isDark: isDarkMode),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(responsiveLargeSpacing),
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

  // Color Helpers with theme awareness
  Color get primaryColor => colorScheme.primary;

  Color get secondaryColor => colorScheme.secondary;

  Color get errorColor => colorScheme.error;

  Color get surfaceColor => colorScheme.surface;

  Color get backgroundColor => AppColors.getBackgroundColor(isDark: isDarkMode);

  Color get textHighEmphasisColor =>
      AppColors.getTextHighEmphasisColor(isDark: isDarkMode);

  Color get textMediumEmphasisColor =>
      AppColors.getTextMediumEmphasisColor(isDark: isDarkMode);

  Color get textDisabledColor =>
      AppColors.getTextDisabledColor(isDark: isDarkMode);

  Color get dividerColor => AppColors.getDividerColor(isDark: isDarkMode);

  Color get shadowColor => AppColors.getShadowColor(isDark: isDarkMode);

  // Text Style Helpers with theme awareness
  TextStyle get headlineLarge =>
      AppTextStyles.headlineLarge(isDark: isDarkMode);

  TextStyle get headlineMedium =>
      AppTextStyles.headlineMedium(isDark: isDarkMode);

  TextStyle get headlineSmall =>
      AppTextStyles.headlineSmall(isDark: isDarkMode);

  TextStyle get titleLarge => AppTextStyles.titleLarge(isDark: isDarkMode);

  TextStyle get titleMedium => AppTextStyles.titleMedium(isDark: isDarkMode);

  TextStyle get titleSmall => AppTextStyles.titleSmall(isDark: isDarkMode);

  TextStyle get bodyLarge => AppTextStyles.bodyLarge(isDark: isDarkMode);

  TextStyle get bodyMedium => AppTextStyles.bodyMedium(isDark: isDarkMode);

  TextStyle get bodySmall => AppTextStyles.bodySmall(isDark: isDarkMode);

  TextStyle get labelLarge => AppTextStyles.labelLarge(isDark: isDarkMode);

  TextStyle get labelMedium => AppTextStyles.labelMedium(isDark: isDarkMode);

  TextStyle get labelSmall => AppTextStyles.labelSmall(isDark: isDarkMode);

  // Padding Helpers
  EdgeInsets get defaultPadding => EdgeInsets.all(responsiveSpacing);

  EdgeInsets get smallPadding => EdgeInsets.all(responsiveSmallSpacing);

  EdgeInsets get largePadding => EdgeInsets.all(responsiveLargeSpacing);

  EdgeInsets get horizontalPadding => responsiveHorizontalPadding;

  EdgeInsets get verticalPadding => responsiveVerticalPadding;

  // Safe Area Aware Padding
  EdgeInsets get safeAreaAwarePadding => EdgeInsets.only(
    top: statusBarHeight + responsiveSmallSpacing,
    bottom: bottomPadding + responsiveSmallSpacing,
    left: responsiveSpacing,
    right: responsiveSpacing,
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
  double get defaultRadius => responsiveBorderRadius.topLeft.x;

  double get defaultElevation => responsiveElevation;

  // Advanced Spacing Widgets using sizer-like calculations
  Widget get responsiveVerticalSpacing => SizedBox(height: responsiveSpacing);

  Widget get responsiveHorizontalSpacing => SizedBox(width: responsiveSpacing);

  Widget get responsiveSmallVerticalSpacing =>
      SizedBox(height: responsiveSmallSpacing);

  Widget get responsiveSmallHorizontalSpacing =>
      SizedBox(width: responsiveSmallSpacing);

  Widget get responsiveLargeVerticalSpacing =>
      SizedBox(height: responsiveLargeSpacing);

  Widget get responsiveLargeHorizontalSpacing =>
      SizedBox(width: responsiveLargeSpacing);

  Widget get responsiveExtraLargeVerticalSpacing =>
      SizedBox(height: responsiveExtraLargeSpacing);

  Widget get responsiveExtraLargeHorizontalSpacing =>
      SizedBox(width: responsiveExtraLargeSpacing);

  // Professional Layout Helpers
  Widget responsiveLayout({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? smallMobile,
    Widget? largeDesktop,
    Widget? ultraWide,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1920 && ultraWide != null) return ultraWide;
        if (constraints.maxWidth >= 1440 && largeDesktop != null)
          return largeDesktop;
        if (constraints.maxWidth >= 1024 && desktop != null) return desktop;
        if (constraints.maxWidth >= 768 && tablet != null) return tablet;
        if (constraints.maxWidth < 375 && smallMobile != null)
          return smallMobile;
        return mobile;
      },
    );
  }

  // Responsive Grid Builder
  Widget responsiveGrid({
    required List<Widget> children,
    int? mobileColumns,
    int? tabletColumns,
    int? desktopColumns,
    int? smallMobileColumns,
    int? largeDesktopColumns,
    double? spacing,
    double? runSpacing,
    double? childAspectRatio,
    bool shrinkWrap = true,
    ScrollPhysics? physics = const NeverScrollableScrollPhysics(),
  }) {
    final crossAxisCount = responsive<int>(
      mobile: mobileColumns ?? 2,
      tablet: tabletColumns ?? 3,
      desktop: desktopColumns ?? 4,
      smallMobile: smallMobileColumns ?? 1,
      largeDesktop: largeDesktopColumns ?? 5,
      ultraWide: 6,
    );

    final aspectRatio =
        childAspectRatio ??
        responsive<double>(
          mobile: 1.0,
          tablet: 1.1,
          desktop: 1.2,
          smallMobile: 0.9,
          largeDesktop: 1.3,
        );

    final gridSpacing = spacing ?? responsiveSmallSpacing;
    final gridRunSpacing = runSpacing ?? responsiveSmallSpacing;

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridRunSpacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  // Content Width Container
  Widget responsiveContainer({
    required Widget child,
    double? maxWidth,
    EdgeInsets? padding,
    EdgeInsets? margin,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? responsiveMaxContentWidth,
      ),
      padding: padding ?? responsiveContentPadding,
      margin: margin,
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }

  // Professional Card with responsive properties
  Widget responsiveCard({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? elevation,
    BorderRadius? borderRadius,
    Color? color,
    Color? shadowColor,
  }) {
    return Container(
      margin:
          margin ??
          EdgeInsets.symmetric(
            horizontal: responsiveSmallSpacing,
            vertical: responsiveSmallSpacing / 2,
          ),
      child: Card(
        elevation: elevation ?? responsiveCardElevation,
        color: color ?? AppColors.getSurfaceColor(isDark: isDarkMode),
        shadowColor:
            shadowColor ?? AppColors.getShadowColor(isDark: isDarkMode),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? responsiveBorderRadius,
        ),
        child: Container(
          padding: padding ?? responsiveCardPadding,
          child: child,
        ),
      ),
    );
  }

  // Input Decoration Helper with theme awareness
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
      fillColor: AppColors.getSurfaceColor(isDark: isDarkMode),
      border: OutlineInputBorder(
        borderRadius: responsiveBorderRadius,
        borderSide: BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: responsiveBorderRadius,
        borderSide: BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: responsiveBorderRadius,
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: responsiveBorderRadius,
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: responsiveBorderRadius,
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      hintStyle: AppTextStyles.bodyMedium(
        color: textDisabledColor,
        isDark: isDarkMode,
      ),
      labelStyle: AppTextStyles.labelMedium(
        color: textMediumEmphasisColor,
        isDark: isDarkMode,
      ),
      errorStyle: AppTextStyles.error(isDark: isDarkMode),
    );
  }

  // Card Decoration Helper with theme awareness
  BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.getSurfaceColor(isDark: isDarkMode),
    borderRadius: responsiveBorderRadius,
    boxShadow: [
      BoxShadow(color: shadowColor, blurRadius: 4, offset: const Offset(0, 2)),
    ],
  );

  // Gradient Helper with theme awareness
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryColor.withOpacity(0.8)],
  );

  // Gender-aware helpers (requires user context - these would need to be passed from provider)
  Color getPrimaryColorForGender(String gender) {
    return AppColors.getPrimaryColorForGender(gender, isDark: isDarkMode);
  }

  List<Color> getGradientForGender(String gender) {
    return AppColors.getGradientForGender(gender, isDark: isDarkMode);
  }

  // Beauty-specific helpers
  Color getCategoryColor(String category) {
    return AppColors.categoryColors[category] ?? primaryColor;
  }

  Color getBookingStatusColor(String status) {
    return AppColors.bookingStatusColors[status] ?? primaryColor;
  }

  // Professional styling helpers for beauty services
  BoxDecoration get professionalCardDecoration => BoxDecoration(
    color: AppColors.getSurfaceColor(isDark: isDarkMode),
    borderRadius: responsiveBorderRadius,
    boxShadow: [
      BoxShadow(
        color: shadowColor,
        blurRadius: 8,
        offset: const Offset(0, 4),
        spreadRadius: -2,
      ),
    ],
  );

  BoxDecoration get elegantContainerDecoration => BoxDecoration(
    color: AppColors.getSurfaceColor(isDark: isDarkMode),
    borderRadius: responsiveLargeBorderRadius,
    border: Border.all(color: dividerColor.withOpacity(0.2), width: 1),
    boxShadow: [
      BoxShadow(
        color: shadowColor.withOpacity(0.1),
        blurRadius: 12,
        offset: const Offset(0, 6),
        spreadRadius: -4,
      ),
    ],
  );

  // Professional spacing based on content hierarchy
  double get contentSpacing => responsiveSpacing;

  double get sectionSpacing => responsiveLargeSpacing;

  double get componentSpacing => responsiveSmallSpacing;

  double get elementSpacing => responsiveSmallSpacing / 2;

  // Professional layout breakpoints for beauty app
  bool get isCompactLayout => screenWidth < 360;

  bool get isStandardLayout => screenWidth >= 360 && screenWidth < 768;

  bool get isExpandedLayout => screenWidth >= 768 && screenWidth < 1024;

  bool get isWideLayout => screenWidth >= 1024;

  // Beauty app specific responsive helpers using sizer-like calculations
  double get beautyCardWidth => responsive<double>(
    mobile: screenWidth - (responsiveSpacing * 2),
    tablet: (screenWidth - (responsiveSpacing * 3)) / 2,
    desktop: (screenWidth - (responsiveSpacing * 5)) / 3,
    smallMobile: screenWidth - (responsiveSmallSpacing * 2),
  );

  double get beautyImageHeight => responsive<double>(
    mobile: 25.0 * _baseHeight,
    // ~200px
    tablet: 22.0 * _baseHeight,
    // ~240px
    desktop: 18.0 * _baseHeight,
    // ~280px
    smallMobile: 28.0 * _baseHeight,
    // ~160px
    largeDesktop: 16.0 * _baseHeight, // ~320px
  );

  EdgeInsets get beautyPagePadding => responsive<EdgeInsets>(
    mobile: EdgeInsets.symmetric(
      horizontal: 4.0 * _baseWidth,
      vertical: 1.5 * _baseHeight,
    ),
    tablet: EdgeInsets.symmetric(
      horizontal: 3.5 * _baseWidth,
      vertical: 1.5 * _baseHeight,
    ),
    desktop: EdgeInsets.symmetric(
      horizontal: 2.5 * _baseWidth,
      vertical: 1.2 * _baseHeight,
    ),
    smallMobile: EdgeInsets.symmetric(
      horizontal: 4.5 * _baseWidth,
      vertical: 1.8 * _baseHeight,
    ),
    largeDesktop: EdgeInsets.symmetric(
      horizontal: 2.0 * _baseWidth,
      vertical: 1.0 * _baseHeight,
    ),
  );

  // Professional animation durations based on device performance
  Duration get responsiveAnimationDuration => responsive<Duration>(
    mobile: const Duration(milliseconds: 300),
    tablet: const Duration(milliseconds: 250),
    desktop: const Duration(milliseconds: 200),
    smallMobile: const Duration(milliseconds: 350),
  );

  Duration get responsiveFastAnimationDuration => responsive<Duration>(
    mobile: const Duration(milliseconds: 150),
    tablet: const Duration(milliseconds: 120),
    desktop: const Duration(milliseconds: 100),
    smallMobile: const Duration(milliseconds: 200),
  );

  Duration get responsiveSlowAnimationDuration => responsive<Duration>(
    mobile: const Duration(milliseconds: 500),
    tablet: const Duration(milliseconds: 400),
    desktop: const Duration(milliseconds: 300),
    smallMobile: const Duration(milliseconds: 600),
  );

  // Utility Extensions for easier percentage-based calculations (Sizer-like)

  /// Width percentage - similar to sizer's .w
  /// Usage: 50.w (50% of screen width)
  double widthPercent(double percentage) => (screenWidth * percentage) / 100;

  /// Height percentage - similar to sizer's .h
  /// Usage: 25.h (25% of screen height)
  double heightPercent(double percentage) => (screenHeight * percentage) / 100;

  /// Minimum of width and height percentage - similar to sizer's .sp
  /// Usage: 16.sp (responsive font size)
  double responsiveSize(double percentage) {
    final width = widthPercent(percentage);
    final height = heightPercent(percentage);
    return width < height ? width : height;
  }
}

// Extension on num to provide sizer-like functionality
extension ResponsiveSizing on num {
  /// Width percentage extension - similar to sizer
  double w(BuildContext context) => (context.screenWidth * this) / 100;

  /// Height percentage extension - similar to sizer
  double h(BuildContext context) => (context.screenHeight * this) / 100;

  /// Responsive size extension - similar to sizer's sp
  double sp(BuildContext context) {
    final width = w(context);
    final height = h(context);
    return width < height ? width : height;
  }
}

// Professional Responsive Widgets
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? smallMobile;
  final Widget? largeDesktop;
  final Widget? ultraWide;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.smallMobile,
    this.largeDesktop,
    this.ultraWide,
  });

  @override
  Widget build(BuildContext context) {
    return context.responsiveLayout(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      smallMobile: smallMobile,
      largeDesktop: largeDesktop,
      ultraWide: ultraWide,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? smallMobileColumns;
  final int? largeDesktopColumns;
  final double? spacing;
  final double? runSpacing;
  final double? childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.smallMobileColumns,
    this.largeDesktopColumns,
    this.spacing,
    this.runSpacing,
    this.childAspectRatio,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return context.responsiveGrid(
      children: children,
      mobileColumns: mobileColumns,
      tabletColumns: tabletColumns,
      desktopColumns: desktopColumns,
      smallMobileColumns: smallMobileColumns,
      largeDesktopColumns: largeDesktopColumns,
      spacing: spacing,
      runSpacing: runSpacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: shrinkWrap,
      physics: physics,
    );
  }
}
