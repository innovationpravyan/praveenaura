import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:aurame/core/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/common/login_required_dialog.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isGuest = authState.isGuest;

    return BaseScreen(
      initialIndex: 1,
      title: 'Explore',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories grid
            Text(
              'Service Categories',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: AppConstants.mediumSpacing,
                mainAxisSpacing: AppConstants.mediumSpacing,
              ),
              itemCount: AppConstants.serviceCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.serviceCategories[index];
                final categoryColor =
                    AppColors.categoryColors[category] ?? AppColors.primaryPink;

                return GestureDetector(
                  onTap: () {
                    if (isGuest) {
                      _showLoginDialog(context, ref, 'booking');
                    } else {
                      // Navigate to category services
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: categoryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(
                        AppConstants.mediumRadius,
                      ),
                      border: Border.all(color: categoryColor.withAlpha(77)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          size: 40,
                          color: categoryColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isGuest) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink.withAlpha(26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Login to book',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primaryPink,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppConstants.largeSpacing),

            // Featured salons
            Text(
              'Popular Salons',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: AppConstants.mediumSpacing,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryPink.withAlpha(26),
                      child: const Icon(
                        Icons.store,
                        color: AppColors.primaryPink,
                      ),
                    ),
                    title: Text('Beauty Salon ${index + 1}'),
                    subtitle: Text('4.${8 - index} ⭐ • 2.${index + 1} km away'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      if (isGuest) {
                        _showLoginDialog(context, ref, 'booking');
                      } else {
                        // Navigate to salon details
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Hair Care':
        return Icons.content_cut;
      case 'Skin Care':
        return Icons.face;
      case 'Nail Art':
        return Icons.back_hand;
      case 'Makeup':
        return Icons.brush;
      case 'Massage':
        return Icons.spa;
      case 'Bridal':
        return Icons.favorite;
      case 'Men\'s Grooming':
        return Icons.face_retouching_natural;
      default:
        return Icons.spa;
    }
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => LoginRequiredDialog(
        feature: feature,
        onLoginPressed: () {
          Navigator.of(dialogContext).pop();
          context.navigateToLogin();
        },
        onSignUpPressed: () {
          Navigator.of(dialogContext).pop();
          context.navigateToSignup();
        },
      ),
    );
  }
}
