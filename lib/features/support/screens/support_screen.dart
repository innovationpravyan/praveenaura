// support_screen.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_text_styles.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            const Text(
              'Last updated: December 2024\n\n'
              '1. Information We Collect\n'
              'We collect information you provide directly to us, such as when you create an account, book services, or contact us for support.\n\n'
              '2. How We Use Your Information\n'
              'We use your information to provide, maintain, and improve our services, process transactions, and communicate with you.\n\n'
              '3. Information Sharing\n'
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent.\n\n'
              '4. Data Security\n'
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.\n\n'
              '5. Your Rights\n'
              'You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us.\n\n'
              '6. Contact Us\n'
              'If you have any questions about this Privacy Policy, please contact us at privacy@aurame.com',
            ),
          ],
        ),
      ),
    );
  }
}
