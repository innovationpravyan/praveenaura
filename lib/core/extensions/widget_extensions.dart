import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  // Add padding
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  // Add margin (using Container)
  Widget marginAll(double margin) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }

  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  // Center widget
  Widget get centered => Center(child: this);

  // Align widget
  Widget align(AlignmentGeometry alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  // Expanded widget
  Widget get expanded => Expanded(child: this);

  Widget expandedFlex(int flex) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  // Flexible widget
  Widget get flexible => Flexible(child: this);

  Widget flexibleFlex(int flex) {
    return Flexible(
      flex: flex,
      child: this,
    );
  }

  // Positioned widget
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  // SizedBox wrapper
  Widget sized({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  // Container wrapper
  Widget container({
    double? width,
    double? height,
    Color? color,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    BoxConstraints? constraints,
  }) {
    return Container(
      width: width,
      height: height,
      color: color,
      decoration: decoration,
      padding: padding,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      child: this,
    );
  }

  // Card wrapper
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      child: this,
    );
  }

  // ClipRRect wrapper
  Widget clipRRect({required BorderRadius borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: this,
    );
  }

  // ClipOval wrapper
  Widget get clipOval => ClipOval(child: this);

  // Opacity wrapper
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  // Transform wrapper
  Widget transform({required Matrix4 transform}) {
    return Transform(
      transform: transform,
      child: this,
    );
  }

  // Scale wrapper
  Widget scale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }

  // Rotate wrapper
  Widget rotate(double angle) {
    return Transform.rotate(
      angle: angle,
      child: this,
    );
  }

  // Hero wrapper
  Widget hero(Object tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }

  // SafeArea wrapper
  Widget get safeArea => SafeArea(child: this);

  Widget safeAreaOnly({
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
  }) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }

  // SingleChildScrollView wrapper
  Widget get scrollable => SingleChildScrollView(child: this);

  Widget scrollableAxis(Axis scrollDirection) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      child: this,
    );
  }

  // GestureDetector wrapper
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  Widget gesture({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    Function(TapDownDetails)? onTapDown,
    Function(TapUpDetails)? onTapUp,
    VoidCallback? onTapCancel,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: this,
    );
  }

  // InkWell wrapper
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      splashColor: splashColor,
      highlightColor: highlightColor,
      borderRadius: borderRadius,
      child: this,
    );
  }

  // Material wrapper
  Widget material({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    BorderRadius? borderRadius,
    MaterialType type = MaterialType.canvas,
  }) {
    return Material(
      color: color,
      elevation: elevation ?? 0,
      shape: shape,
      borderRadius: borderRadius,
      type: type,
      child: this,
    );
  }

  // AnimatedContainer wrapper
  Widget animatedContainer({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double? width,
    double? height,
    Color? color,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: width,
      height: height,
      color: color,
      decoration: decoration,
      padding: padding,
      margin: margin,
      alignment: alignment,
      child: this,
    );
  }

  // FadeInAnimation wrapper
  Widget fadeIn({
    Duration duration = const Duration(milliseconds: 300),
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: this,
    );
  }

  // SlideIn animation wrapper
  Widget slideIn({
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: begin, end: end),
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: this,
    );
  }

  // Visibility wrapper
  Widget visible(bool visible) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  Widget visibleMaintainSize(bool visible) {
    return Visibility(
      visible: visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: this,
    );
  }

  // Tooltip wrapper
  Widget tooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }

  // FittedBox wrapper
  Widget fitted({BoxFit fit = BoxFit.contain}) {
    return FittedBox(
      fit: fit,
      child: this,
    );
  }

  // IgnorePointer wrapper
  Widget get ignorePointer => IgnorePointer(child: this);

  Widget ignorePointerConditional(bool ignore) {
    return IgnorePointer(
      ignoring: ignore,
      child: this,
    );
  }

  // AbsorbPointer wrapper
  Widget get absorbPointer => AbsorbPointer(child: this);

  Widget absorbPointerConditional(bool absorb) {
    return AbsorbPointer(
      absorbing: absorb,
      child: this,
    );
  }

  // Shimmer effect (placeholder)
  Widget get shimmer {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
        ),
      ),
      child: this,
    );
  }

  // Conditional wrapper
  Widget conditional(bool condition, Widget Function(Widget child) wrapper) {
    return condition ? wrapper(this) : this;
  }

  // If-else widget wrapper
  Widget ifElse(bool condition, Widget Function(Widget child) trueWrapper, Widget Function(Widget child) falseWrapper) {
    return condition ? trueWrapper(this) : falseWrapper(this);
  }
}

// Spacing widgets
class VSpace extends StatelessWidget {
  final double height;

  const VSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class HSpace extends StatelessWidget {
  final double width;

  const HSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

// Common spacing values
class Spacing {
  static const VSpace xs = VSpace(4);
  static const VSpace sm = VSpace(8);
  static const VSpace md = VSpace(16);
  static const VSpace lg = VSpace(24);
  static const VSpace xl = VSpace(32);

  static const HSpace xsH = HSpace(4);
  static const HSpace smH = HSpace(8);
  static const HSpace mdH = HSpace(16);
  static const HSpace lgH = HSpace(24);
  static const HSpace xlH = HSpace(32);
}

// Extension for List<Widget> to add spacing
extension WidgetListExtensions on List<Widget> {
  // Add vertical spacing between widgets
  List<Widget> addVerticalSpacing(double spacing) {
    if (isEmpty) return this;

    final List<Widget> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(VSpace(spacing));
      }
    }
    return result;
  }

  // Add horizontal spacing between widgets
  List<Widget> addHorizontalSpacing(double spacing) {
    if (isEmpty) return this;

    final List<Widget> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(HSpace(spacing));
      }
    }
    return result;
  }

  // Wrap in Column with spacing
  Widget column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 0,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacing > 0 ? addVerticalSpacing(spacing) : this,
    );
  }

  // Wrap in Row with spacing
  Widget row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 0,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacing > 0 ? addHorizontalSpacing(spacing) : this,
    );
  }

  // Wrap in Wrap widget
  Widget wrap({
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
  }) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      children: this,
    );
  }
}