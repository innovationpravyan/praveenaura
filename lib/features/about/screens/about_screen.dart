// about_screen.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: AppColors.pinkGradient),
              ),
              child: const Icon(Icons.spa, size: 50, color: Colors.white),
            ),
            const SizedBox(height: AppConstants.largeSpacing),
            Text(
              AppConstants.appName,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Version ${AppConstants.appVersion}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            Text(
              AppConstants.appDescription,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              '© 2024 Aurame. All rights reserved.',
              style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}
