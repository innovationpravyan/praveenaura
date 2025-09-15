// terms_screen.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms & Conditions', style: AppTextStyles.titleLarge),
            const SizedBox(height: AppConstants.mediumSpacing),
            const Text(
              'Last updated: December 2024\n\n'
              '1. Acceptance of Terms\n'
              'By accessing and using the Aurame app, you accept and agree to be bound by the terms and provision of this agreement.\n\n'
              '2. Service Description\n'
              'Aurame is a platform that connects users with beauty service providers including salons, spas, and individual professionals.\n\n'
              '3. User Accounts\n'
              'You must create an account to access certain features. You are responsible for maintaining the confidentiality of your account information.\n\n'
              '4. Booking and Payment\n'
              'All bookings are subject to availability. Payment is processed securely through our payment partners.\n\n'
              '5. Cancellation Policy\n'
              'Cancellations must be made at least 24 hours before the scheduled appointment to avoid charges.\n\n'
              '6. User Conduct\n'
              'You agree to use the service in a lawful manner and not to engage in any activity that could harm the platform or other users.\n\n'
              '7. Limitation of Liability\n'
              'Aurame is not liable for the quality of services provided by third-party service providers.\n\n'
              '8. Contact Information\n'
              'For questions about these terms, contact us at legal@aurame.com',
            ),
            const SizedBox(height: AppConstants.largeSpacing),

            // Support Section
            Text(
              'How can we help you?',
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
                  // TODO: Implement live chat
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
                  // TODO: Implement email action
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
                  // TODO: Implement phone call
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
