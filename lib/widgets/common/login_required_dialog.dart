import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({
    super.key,
    required this.feature,
    required this.onLoginPressed,
    required this.onSignUpPressed,
  });

  final String feature;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  @override
  Widget build(BuildContext context) {
    final featureInfo = _getFeatureInfo(feature);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: AppColors.pinkGradient),
              ),
              child: Icon(featureInfo.icon, size: 40, color: AppColors.white),
            ),

            const SizedBox(height: AppConstants.mediumSpacing),

            // Title
            Text(
              'Login Required',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),

            const SizedBox(height: AppConstants.smallSpacing),

            // Description
            Text(
              featureInfo.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.largeSpacing),

            // Benefits
            Container(
              padding: const EdgeInsets.all(AppConstants.mediumSpacing),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withAlpha(26),
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Benefits of having an account:',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...featureInfo.benefits.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.primaryPink,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largeSpacing),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSignUpPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryPink),
                      foregroundColor: AppColors.primaryPink,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(width: AppConstants.mediumSpacing),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLoginPressed,
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.smallSpacing),

            // Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continue as Guest',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FeatureInfo _getFeatureInfo(String feature) {
    switch (feature) {
      case 'booking':
      case 'booking_history':
        return FeatureInfo(
          icon: Icons.calendar_month,
          description:
              'Create an account to book services and view your booking history.',
          benefits: [
            'Book beauty services instantly',
            'Track appointment status',
            'View booking history',
            'Receive booking reminders',
          ],
        );
      case 'wishlist':
        return FeatureInfo(
          icon: Icons.favorite,
          description:
              'Save your favorite services and salons to your personal wishlist.',
          benefits: [
            'Save favorite services',
            'Quick access to preferred salons',
            'Personalized recommendations',
            'Never lose your favorites',
          ],
        );
      case 'notifications':
        return FeatureInfo(
          icon: Icons.notifications,
          description:
              'Get personalized notifications about offers, bookings, and updates.',
          benefits: [
            'Exclusive offers & discounts',
            'Appointment reminders',
            'New service notifications',
            'Personalized updates',
          ],
        );
      case 'profile':
        return FeatureInfo(
          icon: Icons.person,
          description:
              'Create your profile to get personalized beauty recommendations.',
          benefits: [
            'Personalized service suggestions',
            'Save preferences & details',
            'Faster checkout process',
            'Track loyalty points',
          ],
        );
      case 'settings':
        return FeatureInfo(
          icon: Icons.settings,
          description: 'Access account settings to customize your experience.',
          benefits: [
            'Customize app preferences',
            'Manage notification settings',
            'Privacy & security controls',
            'Theme customization',
          ],
        );
      default:
        return FeatureInfo(
          icon: Icons.account_circle,
          description:
              'Create an account to unlock all premium features and personalized experience.',
          benefits: [
            'Full access to all features',
            'Personalized recommendations',
            'Exclusive member benefits',
            'Secure & synchronized data',
          ],
        );
    }
  }
}

class FeatureInfo {
  const FeatureInfo({
    required this.icon,
    required this.description,
    required this.benefits,
  });

  final IconData icon;
  final String description;
  final List<String> benefits;
}
