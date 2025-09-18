import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

class OurServicesWidget extends StatelessWidget {
  final Function(String serviceType) onServiceTap;

  const OurServicesWidget({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final allServices = _getAllServices();
    final displayedServices = allServices.take(6).toList();

    return Container(
      padding: context.responsiveHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title with See All button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Services',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: context.getResponsiveFontSize(16),
                ),
              ),
              TextButton(
                onPressed: () => _showAllServicesDialog(context),
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
          SizedBox(height: context.responsiveSpacing),

          // Horizontal scrollable services
          SizedBox(
            height: context.responsive<double>(
              mobile: 100,
              tablet: 120,
              desktop: 140,
              smallMobile: 90,
            ),
            child: ListView.separated(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: displayedServices.length,
              separatorBuilder: (context, index) => SizedBox(
                width: context.responsiveSpacing,
              ),
              itemBuilder: (context, index) {
                final service = displayedServices[index];
                return _buildServiceItem(
                  context,
                  service['icon'] as IconData,
                  service['label'] as String,
                  service['type'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAllServices() {
    return [
      {
        'icon': Icons.cut,
        'label': 'Hair Cut',
        'type': 'haircut',
        'description': 'Professional hair cutting and styling services',
      },
      {
        'icon': Icons.face,
        'label': 'Facial',
        'type': 'facial',
        'description': 'Deep cleansing and rejuvenating facial treatments',
      },
      {
        'icon': Icons.palette,
        'label': 'Makeup',
        'type': 'makeup',
        'description': 'Professional makeup for all occasions',
      },
      {
        'icon': Icons.spa,
        'label': 'Massage',
        'type': 'massage',
        'description': 'Relaxing body and head massage therapy',
      },
      {
        'icon': Icons.brush,
        'label': 'Hair Color',
        'type': 'haircolor',
        'description': 'Hair coloring and highlighting services',
      },
      {
        'icon': Icons.auto_fix_high,
        'label': 'Manicure',
        'type': 'manicure',
        'description': 'Complete nail care and beautification',
      },
      {
        'icon': Icons.self_improvement,
        'label': 'Pedicure',
        'type': 'pedicure',
        'description': 'Foot care and nail grooming services',
      },
      {
        'icon': Icons.medical_services,
        'label': 'Skin Care',
        'type': 'skincare',
        'description': 'Advanced skin treatment and care',
      },
      {
        'icon': Icons.straighten,
        'label': 'Hair Straightening',
        'type': 'straightening',
        'description': 'Hair smoothening and straightening treatments',
      },
      {
        'icon': Icons.waves,
        'label': 'Hair Styling',
        'type': 'styling',
        'description': 'Creative hair styling and curling',
      },
      {
        'icon': Icons.remove_red_eye,
        'label': 'Eyebrow',
        'type': 'eyebrow',
        'description': 'Eyebrow shaping and threading services',
      },
      {
        'icon': Icons.local_florist,
        'label': 'Bridal',
        'type': 'bridal',
        'description': 'Complete bridal makeup and styling',
      },
    ];
  }

  void _showAllServicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: context.responsive<double>(
              mobile: context.screenWidth * 0.9,
              tablet: 400,
              desktop: 450,
            ),
            height: context.responsive<double>(
              mobile: context.screenHeight * 0.7,
              tablet: 600,
              desktop: 650,
            ),
            padding: context.responsivePadding,
            child: Column(
              children: [
                // Dialog header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Services',
                      style: context.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: context.textMediumEmphasisColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsiveSpacing),

                // Services list
                Expanded(
                  child: ListView.separated(
                    itemCount: _getAllServices().length,
                    separatorBuilder: (context, index) => Divider(
                      color: context.dividerColor,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final service = _getAllServices()[index];
                      return _buildServiceListItem(context, service);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceListItem(BuildContext context, Map<String, dynamic> service) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: context.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          service['icon'] as IconData,
          size: 24,
          color: context.primaryColor,
        ),
      ),
      title: Text(
        service['label'] as String,
        style: context.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        service['description'] as String,
        style: context.bodySmall.copyWith(
          color: context.textMediumEmphasisColor,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onServiceTap(service['type'] as String);
      },
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    IconData icon,
    String label,
    String serviceType,
  ) {
    return InkWell(
      onTap: () => onServiceTap(serviceType),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: context.responsive<double>(
          mobile: 80,
          tablet: 90,
          desktop: 100,
          smallMobile: 70,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container with purple background
            Container(
              width: context.responsive<double>(
                mobile: 100,
                tablet: 56,
                desktop: 64,
                smallMobile: 40,
              ),
              height: context.responsive<double>(
                mobile: 60,
                tablet: 56,
                desktop: 64,
                smallMobile: 40,
              ),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: context.responsive<double>(
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                  smallMobile: 20,
                ),
                color: context.primaryColor,
              ),
            ),
            SizedBox(height: context.responsiveSmallSpacing),

            // Service label
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveSmallSpacing / 2,
              ),
              child: Text(
                label,
                style: context.bodySmall.copyWith(
                  fontSize: context.responsive<double>(
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                    smallMobile: 11,
                  ),
                  fontWeight: FontWeight.w500,
                  color: context.textHighEmphasisColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}