import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/base_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return BaseScreen(
      title: 'Wishlist',
      showBottomNavigation: false,
      actions: authState.requiresLogin
          ? null
          : [
              IconButton(
                onPressed: () => _showClearWishlistDialog(context),
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear wishlist',
              ),
            ],
      child: authState.requiresLogin
          ? _buildLoginRequiredContent(context)
          : _buildWishlistContent(context),
    );
  }

  Widget _buildLoginRequiredContent(BuildContext context) {
    return Center(
      child: context.responsiveContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: context.responsiveLargeIconSize,
              color: context.textDisabledColor,
            ),
            context.responsiveVerticalSpacing,
            Text(
              'Login Required',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            context.responsiveSmallVerticalSpacing,
            Text(
              'Please login to view your saved services and salons',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              textAlign: TextAlign.center,
            ),
            context.responsiveLargeVerticalSpacing,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.navigateToLogin(),
                child: const Text('Login Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context) {
    // Mock data for demonstration
    final wishlistItems = [
      {
        'service': 'Hair Styling',
        'salon': 'Glamour Studio',
        'price': '₹800',
        'rating': '4.8',
        'duration': '45 min',
        'category': 'Hair Care',
      },
      {
        'service': 'Facial Treatment',
        'salon': 'Beauty Palace',
        'price': '₹1200',
        'rating': '4.6',
        'duration': '60 min',
        'category': 'Skin Care',
      },
      {
        'service': 'Manicure',
        'salon': 'Nail Art Studio',
        'price': '₹600',
        'rating': '4.9',
        'duration': '30 min',
        'category': 'Nail Art',
      },
      {
        'service': 'Massage',
        'salon': 'Spa Retreat',
        'price': '₹2000',
        'rating': '4.7',
        'duration': '90 min',
        'category': 'Massage',
      },
    ];

    if (wishlistItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: context.responsiveLargeIconSize,
              color: context.textDisabledColor,
            ),
            context.responsiveVerticalSpacing,
            Text(
              'Your Wishlist is Empty',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            context.responsiveSmallVerticalSpacing,
            Text(
              'Save your favorite services and salons to book them later',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              textAlign: TextAlign.center,
            ),
            context.responsiveLargeVerticalSpacing,
            ElevatedButton(
              onPressed: () => context.navigateToExplore(),
              child: const Text('Explore Services'),
            ),
          ],
        ),
      );
    }

    return context.responsiveLayout(
      mobile: _buildMobileWishlist(context, wishlistItems),
      tablet: _buildTabletWishlist(context, wishlistItems),
      desktop: _buildDesktopWishlist(context, wishlistItems),
    );
  }

  Widget _buildMobileWishlist(
    BuildContext context,
    List<Map<String, String>> items,
  ) {
    return ListView.builder(
      padding: context.responsiveContentPadding,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildWishlistCard(context, items[index]);
      },
    );
  }

  Widget _buildTabletWishlist(
    BuildContext context,
    List<Map<String, String>> items,
  ) {
    return Padding(
      padding: context.responsiveContentPadding,
      child: context.responsiveGrid(
        mobileColumns: 1,
        tabletColumns: 2,
        desktopColumns: 2,
        childAspectRatio: 1.2,
        children: items
            .map((item) => _buildWishlistCard(context, item))
            .toList(),
      ),
    );
  }

  Widget _buildDesktopWishlist(
    BuildContext context,
    List<Map<String, String>> items,
  ) {
    return Padding(
      padding: context.responsiveContentPadding,
      child: context.responsiveGrid(
        mobileColumns: 1,
        tabletColumns: 2,
        desktopColumns: 3,
        childAspectRatio: 1.1,
        children: items
            .map((item) => _buildWishlistCard(context, item))
            .toList(),
      ),
    );
  }

  Widget _buildWishlistCard(BuildContext context, Map<String, String> item) {
    final categoryColor = context.getCategoryColor(item['category']!);

    return context.responsiveCard(
      margin: EdgeInsets.only(bottom: context.responsiveSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service header with category
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveSmallSpacing,
                  vertical: context.elementSpacing,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.defaultRadius),
                ),
                child: Text(
                  item['category']!,
                  style: context.labelSmall.copyWith(
                    color: categoryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _removeFromWishlist(context, item),
                icon: const Icon(Icons.favorite),
                color: context.errorColor,
                iconSize: context.responsiveSmallIconSize,
              ),
            ],
          ),

          context.responsiveSmallVerticalSpacing,

          // Service content
          Row(
            children: [
              // Service image placeholder
              Container(
                width: context.responsive(
                  mobile: 80.0,
                  tablet: 90.0,
                  desktop: 100.0,
                ),
                height: context.responsive(
                  mobile: 80.0,
                  tablet: 90.0,
                  desktop: 100.0,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: context.responsiveSmallBorderRadius,
                ),
                child: Icon(
                  _getServiceIcon(item['service']!),
                  color: categoryColor,
                  size: context.responsiveIconSize,
                ),
              ),

              context.responsiveSmallHorizontalSpacing,

              // Service details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['service']!,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.elementSpacing),
                    Text(
                      item['salon']!,
                      style: context.bodySmall.copyWith(
                        color: context.textMediumEmphasisColor,
                      ),
                    ),
                    SizedBox(height: context.componentSpacing),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: context.responsiveSmallIconSize,
                          color: context.getCategoryColor('rating'),
                        ),
                        SizedBox(width: context.elementSpacing),
                        Text(
                          item['rating']!,
                          style: context.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: context.componentSpacing),
                        Icon(
                          Icons.schedule,
                          size: context.responsiveSmallIconSize,
                          color: context.textMediumEmphasisColor,
                        ),
                        SizedBox(width: context.elementSpacing),
                        Text(
                          item['duration']!,
                          style: context.labelSmall.copyWith(
                            color: context.textMediumEmphasisColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          context.responsiveSmallVerticalSpacing,

          // Price and booking section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['price']!,
                style: context.titleMedium.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton(
                onPressed: () => _bookService(context, item),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    context.responsive(
                      mobile: 80.0,
                      tablet: 90.0,
                      desktop: 100.0,
                    ),
                    context.responsive(
                      mobile: 36.0,
                      tablet: 40.0,
                      desktop: 44.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveSmallSpacing,
                  ),
                ),
                child: Text('Book', style: context.labelMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'hair styling':
      case 'hair cut':
      case 'hair':
        return Icons.content_cut;
      case 'facial treatment':
      case 'facial':
        return Icons.face;
      case 'manicure':
      case 'nail':
        return Icons.back_hand;
      case 'massage':
        return Icons.spa;
      case 'makeup':
        return Icons.palette;
      default:
        return Icons.star;
    }
  }

  void _removeFromWishlist(BuildContext context, Map<String, String> item) {
    context.showWarningSnackBar('${item['service']} removed from wishlist');
    // In a real app, this would call the wishlist provider to remove the item
  }

  void _bookService(BuildContext context, Map<String, String> item) {
    context.showSuccessSnackBar(
      'Redirecting to booking for ${item['service']}',
    );
    // In a real app, this would navigate to the booking screen with the service details
    // Navigator.pushNamed(context, '/booking', arguments: item);
  }

  void _showClearWishlistDialog(BuildContext context) {
    context
        .showConfirmDialog(
          title: 'Clear Wishlist',
          message:
              'Are you sure you want to remove all items from your wishlist? This action cannot be undone.',
          confirmText: 'Clear All',
          cancelText: 'Cancel',
          isDangerous: true,
        )
        .then((confirmed) {
          if (confirmed == true) {
            context.showWarningSnackBar('Wishlist cleared');
            // In a real app, this would call the wishlist provider to clear all items
          }
        });
  }
}
