// Fixed HomeScreen with Proper Responsive Design and Theme Integration
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/salon_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/base_screen.dart';
import './widgets/gender_toggle_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/near_you_section_widget.dart';
import './widgets/popular_services_widget.dart';
import './widgets/promotional_banner_widget.dart';
import './widgets/quick_booking_fab_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isMaleSelected = false;
  String _currentLocation = 'Varanasi, UP';
  final int _notificationCount = 3;

  // Banner data
  final List<Map<String, dynamic>> _banners = [
    {
      "id": 1,
      "title": "New Year Special Offer",
      "subtitle": "Get 30% off on all services",
      "image":
          "https://images.unsplash.com/photo-1560066984-138dadb4c035?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "discount": "30% OFF",
    },
    {
      "id": 2,
      "title": "Premium Hair Treatment",
      "subtitle": "Transform your look today",
      "image":
          "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "discount": "20% OFF",
    },
  ];

  final List<Map<String, dynamic>> _nearbySalons = [
    {
      "id": 1,
      "name": "Glamour Studio",
      "image":
          "https://images.unsplash.com/photo-1560066984-138dadb4c035?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.8,
      "reviewCount": 245,
      "distance": "0.5 km",
      "startingPrice": "₹25",
      "isOpen": true,
      "isFavorite": false,
      "discount": "15% OFF",
    },
    {
      "id": 2,
      "name": "Beauty Lounge",
      "image":
          "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.6,
      "reviewCount": 189,
      "distance": "0.8 km",
      "startingPrice": "₹30",
      "isOpen": true,
      "isFavorite": true,
    },
    {
      "id": 3,
      "name": "Elite Salon",
      "image":
          "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.9,
      "reviewCount": 312,
      "distance": "1.2 km",
      "startingPrice": "₹35",
      "isOpen": false,
      "isFavorite": false,
    },
  ];

  final List<Map<String, dynamic>> _popularServices = [
    {
      "id": 1,
      "name": "Hair Cut & Styling",
      "image":
          "https://images.unsplash.com/photo-1560066984-138dadb4c035?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.8,
      "bookingCount": 1250,
      "price": "₹35",
      "duration": "45 min",
      "isPopular": true,
    },
    {
      "id": 2,
      "name": "Facial Treatment",
      "image":
          "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.7,
      "bookingCount": 890,
      "price": "₹50",
      "duration": "60 min",
      "isPopular": false,
    },
    {
      "id": 3,
      "name": "Manicure & Pedicure",
      "image":
          "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.5,
      "bookingCount": 650,
      "price": "₹40",
      "duration": "30 min",
      "isPopular": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _slideController.forward();
      });

      // Set gender based on auth state
      final authState = ref.read(authProvider);
      if (authState.user?.gender != null && mounted) {
        setState(() {
          _isMaleSelected = authState.user!.gender == 'male';
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return BaseScreen(
      initialIndex: 0,
      showAppBar: false,
      floatingActionButton: FadeTransition(
        opacity: _fadeAnimation,
        child: QuickBookingFabWidget(
          onPressed: () => _handleBookingAction(context, authState),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        color: context.primaryColor,
        backgroundColor: context.surfaceColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Status bar spacing
            SliverToBoxAdapter(
              child: SizedBox(height: context.statusBarHeight),
            ),

            // Location header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: LocationHeaderWidget(
                  currentLocation: _currentLocation,
                  onLocationTap: _onLocationTap,
                  onNotificationTap: _onNotificationTap,
                  notificationCount: _notificationCount,
                ),
              ),
            ),

            // Welcome section with gender toggle
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildWelcomeSection(context, authState),
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.responsiveSpacing,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SearchBarWidget(
                    controller: _searchController,
                    onTap: _onSearchTap,
                    isReadOnly: true,
                  ),
                ),
              ),
            ),

            // Guest warning (if applicable)
            if (authState.isGuest)
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildGuestWarning(context),
                ),
              ),

            // Promotional banners
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.responsiveSmallSpacing,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: PromotionalBannerWidget(banners: _banners),
                ),
              ),
            ),

            // Popular services
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.responsiveSpacing,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final popularServices = ref.watch(popularServicesProvider);
                      return PopularServicesWidget(
                        services: popularServices.take(8).map((service) => {
                          'id': service.id,
                          'name': service.name,
                          'image': service.primaryImage,
                          'price': service.formattedPrice,
                          'originalPrice': service.originalPrice != null ? '₹${service.originalPrice!.toInt()}' : null,
                          'rating': service.rating,
                          'duration': service.formattedDuration,
                          'isPopular': service.isPopular,
                        }).toList(),
                        onServiceTap: _onServiceTap,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Near you section
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Consumer(
                  builder: (context, ref, child) {
                    final salonState = ref.watch(salonProvider);
                    return NearYouSectionWidget(
                      salons: salonState.salons.take(6).map((salon) => {
                        'id': salon.id,
                        'name': salon.name,
                        'image': salon.images.isNotEmpty ? salon.images.first : '',
                        'rating': salon.rating,
                        'distance': '2.5 km', // Mock distance
                        'isOpen': salon.isOpen,
                        'isFavorite': false, // This would come from wishlist provider
                      }).toList(),
                      onSalonTap: _onSalonTap,
                      onFavoriteToggle: _onFavoriteToggle,
                      onShare: _onShare,
                      onGetDirections: _onGetDirections,
                    );
                  },
                ),
              ),
            ),

            // Bottom spacing for FAB
            SliverToBoxAdapter(
              child: SizedBox(height: context.responsiveExtraLargeSpacing * 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, AuthState authState) {
    return Container(
      padding: context.responsiveContentPadding,
      child: context.responsiveLayout(
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeText(context, authState),
            SizedBox(height: context.responsiveSpacing),
            Align(
              alignment: Alignment.centerRight,
              child: GenderToggleWidget(
                isMaleSelected: _isMaleSelected,
                onGenderChanged: _onGenderChanged,
              ),
            ),
          ],
        ),
        tablet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildWelcomeText(context, authState)),
            SizedBox(width: context.responsiveSpacing),
            GenderToggleWidget(
              isMaleSelected: _isMaleSelected,
              onGenderChanged: _onGenderChanged,
            ),
          ],
        ),
        desktop: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildWelcomeText(context, authState)),
            SizedBox(width: context.responsiveLargeSpacing),
            GenderToggleWidget(
              isMaleSelected: _isMaleSelected,
              onGenderChanged: _onGenderChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context, AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting()},',
          style: context.bodyLarge.copyWith(
            color: context.textMediumEmphasisColor,
            fontSize: context.responsive<double>(
              mobile: 16,
              tablet: 18,
              desktop: 20,
              smallMobile: 14,
            ),
          ),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Text(
          authState.user?.displayName ?? (authState.isGuest ? 'Guest' : 'User'),
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: context.responsive<double>(
              mobile: 24,
              tablet: 28,
              desktop: 32,
              smallMobile: 20,
            ),
          ),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Text(
          authState.isGuest
              ? 'Welcome to Aura! Sign up to unlock all features.'
              : 'Ready to discover your perfect beauty experience?',
          style: context.bodyMedium.copyWith(
            color: context.textMediumEmphasisColor,
            height: 1.5,
            fontSize: context.responsive<double>(
              mobile: 14,
              tablet: 16,
              desktop: 18,
              smallMobile: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestWarning(BuildContext context) {
    return Container(
      margin: context.responsiveHorizontalPadding,
      padding: context.responsivePadding,
      decoration: context.elegantContainerDecoration.copyWith(
        color: context.primaryColor.withOpacity(0.08),
        border: Border.all(
          color: context.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: context.responsiveLayout(
        mobile: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.responsiveSmallSpacing),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: context.primaryColor,
                    size: context.responsiveSmallIconSize,
                  ),
                ),
                SizedBox(width: context.responsiveSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Limited Access',
                        style: context.labelLarge.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Create an account to book appointments and access all features.',
                        style: context.bodySmall.copyWith(
                          color: context.textMediumEmphasisColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.login),
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Event handlers
  void _onGenderChanged(bool isMale) {
    if (mounted) {
      setState(() {
        _isMaleSelected = isMale;
      });
      HapticFeedback.lightImpact();

      // Show theme change feedback
      context.showInfoSnackBar(
        'Theme updated to ${isMale ? 'Male' : 'Female'} style',
      );
    }
  }

  void _onLocationTap() {
    _showLocationBottomSheet();
  }

  void _onNotificationTap() {
    final authState = ref.read(authProvider);
    _handlePremiumFeature(context, authState, 'notifications');
  }

  void _onSearchTap() {
    context.navigateToSearch();
  }

  void _onServiceTap(Map<String, dynamic> service) {
    final authState = ref.read(authProvider);
    if (authState.requiresLogin) {
      _showAuthRequiredDialog(context);
    } else {
      context.showInfoSnackBar('Service details: ${service['name']}');
    }
  }

  void _onSalonTap(Map<String, dynamic> salon) {
    final authState = ref.read(authProvider);
    if (authState.requiresLogin) {
      _showAuthRequiredDialog(context);
    } else {
      context.showInfoSnackBar('Salon details: ${salon['name']}');
    }
  }

  void _onFavoriteToggle(Map<String, dynamic> salon) {
    final authState = ref.read(authProvider);
    if (authState.requiresLogin) {
      _showAuthRequiredDialog(context);
    } else {
      setState(() {
        final index = _nearbySalons.indexWhere((s) => s['id'] == salon['id']);
        if (index != -1) {
          _nearbySalons[index]['isFavorite'] =
              !(_nearbySalons[index]['isFavorite'] as bool);

          final isFavorite = _nearbySalons[index]['isFavorite'] as bool;
          context.showSuccessSnackBar(
            isFavorite
                ? '${salon['name']} added to favorites'
                : '${salon['name']} removed from favorites',
          );
        }
      });
      HapticFeedback.lightImpact();
    }
  }

  void _onShare(Map<String, dynamic> salon) {
    context.showInfoSnackBar('Sharing ${salon['name']}...');
    HapticFeedback.lightImpact();
  }

  void _onGetDirections(Map<String, dynamic> salon) {
    context.showInfoSnackBar('Getting directions to ${salon['name']}...');
    HapticFeedback.lightImpact();
  }

  void _handleBookingAction(BuildContext context, AuthState authState) {
    if (authState.requiresLogin) {
      _showAuthRequiredDialog(context);
    } else {
      context.showInfoSnackBar('Quick booking feature coming soon!');
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Reset animations for smooth refresh effect
      _fadeController.reset();
      _slideController.reset();

      await _fadeController.forward();
      await _slideController.forward();

      context.showSuccessSnackBar('Content refreshed successfully!');
    }
  }

  // Helper methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _handlePremiumFeature(
    BuildContext context,
    AuthState authState,
    String feature,
  ) {
    if (authState.requiresLogin) {
      _showAuthRequiredDialog(context);
    } else {
      context.showInfoSnackBar('$feature feature coming soon!');
    }
  }

  void _showAuthRequiredDialog(BuildContext context) {
    context
        .showConfirmDialog(
          title: 'Login Required',
          message:
              'This feature requires a full account. Would you like to login or create an account?',
          confirmText: 'Login',
          cancelText: 'Cancel',
          confirmColor: context.primaryColor,
        )
        .then((confirmed) {
          if (confirmed == true && mounted) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          }
        });
  }

  void _showLocationBottomSheet() {
    context.showAppBottomSheet(
      child: Container(
        padding: context.responsivePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: context.responsiveSize(10),
              height: context.responsiveSize(0.5),
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: context.responsiveSpacing),

            Text(
              'Select Location',
              style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
            ),

            SizedBox(height: context.responsiveSpacing),

            _buildLocationOption(
              context,
              'Use Current Location',
              Icons.my_location,
              () {
                Navigator.pop(context);
                setState(() {
                  _currentLocation = 'Varanasi, UP';
                });
                context.showSuccessSnackBar(
                  'Location updated to current location',
                );
              },
              isPrimary: true,
            ),

            _buildLocationOption(
              context,
              'Delhi, India',
              Icons.location_city,
              () {
                Navigator.pop(context);
                setState(() {
                  _currentLocation = 'Delhi, India';
                });
                context.showSuccessSnackBar('Location updated to Delhi');
              },
            ),

            _buildLocationOption(
              context,
              'Mumbai, India',
              Icons.location_city,
              () {
                Navigator.pop(context);
                setState(() {
                  _currentLocation = 'Mumbai, India';
                });
                context.showSuccessSnackBar('Location updated to Mumbai');
              },
            ),

            SizedBox(height: context.responsiveSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: context.responsiveSmallSpacing / 2,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(context.responsiveSmallSpacing),
          decoration: BoxDecoration(
            color: isPrimary
                ? context.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isPrimary
                ? context.primaryColor
                : context.textMediumEmphasisColor,
            size: context.responsiveIconSize,
          ),
        ),
        title: Text(
          title,
          style: context.bodyMedium.copyWith(
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
            color: isPrimary
                ? context.primaryColor
                : context.textHighEmphasisColor,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
