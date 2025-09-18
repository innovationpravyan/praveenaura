import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/extensions/context_extensions.dart';

class ServiceTypeButtonsWidget extends StatelessWidget {
  final VoidCallback onSalonServiceTap;
  final VoidCallback onHomeServiceTap;

  const ServiceTypeButtonsWidget({
    super.key,
    required this.onSalonServiceTap,
    required this.onHomeServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsiveHorizontalPadding,
      child: Row(
        children: [
          Expanded(
            child: _buildServiceButton(
              context,
              'Salon Service',
              'Visit our premium salons',
              'https://images.unsplash.com/photo-1560066984-138dadb4c035?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              onSalonServiceTap,
            ),
          ),
          SizedBox(width: context.responsive<double>(
            mobile: 12,
            tablet: 16,
            desktop: 20,
            smallMobile: 8,
          )),
          Expanded(
            child: _buildServiceButton(
              context,
              'Home Service',
              'Beauty services at your doorstep',
              'https://images.unsplash.com/photo-1562322140-8baeececf3df?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              onHomeServiceTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(
      BuildContext context,
      String title,
      String subtitle,
      String imageUrl,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.responsive<double>(
          mobile: 120,
          tablet: 140,
          desktop: 160,
          smallMobile: 100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.9),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: context.surfaceColor,
                      child: Icon(
                        Icons.image_not_supported,
                        color: context.textMediumEmphasisColor,
                        size: context.responsiveIconSize,
                      ),
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Positioned.fill(
                child: Padding(
                  padding: context.responsivePadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: context.responsive<double>(
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                            smallMobile: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: context.responsiveSmallSpacing / 2),
                      Text(
                        subtitle,
                        style: context.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: context.responsive<double>(
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                            smallMobile: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Hover/Tap Effect
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.white.withOpacity(0.1),
                    highlightColor: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}