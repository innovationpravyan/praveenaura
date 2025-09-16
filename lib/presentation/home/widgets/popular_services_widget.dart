// Fixed PopularServicesWidget - this fixes the overflow error
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class PopularServicesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final Function(Map<String, dynamic>) onServiceTap;

  const PopularServicesWidget({
    super.key,
    required this.services,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: context.responsiveHorizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Services',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: context.getResponsiveFontSize(16),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all services
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

        SizedBox(height: context.responsiveSmallSpacing),

        SizedBox(
          height: context.responsive<double>(
            mobile: 180,
            tablet: 200,
            desktop: 220,
            smallMobile: 160,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: context.responsiveHorizontalPadding,
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(context, service);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    final cardWidth = context.responsive<double>(
      mobile: context.screenWidth * 0.4,
      tablet: context.screenWidth * 0.25,
      desktop: context.screenWidth * 0.2,
      smallMobile: context.screenWidth * 0.45,
    );

    return GestureDetector(
      onTap: () => onServiceTap(service),
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: context.responsiveSmallSpacing),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: context.responsiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: context.shadowColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context, service, cardWidth),
            _buildContentSection(context, service),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    Map<String, dynamic> service,
    double cardWidth,
  ) {
    final imageHeight = context.responsive<double>(
      mobile: 100,
      tablet: 110,
      desktop: 120,
      smallMobile: 90,
    );

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.responsiveBorderRadius.topLeft.x),
            topRight: Radius.circular(
              context.responsiveBorderRadius.topRight.x,
            ),
          ),
          child: Container(
            width: cardWidth,
            height: imageHeight,
            color: context.primaryColor.withOpacity(0.1),
            child: service['image'] != null
                ? Image.network(
                    service['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage(context);
                    },
                  )
                : _buildPlaceholderImage(context),
          ),
        ),

        if (service['isPopular'] as bool? ?? false)
          Positioned(
            top: context.responsiveSmallSpacing / 2,
            left: context.responsiveSmallSpacing / 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveSmallSpacing / 2,
                vertical: context.responsiveSmallSpacing / 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 10,
                  ),
                  SizedBox(width: context.responsiveSmallSpacing / 4),
                  Text(
                    'Popular',
                    style: context.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: context.getResponsiveFontSize(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      color: context.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.spa,
          size: context.responsiveIconSize,
          color: context.primaryColor,
        ),
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    Map<String, dynamic> service,
  ) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(context.responsiveSmallSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service name
            Flexible(
              child: Text(
                service['name'] as String,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: context.getResponsiveFontSize(11),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: context.responsiveSmallSpacing / 2),

            // Rating row
            Row(
              children: [
                Icon(Icons.star, color: const Color(0xFFFFB800), size: 12),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '${service['rating']}',
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: context.getResponsiveFontSize(9),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '(${service['bookingCount']})',
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                      fontSize: context.getResponsiveFontSize(8),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Price and duration row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    service['price'] as String,
                    style: context.bodyMedium.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: context.getResponsiveFontSize(10),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveSmallSpacing / 2,
                    vertical: context.responsiveSmallSpacing / 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${service['duration']}',
                    style: context.labelSmall.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: context.getResponsiveFontSize(7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
