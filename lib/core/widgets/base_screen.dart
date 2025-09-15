import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/app_router.dart';
import '../extensions/context_extensions.dart';

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

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with WidgetsBindingObserver {
  late int _currentIndex;

  final List<String> _navigationPaths = [
    AppRoutes.home,
    AppRoutes.explore,
    AppRoutes.bookings,
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
        break;
      case AppLifecycleState.paused:
        _log('App Paused');
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
      print('$msg: ${widget.runtimeType}');
    }
  }

  void _onScreenReady() {
    _log('Screen Ready');
  }

  Future<bool> _handleWillPop() async {
    try {
      if (widget.onWillPop != null) {
        return await widget.onWillPop!();
      }
      return true;
    } catch (e) {
      _log('Error in _handleWillPop: $e');
      return true;
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    final routeName = _navigationPaths[index];

    switch (routeName) {
      case AppRoutes.home:
        context.navigateToHome();
        break;
      case AppRoutes.explore:
        context.navigateToExplore();
        break;
      case AppRoutes.bookings:
        context.navigateToBookings();
        break;
      case AppRoutes.profile:
        context.navigateToProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    if (widget.safeArea) {
      child = SafeArea(child: child);
    }

    child = PopScope(
      canPop: widget.onWillPop == null,
      onPopInvoked: (didPop) async {
        if (!didPop && widget.onWillPop != null) {
          final shouldPop = await _handleWillPop();
          if (shouldPop && mounted) {
            context.pop();
          }
        }
      },
      child: child,
    );

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
        title: widget.title != null ? Text(widget.title!) : null,
        actions: widget.actions,
        centerTitle: widget.centerTitle,
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      )
          : null,
      body: child,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar:
      widget.showBottomNavigation ? _buildBottomNavigationBar() : null,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        backgroundColor: context.surfaceColor,
        selectedItemColor: context.primaryColor,
        unselectedItemColor: context.colorScheme.outline,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
