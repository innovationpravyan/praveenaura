import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Check if user needs authentication
    if (authState.requiresLogin) {
      return _buildLoginRequiredScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Clear wishlist action
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: _buildWishlistContent(),
    );
  }

  Widget _buildLoginRequiredScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_outline, size: 80, color: AppColors.grey400),
              const SizedBox(height: AppConstants.mediumSpacing),
              Text(
                'Login Required',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              Text(
                'Please login to view your saved services and salons',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.largeSpacing),
              ElevatedButton(
                onPressed: () => context.navigateToLogin(),
                child: const Text('Login Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistContent() {
    // Mock data for demonstration
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildWishlistItem(index);
      },
    );
  }

  Widget _buildWishlistItem(int index) {
    final services = [
      'Hair Styling',
      'Facial Treatment',
      'Manicure',
      'Massage',
    ];
    final salons = [
      'Glamour Studio',
      'Beauty Palace',
      'Nail Art Studio',
      'Spa Retreat',
    ];
    final prices = ['₹800', '₹1200', '₹600', '₹2000'];
    final ratings = ['4.8', '4.6', '4.9', '4.7'];

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumSpacing),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Row(
          children: [
            // Service image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Icon(
                _getServiceIcon(services[index]),
                color: AppColors.primaryPink,
                size: 32,
              ),
            ),

            const SizedBox(width: AppConstants.mediumSpacing),

            // Service details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    services[index],
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salons[index],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: AppColors.starColor),
                      const SizedBox(width: 2),
                      Text(
                        ratings[index],
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        prices[index],
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    // Remove from wishlist
                  },
                  icon: const Icon(Icons.favorite, color: AppColors.error),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Book now
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Book', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Hair Styling':
        return Icons.content_cut;
      case 'Facial Treatment':
        return Icons.face;
      case 'Manicure':
        return Icons.back_hand;
      case 'Massage':
        return Icons.spa;
      default:
        return Icons.star;
    }
  }
}
