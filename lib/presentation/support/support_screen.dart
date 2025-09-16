import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/base_screen.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();
  String _selectedCategory = 'General Inquiry';

  final List<String> _categories = [
    'General Inquiry',
    'Account Issues',
    'Booking Problems',
    'Payment Issues',
    'Technical Support',
    'Feature Request',
    'Report a Bug',
    'Privacy Concerns',
    'Other',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Support',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.support_agent,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: context.responsiveSmallSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How can we help?',
                              style: context.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'We\'re here to support you 24/7',
                              style: context.bodyMedium.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: context.responsiveSpacing),

            // Quick contact methods
            _buildQuickContactSection(context),

            SizedBox(height: context.responsiveSpacing),

            // FAQ section
            _buildFAQSection(context),

            SizedBox(height: context.responsiveSpacing),

            // Contact form
            _buildContactForm(context),

            SizedBox(height: context.responsiveLargeSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Contact',
          style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                context,
                'Live Chat',
                'Chat with our support team',
                Icons.chat_bubble_outline,
                () => _startLiveChat(context),
              ),
            ),
            SizedBox(width: context.responsiveSmallSpacing),
            Expanded(
              child: _buildContactCard(
                context,
                'Call Us',
                '+91 9876543210',
                Icons.phone_outlined,
                () => _makePhoneCall(context),
              ),
            ),
          ],
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                context,
                'Email Support',
                'support@aurame.com',
                Icons.email_outlined,
                () => _launchEmail(context),
              ),
            ),
            SizedBox(width: context.responsiveSmallSpacing),
            Expanded(
              child: _buildContactCard(
                context,
                'WhatsApp',
                'Message us directly',
                Icons.message_outlined,
                () => _launchWhatsApp(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: context.responsiveCardPadding,
        decoration: context.professionalCardDecoration,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: context.primaryColor, size: 24),
            ),
            SizedBox(height: context.responsiveSmallSpacing),
            Text(
              title,
              style: context.titleSmall.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I cancel a booking?',
        'answer':
            'You can cancel bookings up to 24 hours before your appointment through the app or by calling the salon directly.',
      },
      {
        'question': 'What payment methods do you accept?',
        'answer':
            'We accept all major credit cards, debit cards, UPI, and digital wallets including Paytm, Google Pay, and PhonePe.',
      },
      {
        'question': 'How do I change my appointment time?',
        'answer':
            'Go to your booking history, select the appointment, and choose "Reschedule". Subject to salon availability.',
      },
      {
        'question': 'What if I\'m not satisfied with the service?',
        'answer':
            'Contact our support team within 24 hours. We\'ll work with the salon to resolve any issues or provide appropriate compensation.',
      },
      {
        'question': 'How do I leave a review?',
        'answer':
            'After your appointment, you\'ll receive a notification to rate and review your experience. You can also do this from your booking history.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Container(
          decoration: context.professionalCardDecoration,
          child: Column(
            children: faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;

              return Column(
                children: [
                  ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.responsiveSpacing,
                          0,
                          context.responsiveSpacing,
                          context.responsiveSpacing,
                        ),
                        child: Text(
                          faq['answer']!,
                          style: context.bodySmall.copyWith(
                            color: context.textMediumEmphasisColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (index < faqs.length - 1) Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        DropdownButton<String>(
          value: _selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
          items: _categories.map<DropdownMenuItem<String>>((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        TextField(
          controller: _subjectController,
          decoration: InputDecoration(
            labelText: 'Subject',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        TextField(
          controller: _messageController,
          decoration: InputDecoration(
            labelText: 'Message',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
      ],
    );
  }

  void _startLiveChat(BuildContext context) {
    // Implement live chat logic here
  }

  void _makePhoneCall(BuildContext context) {
    final url = Uri.parse('tel:+919876543210');
    launch(url.toString());
  }

  void _launchEmail(BuildContext context) {
    final url = Uri.parse('mailto:support@aurame.com');
    launch(url.toString());
  }

  void _launchWhatsApp(BuildContext context) {
    final url = Uri.parse('https://wa.me/919876543210');
    launch(url.toString());
  }

  void _submitForm() {
    // Handle form submission logic
  }
}
