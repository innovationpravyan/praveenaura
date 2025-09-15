import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:aurame/core/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/common/login_required_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isGuest = authState.isGuest;
    final user = authState.user;

    // Show loading indicator during logout or initial load
    if (authState.isLoading && user == null && !isGuest) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      );
    }

    // Guest mode profile
    if (isGuest) {
      return _buildGuestProfile(context, ref);
    }

    // If user is null and not loading and not guest, they should be redirected by router
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Redirecting...'),
            ],
          ),
        ),
      );
    }

    // Authenticated user profile
    return _buildAuthenticatedProfile(context, ref, user, authState.isLoading);
  }

  Widget _buildGuestProfile(BuildContext context, WidgetRef ref) {
    return BaseScreen(
      initialIndex: 3,
      title: 'Profile',
      backgroundColor: AppColors.femaleBackgroundDark,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Guest profile header
            Container(
              padding: const EdgeInsets.all(AppConstants.largeSpacing),
              child: Column(
                children: [
                  // Guest avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: AppColors.pinkGradient),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPink.withAlpha(77),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 50,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: AppConstants.mediumSpacing),

                  // Guest info
                  Text(
                    'Guest User',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Browsing in guest mode',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),

                  const SizedBox(height: AppConstants.mediumSpacing),

                  // Login prompt
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.pinkGradient),
                      borderRadius: BorderRadius.circular(
                        AppConstants.mediumRadius,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 32,
                          color: AppColors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create Account or Login',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Unlock full features, book services, and personalized experience',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withAlpha(230),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
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
                                child: const Text('Login'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.navigateToSignup(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.white,
                                  ),
                                  foregroundColor: AppColors.white,
                                ),
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largeSpacing),

            // Limited features for guest
            _buildGuestMenuSection(context, ref),

            const SizedBox(height: AppConstants.largeSpacing),

            // Exit guest mode
            _buildExitGuestSection(context, ref),

            const SizedBox(height: AppConstants.extraLargeSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context,
      WidgetRef ref,
      UserModel user,
      bool isLoading,) {
    final isDarkTheme = user.gender == AppConstants.male;
    final primaryColor = isDarkTheme
        ? AppColors.primaryBlue
        : AppColors.primaryPink;
    final backgroundColor = isDarkTheme
        ? AppColors.maleBackgroundDark
        : AppColors.femaleBackgroundDark;

    return BaseScreen(
      initialIndex: 3,
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              _buildProfileHeader(context, user, primaryColor),

              const SizedBox(height: AppConstants.largeSpacing),

              // Stats row
              _buildStatsRow(context, user, primaryColor),

              const SizedBox(height: AppConstants.largeSpacing),

              // Menu items
              _buildMenuSection(context, ref, primaryColor, false),

              const SizedBox(height: AppConstants.largeSpacing),

              // Logout button
              _buildLogoutSection(context, ref, isLoading),

              const SizedBox(height: AppConstants.extraLargeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestMenuSection(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
      ),
      child: Column(
        children: [
          // Available for guests
          _buildMenuGroup(context, 'Explore', [
            _buildMenuItem(
              context,
              'Browse Services',
              Icons.spa_outlined,
                  () => context.navigateToExplore(),
              false,
            ),
            _buildMenuItem(
              context,
              'Find Salons',
              Icons.store_outlined,
                  () => context.navigateToExplore(),
              false,
            ),
          ]),

          const SizedBox(height: AppConstants.largeSpacing),

          // Requires login
          _buildMenuGroup(context, 'Account Features (Login Required)', [
            _buildMenuItem(
              context,
              'Booking History',
              Icons.history,
                  () => _showLoginDialog(context, ref, 'booking_history'),
              true,
            ),
            _buildMenuItem(
              context,
              'Wishlist',
              Icons.favorite_outline,
                  () => _showLoginDialog(context, ref, 'wishlist'),
              true,
            ),
            _buildMenuItem(
              context,
              'Notifications',
              Icons.notifications_outlined,
                  () => _showLoginDialog(context, ref, 'notifications'),
              true,
            ),
          ]),

          const SizedBox(height: AppConstants.largeSpacing),

          // Info and support
          _buildMenuGroup(context, 'Information', [
            _buildMenuItem(
              context,
              'Support',
              Icons.help_outline,
                  () => context.navigateToSupport(),
              false,
            ),
            _buildMenuItem(
              context,
              'About',
              Icons.info_outline,
                  () => context.navigateToAbout(),
              false,
            ),
            _buildMenuItem(
              context,
              'Privacy Policy',
              Icons.privacy_tip_outlined,
                  () => context.navigateToPrivacy(),
              false,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildExitGuestSection(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: const Icon(Icons.exit_to_app, color: AppColors.error),
          title: Text(
            'Exit Guest Mode',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: const Text('Return to login screen'),
          onTap: () => _showExitGuestDialog(context, ref),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.mediumSpacing,
            vertical: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context,
      UserModel user,
      Color primaryColor,) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largeSpacing),
      child: Column(
        children: [
          // Profile picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: user.gender == AppConstants.female
                        ? AppColors.pinkGradient
                        : AppColors.blueGradient,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withAlpha(77),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: user.photoURL != null && user.photoURL!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    user.photoURL!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(user);
                    },
                  ),
                )
                    : _buildDefaultAvatar(user),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    _handleProfilePictureChange(context);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.mediumSpacing),

          // Name and email
          Text(
            user.displayName ?? 'User',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            user.email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colorScheme.onSurface.withAlpha(153),
            ),
          ),

          const SizedBox(height: AppConstants.smallSpacing),

          // Member level badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.mediumSpacing,
              vertical: AppConstants.smallSpacing,
            ),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
            ),
            child: Text(
              '${user.membershipLevel} Member',
              style: AppTextStyles.caption.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(UserModel user) {
    return Center(
      child: Text(
        user.initials,
        style: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context,
      UserModel user,
      Color primaryColor,) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Bookings',
              (user.totalBookings).toString(),
              Icons.calendar_month_outlined,
              primaryColor,
            ),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: _buildStatCard(
              context,
              'Spent',
              '₹${(user.totalSpent).toStringAsFixed(0)}',
              Icons.attach_money,
              primaryColor,
            ),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: _buildStatCard(
              context,
              'Points',
              (user.loyaltyPoints).toString(),
              Icons.stars_outlined,
              primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      String label,
      String value,
      IconData icon,
      Color primaryColor,) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: context.colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context,
      WidgetRef ref,
      Color primaryColor,
      bool isGuest,) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
      ),
      child: Column(
        children: [
          // Account section
          _buildMenuGroup(context, 'Account', [
            _buildMenuItem(
              context,
              'Edit Profile',
              Icons.person_outlined,
                  () => context.navigateToEditProfile(),
              false,
            ),
            _buildMenuItem(
              context,
              'Booking History',
              Icons.history,
                  () => context.navigateToBookings(),
              false,
            ),
            _buildMenuItem(
              context,
              'Wishlist',
              Icons.favorite_outline,
                  () => context.navigateToWishlist(),
              false,
            ),
            _buildMenuItem(
              context,
              'Notifications',
              Icons.notifications_outlined,
                  () => context.navigateToNotifications(),
              false,
            ),
          ]),

          const SizedBox(height: AppConstants.largeSpacing),

          // Settings section
          _buildMenuGroup(context, 'Settings', [
            _buildMenuItem(
              context,
              'Settings',
              Icons.settings_outlined,
                  () => context.navigateToSettings(),
              false,
            ),
            _buildMenuItem(
              context,
              'Support',
              Icons.help_outline,
                  () => context.navigateToSupport(),
              false,
            ),
            _buildMenuItem(
              context,
              'About',
              Icons.info_outline,
                  () => context.navigateToAbout(),
              false,
            ),
          ]),

          const SizedBox(height: AppConstants.largeSpacing),

          // Legal section
          _buildMenuGroup(context, 'Legal', [
            _buildMenuItem(
              context,
              'Privacy Policy',
              Icons.privacy_tip_outlined,
                  () => context.navigateToPrivacy(),
              false,
            ),
            _buildMenuItem(
              context,
              'Terms & Conditions',
              Icons.description_outlined,
                  () => context.navigateToTerms(),
              false,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuGroup(BuildContext context,
      String title,
      List<Widget> items,) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.mediumSpacing,
              AppConstants.mediumSpacing,
              AppConstants.mediumSpacing,
              AppConstants.smallSpacing,
            ),
            child: Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      bool requiresLogin,) {
    return ListTile(
      leading: Icon(
        icon,
        color: requiresLogin
            ? context.colorScheme.onSurface.withAlpha(102)
            : context.colorScheme.onSurface.withAlpha(153),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: requiresLogin
              ? context.colorScheme.onSurface.withAlpha(102)
              : context.colorScheme.onSurface,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (requiresLogin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Login',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryPink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colorScheme.onSurface.withAlpha(102),
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: 4,
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context,
      WidgetRef ref,
      bool isLoading,) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
            ),
          )
              : const Icon(Icons.logout, color: AppColors.error),
          title: Text(
            isLoading ? 'Signing out...' : 'Logout',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isLoading ? Colors.grey : AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: isLoading ? null : () => _showLogoutDialog(context, ref),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.mediumSpacing,
            vertical: 4,
          ),
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) =>
          LoginRequiredDialog(
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

  Future<void> _showExitGuestDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Exit Guest Mode'),
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
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
          context.navigateToHome();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to logout: ${e.toString()}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _handleProfilePictureChange(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture change coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
