// location_header_widget.dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String currentLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const LocationHeaderWidget({
    super.key,
    required this.currentLocation,
    required this.onLocationTap,
    required this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveSize(4),
        vertical: context.responsiveSize(2),
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLocationTap,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: context.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: context.responsiveSize(2)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: context.labelSmall.copyWith(
                            color: context.textMediumEmphasisColor,
                            fontSize: context.getResponsiveFontSize(10),
                          ),
                        ),
                        SizedBox(height: context.responsiveSize(0.5)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentLocation,
                                style: context.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.getResponsiveFontSize(12),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: context.responsiveSize(1)),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: context.textMediumEmphasisColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: context.responsiveSize(3)),
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(context.responsiveSize(2)),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: context.primaryColor,
                    size: 20,
                  ),
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(context.responsiveSize(1)),
                      decoration: BoxDecoration(
                        color: context.errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: context.responsiveSize(4),
                        minHeight: context.responsiveSize(4),
                      ),
                      child: Text(
                        notificationCount > 99
                            ? '99+'
                            : notificationCount.toString(),
                        style: context.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: context.getResponsiveFontSize(8),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
