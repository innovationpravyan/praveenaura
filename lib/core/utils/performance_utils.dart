import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceUtils {
  // Debounce utility for search and other frequent operations
  static void debounce(VoidCallback callback, {Duration delay = const Duration(milliseconds: 300)}) {
    _DebounceTimer.cancel();
    _DebounceTimer.start(callback, delay);
  }

  // Throttle utility for scroll events
  static void throttle(VoidCallback callback, {Duration delay = const Duration(milliseconds: 100)}) {
    if (_ThrottleTimer.canExecute()) {
      _ThrottleTimer.start(callback, delay);
    }
  }

  // Memory-efficient image loading
  static double getImageCacheSize() {
    return PaintingBinding.instance.imageCache.currentSizeBytes / 1024 / 1024; // MB
  }

  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  // Widget optimization helpers
  static Widget optimizedListView({
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      cacheExtent: 300, // Optimized cache extent
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
    );
  }

  static Widget optimizedGridView({
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required SliverGridDelegate gridDelegate,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
  }) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      gridDelegate: gridDelegate,
      cacheExtent: 300,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
    );
  }

  // Frame rate monitoring (debug only)
  static void monitorFrameRate() {
    if (kDebugMode) {
      WidgetsBinding.instance.addTimingsCallback((List<dynamic> timings) {
        for (final timing in timings) {
          if (timing.runtimeType.toString().contains('FrameTiming')) {
            // Handle frame timing for performance monitoring
            debugPrint('Frame timing monitored');
          }
        }
      });
    }
  }
}

class _DebounceTimer {
  static Timer? _timer;

  static void start(VoidCallback callback, Duration delay) {
    _timer = Timer(delay, callback);
  }

  static void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

class _ThrottleTimer {
  static DateTime? _lastExecution;

  static bool canExecute() {
    final now = DateTime.now();
    if (_lastExecution == null) return true;
    return now.difference(_lastExecution!).inMilliseconds >= 100;
  }

  static void start(VoidCallback callback, Duration delay) {
    _lastExecution = DateTime.now();
    callback();
  }
}