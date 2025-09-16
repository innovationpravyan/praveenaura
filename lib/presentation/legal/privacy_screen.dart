import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/base_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Privacy Policy',
      showBottomNavigation: false,
      child: SingleChildScrollView(
        padding: context.responsiveContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: context.responsiveCardPadding,
              decoration: context.elegantContainerDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: context.primaryColor,
                        size: 28,
                      ),
                      SizedBox(width: context.responsiveSmallSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: context.headlineSmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Last updated: December 2024',
                              style: context.bodySmall.copyWith(
                                color: context.textMediumEmphasisColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.responsiveSmallSpacing),
                  Text(
                    'Your privacy is important to us. This policy explains how we collect, use, and protect your information.',
                    style: context.bodyMedium.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.responsiveSpacing),

            // Privacy sections
            ..._buildPrivacySections(context),

            SizedBox(height: context.responsiveLargeSpacing),

            // Contact support section
            _buildSupportSection(context),

            SizedBox(height: context.responsiveLargeSpacing),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrivacySections(BuildContext context) {
    final sections = [
      {
        'title': 'Information We Collect',
        'icon': Icons.info_outline,
        'content':
            'We collect information you provide during registration, booking services, making payments, and interacting with our platform. This includes:\n\n• Personal details (name, email, phone number)\n• Payment information (processed securely)\n• Booking history and preferences\n• Device information and usage data\n• Location data (with your permission)',
      },
      {
        'title': 'How We Use Your Information',
        'icon': Icons.settings_outlined,
        'content':
            'We use your data to:\n\n• Provide and improve our services\n• Process bookings and payments\n• Send important updates and notifications\n• Personalize your experience\n• Respond to customer support requests\n• Ensure platform security and prevent fraud',
      },
      {
        'title': 'Information Sharing',
        'icon': Icons.share_outlined,
        'content':
            'We do not sell your personal information. We may share limited data with:\n\n• Service providers (salons, spas) for bookings\n• Payment processors for transaction processing\n• Analytics providers to improve our services\n• Law enforcement when legally required\n\nAll third parties are bound by strict confidentiality agreements.',
      },
      {
        'title': 'Data Security',
        'icon': Icons.security_outlined,
        'content':
            'We implement industry-standard security measures:\n\n• Encryption of sensitive data\n• Secure payment processing\n• Regular security audits\n• Access controls and authentication\n• Secure data storage and transmission\n\nHowever, no method of transmission is 100% secure.',
      },
      {
        'title': 'Your Rights',
        'icon': Icons.account_circle_outlined,
        'content':
            'You have the right to:\n\n• Access your personal data\n• Update or correct your information\n• Delete your account and data\n• Object to certain data processing\n• Request data portability\n• Withdraw consent at any time\n\nContact us to exercise these rights.',
      },
      {
        'title': 'Cookies & Tracking',
        'icon': Icons.cookie_outlined,
        'content':
            'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze app usage and performance\n• Provide personalized content\n• Ensure security\n\nYou can manage cookie preferences in your device settings.',
      },
      {
        'title': 'Data Retention',
        'icon': Icons.schedule_outlined,
        'content':
            'We retain your data for as long as:\n\n• Your account remains active\n• Required for providing services\n• Needed for legal compliance\n• Necessary for legitimate business purposes\n\nDeleted data is permanently removed within 30 days.',
      },
      {
        'title': 'Changes to This Policy',
        'icon': Icons.update_outlined,
        'content':
            'We may update this policy from time to time. When we do:\n\n• You\'ll be notified of significant changes\n• The "Last updated" date will be revised\n• Continued use constitutes acceptance\n• You can always find the latest version here',
      },
    ];

    return sections.map((section) {
      return Column(
        children: [
          Container(
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
                        section['icon'] as IconData,
                        color: context.primaryColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: context.responsiveSmallSpacing),
                    Expanded(
                      child: Text(
                        section['title'] as String,
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsiveSmallSpacing),
                Text(
                  section['content'] as String,
                  style: context.bodyMedium.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
        ],
      );
    }).toList();
  }

  Widget _buildSupportSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.responsiveCardPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.primaryColor, context.primaryColor.withOpacity(0.8)],
        ),
        borderRadius: context.responsiveBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent, color: Colors.white, size: 28),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Need Help?',
                style: context.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Have questions about our privacy practices? Our support team is here to help.',
            style: context.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: context.responsiveSpacing),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchEmail(context),
                  icon: const Icon(Icons.email, size: 18),
                  label: const Text('Email Us'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: context.primaryColor,
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.navigateToSupport(),
                  icon: const Icon(Icons.help_outline, size: 18),
                  label: const Text('Support'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'privacy@aurame.com',
      queryParameters: {
        'subject': 'Privacy Policy Question',
        'body': 'Hi, I have a question about your privacy policy...',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar('Could not open email app');
      }
    }
  }
}
