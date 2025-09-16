// quick_booking_fab_widget.dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class QuickBookingFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const QuickBookingFabWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: context.primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(Icons.add, color: Colors.white, size: 20),
      label: Text(
        'Quick Book',
        style: context.labelLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: context.getResponsiveFontSize(12),
        ),
      ),
    );
  }
}
