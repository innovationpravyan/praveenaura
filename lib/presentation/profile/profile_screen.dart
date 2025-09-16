import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/base_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return BaseScreen(
      initialIndex: 3,
      showAppBar: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (authState.isGuest)
                _buildGuestProfile(context, ref)
              else
                if (authState.user != null)
                  _buildAuthenticatedProfile(context, ref, authState)
                else
                  _buildLoadingProfile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingProfile(BuildContext context) {
    return Container(
      height: 80.h(context),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading profile...'),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: context.responsiveContentPadding,
      child: Column(
        children: [
          // Guest profile header
          Container(
            width: double.infinity,
            padding: context.responsiveCardPadding,
            decoration: context.elegantContainerDecoration,
            child: Column(
              children: [
                SizedBox(height: context.responsiveSpacing),

                // Guest avatar with gradient
                Container(
                  width: context.responsiveProfileImageSize,
                  height: context.responsiveProfileImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        context.primaryColor,
                        context.primaryColor.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: context.responsiveLargeIconSize,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: context.responsiveSpacing),

                // Guest info
                Text(
                  'Guest User',
                  style: context.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: context.responsiveSmallSpacing / 2),

                Text(
                  'Browsing in guest mode',
                  style: context.bodyMedium.copyWith(
                    color: context.textMediumEmphasisColor,
                  ),
                ),

                SizedBox(height: context.responsiveSpacing),

                // Feature limitations badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveSpacing,
                    vertical: context.responsiveSmallSpacing / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: context.primaryColor,
                      ),
                      SizedBox(width: context.responsiveSmallSpacing / 2),
                      Text(
                        'Limited features available',
                        style: context.bodySmall.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.responsiveSpacing),
              ],
            ),
          ),

          SizedBox(height: context.responsiveSpacing),

          // Login prompt card
          Container(
            width: double.infinity,
            padding: context.responsiveCardPadding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor,
                  context.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: context.responsiveBorderRadius,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.account_circle,
                  size: context.responsiveLargeIconSize,
                  color: Colors.white,
                ),
                SizedBox(height: context.responsiveSpacing),
                Text(
                  'Create Account or Login',
                  style: context.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: context.responsiveSmallSpacing),
                Text(
                  'Unlock full features, book services, save favorites, and get a personalized experience',
                  style: context.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.responsiveSpacing),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.navigateToLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: context.primaryColor,
                          elevation: 0,
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    SizedBox(width: context.responsiveSmallSpacing),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.navigateToSignup(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: context.responsiveSpacing),

          // Limited features for guest
          _buildGuestMenuSection(context, ref),

          SizedBox(height: context.responsiveSpacing),

          // Exit guest mode
          _buildExitGuestSection(context, ref),

          SizedBox(height: context.responsiveLargeSpacing),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context,
      WidgetRef ref,
      AuthState authState,) {
    final user = authState.user!;

    return Padding(
      padding: context.responsiveContentPadding,
      child: Column(
        children: [
          // Profile header
          _buildProfileHeader(context, user),

          SizedBox(height: context.responsiveSpacing),

          // Stats row
          _buildStatsRow(context, user),

          SizedBox(height: context.responsiveSpacing),

          // Menu items
          _buildMenuSection(context, ref),

          SizedBox(height: context.responsiveSpacing),

          // Logout button
          _buildLogoutSection(context, ref, authState.isLoading),

          SizedBox(height: context.responsiveLargeSpacing),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: context.responsiveCardPadding,
      decoration: context.elegantContainerDecoration,
      child: Column(
        children: [
          SizedBox(height: context.responsiveSpacing),

          // Profile picture with edit button
          Stack(
            children: [
              Container(
                width: context.responsiveProfileImageSize,
                height: context.responsiveProfileImageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: user.gender == 'female'
                        ? [
                      AppColors.primaryPinkLight,
                      AppColors.primaryPinkDark,
                    ]
                        : [
                      AppColors.primaryBlueLight,
                      AppColors.primaryBlueDark,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: user.photoURL != null && user.photoURL!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    user.photoURL!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(context, user);
                    },
                  ),
                )
                    : _buildDefaultAvatar(context, user),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _handleProfilePictureChange(context),
                  child: Container(
                    width: context.responsiveIconSize,
                    height: context.responsiveIconSize,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: context.shadowColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: context.responsiveSmallIconSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveSpacing),

          // Name and email
          Text(
            user.displayName ?? 'User',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: context.responsiveSmallSpacing / 2),

          Text(
            user.email,
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),

          SizedBox(height: context.responsiveSpacing),

          // Member level badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsiveSpacing,
              vertical: context.responsiveSmallSpacing / 2,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor.withOpacity(0.1),
                  context.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: context.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.diamond,
                  size: 16,
                  color: context.primaryColor,
                ),
                SizedBox(width: context.responsiveSmallSpacing / 2),
                Text(
                  'Premium Member',
                  style: context.bodySmall.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.responsiveSpacing),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, user) {
    return Center(
      child: Text(
        user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
        style: context.headlineLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Bookings',
            '12',
            Icons.calendar_month_outlined,
                () => context.navigateToBookingHistory(),
          ),
        ),
        SizedBox(width: context.responsiveSmallSpacing),
        Expanded(
          child: _buildStatCard(
            context,
            'Spent',
            '₹2,500',
            Icons.attach_money,
            null,
          ),
        ),
        SizedBox(width: context.responsiveSmallSpacing),
        Expanded(
          child: _buildStatCard(
            context,
            'Points',
            '850',
            Icons.stars_outlined,
            null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context,
      String label,
      String value,
      IconData icon,
      VoidCallback? onTap,) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: context.responsiveCardPadding,
        decoration: context.professionalCardDecoration,
        child: Column(
          children: [
            Icon(
              icon,
              color: context.primaryColor,
              size: context.responsiveIconSize,
            ),
            SizedBox(height: context.responsiveSmallSpacing),
            Text(
              value,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Available for guests
        _buildMenuGroup(context, 'Explore Features', [
          _buildMenuItem(
            context,
            'Browse Services',
            'Explore beauty services near you',
            Icons.spa_outlined,
                () => context.navigateToSearch(),
            false,
          ),
          _buildMenuItem(
            context,
            'Find Salons',
            'Discover top-rated salons',
            Icons.store_outlined,
                () => context.navigateToSearch(),
            false,
          ),
        ]),

        SizedBox(height: context.responsiveSpacing),

        // Requires login
        _buildMenuGroup(context, 'Member Features', [
          _buildMenuItem(
            context,
            'Booking History',
            'View your past appointments',
            Icons.history,
                () => _showLoginDialog(context, ref, 'booking history'),
            true,
          ),
          _buildMenuItem(
            context,
            'Wishlist',
            'Save your favorite services',
            Icons.favorite_outline,
                () => _showLoginDialog(context, ref, 'wishlist'),
            true,
          ),
          _buildMenuItem(
            context,
            'Notifications',
            'Stay updated with alerts',
            Icons.notifications_outlined,
                () => _showLoginDialog(context, ref, 'notifications'),
            true,
          ),
        ]),

        SizedBox(height: context.responsiveSpacing),

        // Info and support
        _buildMenuGroup(context, 'Information & Support', [
          _buildMenuItem(
            context,
            'Support',
            'Get help when you need it',
            Icons.help_outline,
                () => context.navigateToSupport(),
            false,
          ),
          _buildMenuItem(
            context,
            'About Aurame',
            'Learn more about us',
            Icons.info_outline,
                () => context.navigateToAbout(),
            false,
          ),
          _buildMenuItem(
            context,
            'Privacy Policy',
            'How we protect your data',
            Icons.privacy_tip_outlined,
                () => context.navigateToPrivacy(),
            false,
          ),
        ]),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Account section
        _buildMenuGroup(context, 'Account Management', [
          _buildMenuItem(
            context,
            'Edit Profile',
            'Update your personal information',
            Icons.person_outlined,
                () => context.navigateToEditProfile(),
            false,
          ),
          _buildMenuItem(
            context,
            'Booking History',
            'View and manage bookings',
            Icons.history,
                () => context.navigateToBookingHistory(),
            false,
          ),
          _buildMenuItem(
            context,
            'Wishlist',
            'Your saved favorites',
            Icons.favorite_outline,
                () => context.navigateToWishlist(),
            false,
          ),
          _buildMenuItem(
            context,
            'Notifications',
            'Manage your alerts',
            Icons.notifications_outlined,
                () => context.navigateToNotifications(),
            false,
          ),
        ]),

        SizedBox(height: context.responsiveSpacing),

        // Settings section
        _buildMenuGroup(context, 'App Settings', [
          _buildMenuItem(
            context,
            'Settings',
            'Customize your preferences',
            Icons.settings_outlined,
                () => context.navigateToSettings(),
            false,
          ),
          _buildMenuItem(
            context,
            'Support',
            'Get help and support',
            Icons.help_outline,
                () => context.navigateToSupport(),
            false,
          ),
          _buildMenuItem(
            context,
            'About',
            'App information',
            Icons.info_outline,
                () => context.navigateToAbout(),
            false,
          ),
        ]),

        SizedBox(height: context.responsiveSpacing),

        // Legal section
        _buildMenuGroup(context, 'Legal & Privacy', [
          _buildMenuItem(
            context,
            'Privacy Policy',
            'How we handle your data',
            Icons.privacy_tip_outlined,
                () => context.navigateToPrivacy(),
            false,
          ),
          _buildMenuItem(
            context,
            'Terms & Conditions',
            'Platform terms of use',
            Icons.description_outlined,
                () => context.navigateToTerms(),
            false,
          ),
        ]),
      ],
    );
  }

  Widget _buildMenuGroup(BuildContext context,
      String title,
      List<Widget> items,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.responsiveSmallSpacing),
          child: Text(
            title,
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryColor,
            ),
          ),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Container(
          decoration: context.professionalCardDecoration,
          child: Column(
            children: items
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      color: context.dividerColor.withOpacity(0.3),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback? onTap,
      bool requiresLogin,) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (requiresLogin
              ? context.textMediumEmphasisColor.withOpacity(0.1)
              : context.primaryColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: requiresLogin
              ? context.textMediumEmphasisColor.withOpacity(0.6)
              : context.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: context.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: requiresLogin
              ? context.textMediumEmphasisColor.withOpacity(0.7)
              : context.textHighEmphasisColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.bodySmall.copyWith(
          color: requiresLogin
              ? context.textMediumEmphasisColor.withOpacity(0.5)
              : context.textMediumEmphasisColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (requiresLogin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Login',
                style: context.bodySmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          SizedBox(width: context.responsiveSmallSpacing / 2),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: context.textMediumEmphasisColor.withOpacity(0.4),
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.responsiveSmallSpacing / 2,
      ),
    );
  }

  Widget _buildExitGuestSection(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: context.professionalCardDecoration,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.errorLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.exit_to_app,
            color: AppColors.errorLight,
            size: 20,
          ),
        ),
        title: Text(
          'Exit Guest Mode',
          style: context.bodyMedium.copyWith(
            color: AppColors.errorLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Return to login screen',
          style: context.bodySmall.copyWith(
            color: AppColors.errorLight.withOpacity(0.7),
          ),
        ),
        onTap: () => _showExitGuestDialog(context, ref),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.responsiveSpacing,
          vertical: context.responsiveSmallSpacing / 2,
        ),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context,
      WidgetRef ref,
      bool isLoading,) {
    return Container(
      decoration: context.professionalCardDecoration,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.errorLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isLoading
              ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.errorLight,
              ),
            ),
          )
              : const Icon(
            Icons.logout,
            color: AppColors.errorLight,
            size: 20,
          ),
        ),
        title: Text(
          isLoading ? 'Signing out...' : 'Logout',
          style: context.bodyMedium.copyWith(
            color: isLoading
                ? context.textMediumEmphasisColor
                : AppColors.errorLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Sign out of your account',
          style: context.bodySmall.copyWith(
            color: isLoading
                ? context.textMediumEmphasisColor.withOpacity(0.7)
                : AppColors.errorLight.withOpacity(0.7),
          ),
        ),
        onTap: isLoading ? null : () => _showLogoutDialog(context, ref),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.responsiveSpacing,
          vertical: context.responsiveSmallSpacing / 2,
        ),
      ),
    );
  }

  // Dialog methods
  void _showLoginDialog(BuildContext context, WidgetRef ref, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: context.responsiveBorderRadius,
            ),
            title: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: context.primaryColor,
                ),
                SizedBox(width: context.responsiveSmallSpacing),
                const Text('Login Required'),
              ],
            ),
            content: Text(
              'You need to login to access $feature. Create an account or sign in to unlock all features.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.navigateToSignup();
                },
                child: const Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.navigateToLogin();
                },
                child: const Text('Login'),
              ),
            ],
          ),
    );
  }

  Future<void> _showExitGuestDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.responsiveBorderRadius,
          ),
          title: Row(
            children: [
              const Icon(
                Icons.exit_to_app,
                color: AppColors.errorLight,
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              const Text('Exit Guest Mode'),
            ],
          ),
          content: const Text(
            'Are you sure you want to exit guest mode? You will be returned to the login screen.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.errorLight,
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ref.read(authProvider.notifier).exitGuestMode();
      if (!context.mounted) return;
      context.navigateToLogin();
    }
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.responsiveBorderRadius,
          ),
          title: Row(
            children: [
              const Icon(
                Icons.logout,
                color: AppColors.errorLight,
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              const Text('Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.errorLight,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await ref.read(authProvider.notifier).signOut();
        if (context.mounted) {
          context.navigateToLogin();
        }
      } catch (e) {
        if (context.mounted) {
          context.showErrorSnackBar('Failed to logout: ${e.toString()}');
        }
      }
    }
  }

  void _handleProfilePictureChange(BuildContext context) {
    context.showInfoSnackBar('Profile picture change coming soon!');
  }
}