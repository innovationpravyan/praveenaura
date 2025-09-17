import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_router.dart';

/// Base screen widget that provides consistent behavior and UI elements
class BaseScreen extends StatefulWidget {
  const BaseScreen({
    super.key,
    required this.child,
    this.initialIndex = 0,
    this.title,
    this.showAppBar = true,
    this.showBottomNavigation = true,
    this.actions,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.safeArea = true,
    this.onWillPop,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.appBarBackgroundColor,
    this.appBarElevation,
    this.leading,
    this.systemOverlayStyle,
  });

  final Widget child;
  final int initialIndex;
  final String? title;
  final bool showAppBar;
  final bool showBottomNavigation;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool safeArea;
  final Future<bool> Function()? onWillPop;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final Color? appBarBackgroundColor;
  final double? appBarElevation;
  final Widget? leading;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with WidgetsBindingObserver {
  late int _currentIndex;

  final List<String> _navigationPaths = [
    AppRoutes.home,
    AppRoutes.explore,
    AppRoutes.bookingHistory,
    AppRoutes.profile,
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onScreenReady();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _log('App Resumed');
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _log('App Paused');
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        _log('App Detached');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _log(String msg) {
    if (kDebugMode) {
      debugPrint('BaseScreen $msg: ${widget.runtimeType}');
    }
  }

  void _onScreenReady() {
    _log('Screen Ready');
    // Set system UI overlay style based on theme
    if (widget.systemOverlayStyle != null) {
      SystemChrome.setSystemUIOverlayStyle(widget.systemOverlayStyle!);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        context.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      );
    }
  }

  void _handleAppResumed() {
    // Refresh data or perform actions when app is resumed
    _log('Handling app resume');
  }

  void _handleAppPaused() {
    // Save state or perform cleanup when app is paused
    _log('Handling app pause');
  }

  Future<bool> _handleWillPop() async {
    try {
      if (widget.onWillPop != null) {
        return await widget.onWillPop!();
      }

      // Default behavior for main screens - don't pop if it's a main navigation screen
      if (_isMainNavigationScreen()) {
        return false;
      }

      return true;
    } catch (e) {
      _log('Error in _handleWillPop: $e');
      return true;
    }
  }

  bool _isMainNavigationScreen() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return _navigationPaths.contains(currentRoute);
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) {
      // Same tab tapped - scroll to top if possible or refresh
      _handleSameTabTap();
      return;
    }

    // Haptic feedback for navigation
    HapticFeedback.lightImpact();

    setState(() {
      _currentIndex = index;
    });

    final routeName = _navigationPaths[index];

    // Use pushReplacementNamed to replace the current route
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  void _handleSameTabTap() {
    // In a real app, you might want to scroll to top or refresh content
    _log('Same tab tapped - could scroll to top or refresh');
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    if (widget.safeArea) {
      child = SafeArea(
        top: widget.showAppBar ? false : true,
        bottom: widget.showBottomNavigation ? false : true,
        child: child,
      );
    }

    // Use PopScope for proper back button handling
    child = PopScope(
      canPop: widget.onWillPop == null && !_isMainNavigationScreen(),
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _handleWillPop();
          if (shouldPop && mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );

    return Scaffold(
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: child,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.showBottomNavigation
          ? _buildBottomNavigationBar()
          : null,
      backgroundColor: widget.backgroundColor ?? context.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: widget.title != null ? Text(widget.title!) : null,
      actions: widget.actions,
      centerTitle: widget.centerTitle,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      elevation: widget.appBarElevation ?? 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: widget.appBarBackgroundColor ?? context.surfaceColor,
      foregroundColor: context.textHighEmphasisColor,
      leading: widget.leading,
      systemOverlayStyle:
          widget.systemOverlayStyle ??
          (context.isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
      iconTheme: IconThemeData(
        color: context.textHighEmphasisColor,
        size: context.responsiveIconSize,
      ),
      actionsIconTheme: IconThemeData(
        color: context.textHighEmphasisColor,
        size: context.responsiveIconSize,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: context.responsiveElevation * 2,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onBottomNavTap,
            backgroundColor: Colors.transparent,
            selectedItemColor: context.primaryColor,
            unselectedItemColor: context.textMediumEmphasisColor,
            selectedFontSize: context.responsive(
              mobile: 12.0,
              tablet: 13.0,
              desktop: 14.0,
            ),
            unselectedFontSize: context.responsive(
              mobile: 11.0,
              tablet: 12.0,
              desktop: 13.0,
            ),
            elevation: 0,
            selectedLabelStyle: context.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: context.labelSmall,
            iconSize: context.responsiveIconSize,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: 'Home',
                tooltip: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.explore_outlined),
                activeIcon: const Icon(Icons.explore),
                label: 'Explore',
                tooltip: 'Explore Services',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month_outlined),
                activeIcon: const Icon(Icons.calendar_month),
                label: 'Bookings',
                tooltip: 'My Bookings',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: 'Profile',
                tooltip: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
