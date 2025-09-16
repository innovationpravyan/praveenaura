import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/base_screen.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Terms & Conditions',
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
                        Icons.description_outlined,
                        color: context.primaryColor,
                        size: 28,
                      ),
                      SizedBox(width: context.responsiveSmallSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terms & Conditions',
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
                    'Please read these terms carefully before using Aurame. By using our service, you agree to these terms.',
                    style: context.bodyMedium.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.responsiveSpacing),

            // Terms sections
            ..._buildTermsSections(context),

            SizedBox(height: context.responsiveLargeSpacing),

            // Legal support section
            _buildLegalSupportSection(context),

            SizedBox(height: context.responsiveLargeSpacing),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTermsSections(BuildContext context) {
    final sections = [
      {
        'title': 'Acceptance of Terms',
        'icon': Icons.check_circle_outline,
        'content':
            'By accessing and using the Aurame mobile application, you accept and agree to be bound by the terms and provision of this agreement.\n\nIf you do not agree to abide by the above, please do not use this service.',
      },
      {
        'title': 'Service Description',
        'icon': Icons.business_outlined,
        'content':
            'Aurame is a platform that connects users with beauty service providers including:\n\n• Hair salons and barbershops\n• Spas and wellness centers\n• Individual beauty professionals\n• Nail salons and beauty parlors\n\nWe facilitate bookings but do not directly provide beauty services.',
      },
      {
        'title': 'User Accounts',
        'icon': Icons.account_circle_outlined,
        'content':
            'To access certain features, you must create an account:\n\n• Provide accurate and complete information\n• Keep your account information updated\n• Maintain the confidentiality of your password\n• Accept responsibility for all activities under your account\n• Notify us immediately of any unauthorized use',
      },
      {
        'title': 'Booking and Payments',
        'icon': Icons.payment_outlined,
        'content':
            'When booking services through Aurame:\n\n• All bookings are subject to availability\n• Prices are set by service providers\n• Payment is processed securely through our partners\n• You agree to pay all charges incurred\n• Service providers set their own terms for services\n• We may charge platform or convenience fees',
      },
      {
        'title': 'Cancellation Policy',
        'icon': Icons.cancel_outlined,
        'content':
            'Our cancellation policy:\n\n• Cancellations must be made at least 24 hours in advance\n• Late cancellations may incur charges\n• No-shows may be charged the full service amount\n• Refund policies are set by individual service providers\n• Emergency cancellations will be reviewed case-by-case\n• Repeated no-shows may result in account suspension',
      },
      {
        'title': 'User Conduct',
        'icon': Icons.gavel_outlined,
        'content':
            'You agree to use the service lawfully and respectfully:\n\n• Do not harass or abuse service providers or staff\n• Provide honest reviews and feedback\n• Do not attempt to circumvent our booking system\n• Respect appointment times and policies\n• Do not use the platform for illegal activities\n• Follow community guidelines and standards',
      },
      {
        'title': 'Service Provider Responsibilities',
        'icon': Icons.business_center_outlined,
        'content':
            'Service providers on our platform agree to:\n\n• Provide services as described\n• Maintain professional standards\n• Honor confirmed bookings\n• Follow health and safety regulations\n• Respond to customer inquiries promptly\n• Maintain appropriate licensing and certifications',
      },
      {
        'title': 'Limitation of Liability',
        'icon': Icons.warning_amber_outlined,
        'content':
            'Important limitations:\n\n• Aurame is not liable for service quality issues\n• We do not guarantee service provider availability\n• Use the platform at your own risk\n• Our liability is limited to platform-related issues\n• We are not responsible for disputes between users and providers\n• Services are provided by independent third parties',
      },
      {
        'title': 'Intellectual Property',
        'icon': Icons.copyright_outlined,
        'content':
            'Regarding content and trademarks:\n\n• Aurame owns platform content and trademarks\n• Users retain rights to their own content\n• Do not infringe on others\' intellectual property\n• Report any copyright violations to us\n• We may remove infringing content\n• Respect provider photos and content rights',
      },
      {
        'title': 'Termination',
        'icon': Icons.close_outlined,
        'content':
            'Account termination conditions:\n\n• Either party may terminate at any time\n• We may suspend accounts for terms violations\n• Terminated users lose access to platform features\n• Outstanding obligations survive termination\n• We reserve the right to refuse service\n• Appeals process available for account actions',
      },
      {
        'title': 'Changes to Terms',
        'icon': Icons.update_outlined,
        'content':
            'We may update these terms:\n\n• Users will be notified of significant changes\n• Continued use implies acceptance\n• Review terms regularly for updates\n• Contact us with questions about changes\n• Previous versions available upon request',
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

  Widget _buildLegalSupportSection(BuildContext context) {
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
              const Icon(Icons.balance, color: Colors.white, size: 28),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Legal Questions?',
                style: context.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'For questions about these terms or legal matters, contact our legal team.',
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
                  label: const Text('Legal Team'),
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
      path: 'legal@aurame.com',
      queryParameters: {
        'subject': 'Terms & Conditions Question',
        'body': 'Hi, I have a question about your terms and conditions...',
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
