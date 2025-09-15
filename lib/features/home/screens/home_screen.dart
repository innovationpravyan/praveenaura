import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/common/login_required_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isGuest = authState.isGuest;

    return BaseScreen(
      initialIndex: 0,
      title: 'Aura Beauty',
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          padding: context.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user, isGuest),
              context.largeVerticalSpace,
              _buildSearchBar(),
              context.largeVerticalSpace,
              if (isGuest)
                _buildGuestWelcomeBanner()
              else
                _buildPromoBanner(user?.gender ?? AppConstants.female),
              context.largeVerticalSpace,
              _buildQuickActions(isGuest),
              context.largeVerticalSpace,
              _buildServiceCategories(),
              context.largeVerticalSpace,
              _buildFeaturedSalons(),
              const SizedBox(height: AppConstants.extraLargeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _buildHeader(dynamic user, bool isGuest) {
    final displayName = user?.firstName ?? 'Guest';
    final greeting = _getGreeting(user?.gender, isGuest);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $displayName!',
                style: context.headlineSmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                greeting,
                style: context.titleMedium.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (!isGuest) ...[
          IconButton(
            onPressed: () => context.navigateToNotifications(),
            icon: Icon(
              Icons.notifications_outlined,
              color: context.primaryColor,
            ),
          ),
          context.smallHorizontalSpace,
          CircleAvatar(
            radius: 20,
            backgroundColor: context.primaryColor.withAlpha(51),
            child: Icon(Icons.person, color: context.primaryColor),
          ),
        ],
      ],
    );
  }

  String _getGreeting(String? gender, bool isGuest) {
    if (isGuest) return 'Discover beauty services';

    switch (gender) {
      case AppConstants.female:
        return 'Ready to look stunning?';
      case AppConstants.male:
        return 'Time for self-care?';
      default:
        return 'Ready for beauty time?';
    }
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: context.cardDecoration,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search services, salons...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: context.defaultPadding,
        ),
        onSubmitted: (value) => context.navigateToExplore(),
      ),
    );
  }

  Widget _buildGuestWelcomeBanner() {
    return Container(
      padding: context.largePadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.pinkGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(context.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Aura Beauty!',
            style: context.headlineSmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          context.smallVerticalSpace,
          Text(
            'Sign in to enjoy personalized offers and faster bookings.',
            style: context.bodyMedium.copyWith(
              color: AppColors.white.withAlpha(204),
            ),
          ),
          context.mediumVerticalSpace,
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.navigateToLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryPink,
                    elevation: 0,
                  ),
                  child: const Text('Sign In'),
                ),
              ),
              context.smallHorizontalSpace,
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.navigateToSignup(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.white),
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(String gender) {
    final primaryColor = AppColors.getPrimaryColorForGender(gender);
    final gradient = AppColors.getGradientForGender(gender);

    return Container(
      height: 120,
      padding: context.defaultPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(context.defaultRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '30% OFF',
                style: context.headlineSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'On your first booking',
                style: context.bodyMedium.copyWith(color: AppColors.white),
              ),
              context.smallVerticalSpace,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(77),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Code: FIRST30',
                  style: context.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isGuest) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            'Salon Visit',
            'Book an appointment',
            Icons.store_outlined,
            () => context.navigateToExplore(),
            false,
          ),
        ),
        context.mediumHorizontalSpace,
        Expanded(
          child: _buildQuickActionCard(
            'Home Service',
            'Service at your home',
            Icons.home_outlined,
            () {
              if (isGuest) {
                _showLoginDialog();
              } else {
                context.navigateToExplore();
              }
            },
            isGuest,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool requiresLogin,
  ) {
    final cardColor = requiresLogin
        ? context.primaryColor.withAlpha(128)
        : context.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: context.defaultPadding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(context.defaultRadius),
          boxShadow: [
            BoxShadow(
              color: cardColor.withAlpha(77),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 32, color: AppColors.white),
                if (requiresLogin)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 12,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            context.smallVerticalSpace,
            Text(
              title,
              style: context.labelLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              requiresLogin ? 'Login required' : subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withAlpha(204),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Services',
              style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () => context.navigateToExplore(),
              child: Text(
                'View All',
                style: context.labelMedium.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
        context.mediumVerticalSpace,
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.serviceCategories.length,
            itemBuilder: (context, index) {
              final category = AppConstants.serviceCategories[index];
              final categoryColor =
                  AppColors.categoryColors[category] ?? context.primaryColor;

              return Container(
                width: 80,
                margin: EdgeInsets.only(right: context.responsiveSpacing),
                child: GestureDetector(
                  onTap: () => context.navigateToExplore(),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: categoryColor.withAlpha(51),
                          borderRadius: BorderRadius.circular(
                            context.defaultRadius,
                          ),
                        ),
                        child: Icon(
                          _getCategoryIcon(category),
                          color: categoryColor,
                          size: 28,
                        ),
                      ),
                      context.smallVerticalSpace,
                      Text(
                        category,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSalons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Salons',
              style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () => context.navigateToExplore(),
              child: Text(
                'View All',
                style: context.labelMedium.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
        context.mediumVerticalSpace,
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => _buildSalonCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildSalonCard(int index) {
    final salonNames = [
      'Glamour Studio',
      'Beauty Palace',
      'Elegant Salon',
      'Royal Beauty',
      'Style Studio',
    ];
    final ratings = ['4.8', '4.6', '4.9', '4.7', '4.5'];
    final distances = ['2.5 km', '3.1 km', '1.8 km', '4.2 km', '2.9 km'];

    return Container(
      width: 160,
      margin: EdgeInsets.only(right: context.responsiveSpacing),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salon image placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(context.defaultRadius),
              ),
            ),
            child: const Center(
              child: Icon(Icons.store, size: 40, color: AppColors.grey400),
            ),
          ),
          Padding(
            padding: context.smallPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salonNames[index],
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.starColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      ratings[index],
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' (120+)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 12,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      distances[index],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
                context.smallVerticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => context.navigateToExplore(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      textStyle: context.labelSmall,
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  void _showLoginDialog() {
    context.showAppDialog(
      child: LoginRequiredDialog(
        feature: 'home service booking',
        onLoginPressed: () {
          context.pop();
          context.navigateToLogin();
        },
        onSignUpPressed: () {
          context.pop();
          context.navigateToSignup();
        },
      ),
    );
  }
}
