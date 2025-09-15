import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: AppTextStyles.titleLarge),
            const SizedBox(height: AppConstants.mediumSpacing),
            const Text(
              'Last updated: December 2024\n\n'
              '1. Introduction\n'
              'Aurame respects your privacy and is committed to protecting your personal data. This policy explains how we collect, use, and share your information.\n\n'
              '2. Information We Collect\n'
              'We collect information you provide during registration, booking, payments, and interactions with our platform. This includes your name, email, phone number, and payment details.\n\n'
              '3. How We Use Your Information\n'
              'We use your data to provide and improve our services, process payments, send updates, and respond to customer support requests.\n\n'
              '4. Sharing of Information\n'
              'We do not sell your personal information. We may share data with service providers to help deliver our services, under strict confidentiality agreements.\n\n'
              '5. Data Security\n'
              'We implement robust security measures to protect your information from unauthorized access, alteration, or disclosure.\n\n'
              '6. Your Rights\n'
              'You have the right to access, update, or delete your personal data. You can also object to certain uses of your data.\n\n'
              '7. Cookies\n'
              'Aurame uses cookies to enhance user experience and analyze traffic. You can control cookie settings in your browser.\n\n'
              '8. Third-Party Links\n'
              'Our app may contain links to other websites. We are not responsible for their privacy practices.\n\n'
              '9. Changes to This Policy\n'
              'We may update this policy from time to time. You will be notified of significant changes.\n\n'
              '10. Contact Us\n'
              'For any questions or concerns regarding this privacy policy, please contact us at privacy@aurame.com.',
            ),
            const SizedBox(height: AppConstants.largeSpacing),

            // Support Section
            Text(
              'Need further assistance?',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),

            Card(
              child: ListTile(
                leading: const Icon(Icons.chat, color: AppColors.primaryPink),
                title: const Text('Live Chat'),
                subtitle: const Text('Chat with our support team'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implement live chat action
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: AppColors.info),
                title: const Text('Email Support'),
                subtitle: const Text('support@aurame.com'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implement email support action
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: AppColors.success),
                title: const Text('Call Us'),
                subtitle: const Text('+91 9876543210'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implement call support action
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  color: AppColors.warning,
                ),
                title: const Text('FAQ'),
                subtitle: const Text('Frequently asked questions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to FAQ screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
