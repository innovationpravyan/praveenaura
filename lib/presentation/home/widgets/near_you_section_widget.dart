// near_you_section_widget.dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import './salon_card_widget.dart';

class NearYouSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> salons;
  final Function(Map<String, dynamic>) onSalonTap;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final Function(Map<String, dynamic>) onShare;
  final Function(Map<String, dynamic>) onGetDirections;

  const NearYouSectionWidget({
    super.key,
    required this.salons,
    required this.onSalonTap,
    required this.onFavoriteToggle,
    required this.onShare,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    if (salons.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveSize(4),
            vertical: context.responsiveSize(2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Near You',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: context.getResponsiveFontSize(14),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all nearby salons
                },
                child: Text(
                  'View All',
                  style: context.bodyMedium.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: context.getResponsiveFontSize(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: context.responsiveSize(2)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.responsive<int>(
              mobile: 2,
              tablet: 3,
              desktop: 4,
              smallMobile: 1,
            ),
            // childAspectRatio: 1, // Wider & shorter cards
            crossAxisSpacing: context.responsiveSize(2),
            mainAxisSpacing: context.responsiveSize(2),
          ),
          itemCount: salons.length > 6 ? 6 : salons.length,
          itemBuilder: (context, index) {
            final salon = salons[index];
            return SalonCardWidget(
              salon: salon,
              onTap: () => onSalonTap(salon),
              onFavoriteToggle: () => onFavoriteToggle(salon),
              onShare: () => onShare(salon),
              onGetDirections: () => onGetDirections(salon),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsiveSize(8)),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            color: context.textMediumEmphasisColor,
            size: 48,
          ),
          SizedBox(height: context.responsiveSize(2)),
          Text(
            'No salons found nearby',
            style: context.titleMedium.copyWith(
              color: context.textMediumEmphasisColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveSize(1)),
          Text(
            'Enable location services to discover beauty salons around you',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveSize(3)),
          ElevatedButton(
            onPressed: () {
              // Handle location permission request
            },
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
  }
}
