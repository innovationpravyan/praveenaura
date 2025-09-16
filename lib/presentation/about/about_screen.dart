import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/base_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'About Aurame',
      showBottomNavigation: false,
      child: SingleChildScrollView(
        padding: context.responsiveContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with logo
            Container(
              width: double.infinity,
              padding: context.responsiveCardPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.primaryColor,
                    context.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: context.responsiveBorderRadius,
              ),
              child: Column(
                children: [
                  // App logo/icon
                  Container(
                    width: context.responsiveLargeIconSize * 2,
                    height: context.responsiveLargeIconSize * 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.spa,
                      size: context.responsiveLargeIconSize,
                      color: context.primaryColor,
                    ),
                  ),

                  SizedBox(height: context.responsiveSpacing),

                  Text(
                    'Aurame',
                    style: context.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: context.responsiveSmallSpacing / 2),

                  Text(
                    'Your Beauty & Wellness Companion',
                    style: context.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  SizedBox(height: context.responsiveSmallSpacing),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsiveSpacing,
                      vertical: context.responsiveSmallSpacing / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Version 1.0.0',
                      style: context.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.responsiveSpacing),

            // Mission section
            _buildInfoSection(
              context,
              'Our Mission',
              Icons.favorite_outline,
              'At Aurame, we believe everyone deserves to look and feel their best. We\'re on a mission to make beauty and wellness services accessible, convenient, and personalized for everyone.\n\nOur platform connects you with trusted beauty professionals, salons, and spas in your area, making it easier than ever to book the services you love.',
            ),

            SizedBox(height: context.responsiveSpacing),

            // Features section
            _buildFeaturesSection(context),

            SizedBox(height: context.responsiveSpacing),

            // Team section
            _buildInfoSection(
              context,
              'Our Team',
              Icons.groups_outlined,
              'Aurame is built by a passionate team of developers, designers, and beauty industry experts who understand the importance of self-care and wellness.\n\nWe work tirelessly to ensure our platform provides the best possible experience for both customers and service providers.',
            ),

            SizedBox(height: context.responsiveSpacing),

            // Contact section
            _buildContactSection(context),

            SizedBox(height: context.responsiveSpacing),

            // Social media section
            _buildSocialMediaSection(context),

            SizedBox(height: context.responsiveLargeSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    IconData icon,
    String content,
  ) {
    return Container(
      width: double.infinity,
      padding: context.responsiveCardPadding,
      decoration: context.professionalCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: context.primaryColor, size: 24),
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                title,
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSpacing),
          Text(content, style: context.bodyMedium.copyWith(height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.search_outlined,
        'title': 'Easy Discovery',
        'description': 'Find the best salons and services near you',
      },
      {
        'icon': Icons.calendar_today_outlined,
        'title': 'Instant Booking',
        'description': 'Book appointments with just a few taps',
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Trusted Providers',
        'description': 'All professionals are verified and rated',
      },
      {
        'icon': Icons.favorite_border,
        'title': 'Personalized Experience',
        'description': 'Get recommendations based on your preferences',
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'Secure Payments',
        'description': 'Safe and convenient payment options',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': '24/7 Support',
        'description': 'We\'re always here to help you',
      },
    ];

    return Container(
      width: double.infinity,
      padding: context.responsiveCardPadding,
      decoration: context.professionalCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.star_outline,
                  color: context.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Key Features',
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSpacing),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isMobile ? 2 : 3,
              crossAxisSpacing: context.responsiveSmallSpacing,
              mainAxisSpacing: context.responsiveSmallSpacing,
              childAspectRatio: 1.0,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                padding: EdgeInsets.all(context.responsiveSmallSpacing),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.05),
                  borderRadius: context.responsiveSmallBorderRadius,
                  border: Border.all(
                    color: context.primaryColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: context.primaryColor,
                      size: context.responsiveIconSize,
                    ),
                    SizedBox(height: context.responsiveSmallSpacing / 2),
                    Text(
                      feature['title'] as String,
                      style: context.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsiveSmallSpacing / 4),
                    Text(
                      feature['description'] as String,
                      style: context.bodySmall.copyWith(
                        color: context.textMediumEmphasisColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.responsiveCardPadding,
      decoration: context.professionalCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.contact_support_outlined,
                  color: context.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Contact Us',
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSpacing),
          _buildContactItem(
            context,
            Icons.email_outlined,
            'Email',
            'hello@aurame.com',
            () => _launchEmail('hello@aurame.com', 'Hello from Aurame App'),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          _buildContactItem(
            context,
            Icons.phone_outlined,
            'Phone',
            '+91 9876543210',
            () => _launchPhone('+919876543210'),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          _buildContactItem(
            context,
            Icons.location_on_outlined,
            'Address',
            'Bangalore, Karnataka, India',
            null,
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          _buildContactItem(
            context,
            Icons.language_outlined,
            'Website',
            'www.aurame.com',
            () => _launchUrl('https://www.aurame.com'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.responsiveSmallSpacing),
        decoration: BoxDecoration(
          color: onTap != null
              ? context.primaryColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: context.responsiveSmallBorderRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: context.textMediumEmphasisColor, size: 20),
            SizedBox(width: context.responsiveSmallSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                  Text(
                    value,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: onTap != null
                          ? context.primaryColor
                          : context.textHighEmphasisColor,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: context.textMediumEmphasisColor.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.responsiveCardPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withOpacity(0.1),
            context.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: context.responsiveBorderRadius,
        border: Border.all(color: context.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.share_outlined, color: context.primaryColor, size: 24),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Follow Us',
                style: context.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Stay connected with us on social media for updates, tips, and beauty inspiration.',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSocialButton(
                context,
                'Instagram',
                Icons.camera_alt,
                () => _launchUrl('https://instagram.com/aurame'),
              ),
              _buildSocialButton(
                context,
                'Facebook',
                Icons.facebook,
                () => _launchUrl('https://facebook.com/aurame'),
              ),
              _buildSocialButton(
                context,
                'Twitter',
                Icons.alternate_email,
                () => _launchUrl('https://twitter.com/aurame'),
              ),
              _buildSocialButton(
                context,
                'LinkedIn',
                Icons.business,
                () => _launchUrl('https://linkedin.com/company/aurame'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String platform,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(context.responsiveSmallSpacing),
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: context.responsiveSmallSpacing / 2),
          Text(
            platform,
            style: context.bodySmall.copyWith(
              color: context.textMediumEmphasisColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for launching URLs
  void _launchEmail(String email, String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      debugPrint('Could not launch email: $e');
    }
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUrl(phoneLaunchUri);
    } catch (e) {
      debugPrint('Could not launch phone: $e');
    }
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch URL: $e');
    }
  }
}
