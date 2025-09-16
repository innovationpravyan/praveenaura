import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/base_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _darkMode = false;
  bool _locationServices = true;
  bool _analytics = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'INR (₹)';

  final List<String> _languages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Bengali',
    'Marathi',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
  ];

  final List<String> _currencies = [
    'INR (₹)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Settings',
      showBottomNavigation: false,
      child: SingleChildScrollView(
        padding: context.responsiveContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSettingsSection(
              context,
              'Account Settings',
              Icons.person_outline,
              [
                _buildListTile(
                  context,
                  'Personal Information',
                  'Update your profile details',
                  Icons.edit_outlined,
                  () => context.navigateToEditProfile(),
                ),
                _buildListTile(
                  context,
                  'Change Password',
                  'Update your password',
                  Icons.lock_outline,
                  () => _showChangePasswordDialog(context),
                ),
                _buildListTile(
                  context,
                  'Delete Account',
                  'Permanently delete your account',
                  Icons.delete_outline,
                  () => _showDeleteAccountDialog(context),
                  textColor: AppColors.errorLight,
                ),
              ],
            ),

            SizedBox(height: context.responsiveSpacing),

            // Notification Settings
            _buildSettingsSection(
              context,
              'Notifications',
              Icons.notifications_outlined,
              [
                _buildSwitchTile(
                  context,
                  'Push Notifications',
                  'Receive push notifications on your device',
                  _pushNotifications,
                  (value) => setState(() => _pushNotifications = value),
                ),
                _buildSwitchTile(
                  context,
                  'Email Notifications',
                  'Receive updates via email',
                  _emailNotifications,
                  (value) => setState(() => _emailNotifications = value),
                ),
                _buildSwitchTile(
                  context,
                  'SMS Notifications',
                  'Receive booking confirmations via SMS',
                  _smsNotifications,
                  (value) => setState(() => _smsNotifications = value),
                ),
                _buildListTile(
                  context,
                  'Notification Preferences',
                  'Customize what notifications you receive',
                  Icons.tune,
                  () => _showNotificationPreferences(context),
                ),
              ],
            ),

            SizedBox(height: context.responsiveSpacing),

            // App Preferences
            _buildSettingsSection(
              context,
              'App Preferences',
              Icons.settings_outlined,
              [
                _buildSwitchTile(
                  context,
                  'Dark Mode',
                  'Use dark theme for the app',
                  _darkMode,
                  (value) {
                    setState(() => _darkMode = value);
                    _showComingSoonMessage(context);
                  },
                ),
                _buildDropdownTile(
                  context,
                  'Language',
                  'Choose your preferred language',
                  _selectedLanguage,
                  _languages,
                  (value) => setState(() => _selectedLanguage = value!),
                ),
                _buildDropdownTile(
                  context,
                  'Currency',
                  'Select currency for pricing',
                  _selectedCurrency,
                  _currencies,
                  (value) => setState(() => _selectedCurrency = value!),
                ),
              ],
            ),

            SizedBox(height: context.responsiveSpacing),

            // Privacy & Security
            _buildSettingsSection(
              context,
              'Privacy & Security',
              Icons.security_outlined,
              [
                _buildSwitchTile(
                  context,
                  'Location Services',
                  'Allow app to access your location',
                  _locationServices,
                  (value) => setState(() => _locationServices = value),
                ),
                _buildSwitchTile(
                  context,
                  'Analytics',
                  'Help improve the app with usage data',
                  _analytics,
                  (value) => setState(() => _analytics = value),
                ),
                _buildListTile(
                  context,
                  'Privacy Policy',
                  'View our privacy policy',
                  Icons.privacy_tip_outlined,
                  () => context.navigateToPrivacy(),
                ),
                _buildListTile(
                  context,
                  'Terms of Service',
                  'View terms and conditions',
                  Icons.description_outlined,
                  () => context.navigateToTerms(),
                ),
              ],
            ),

            SizedBox(height: context.responsiveSpacing),

            // Support
            _buildSettingsSection(context, 'Support', Icons.help_outline, [
              _buildListTile(
                context,
                'Help Center',
                'Get help and find answers',
                Icons.help_center_outlined,
                () => context.navigateToSupport(),
              ),
              _buildListTile(
                context,
                'Contact Support',
                'Get in touch with our support team',
                Icons.support_agent_outlined,
                () => context.navigateToSupport(),
              ),
              _buildListTile(
                context,
                'Report an Issue',
                'Report bugs or technical issues',
                Icons.bug_report_outlined,
                () => _showReportIssueDialog(context),
              ),
              _buildListTile(
                context,
                'Rate the App',
                'Rate us on the App Store',
                Icons.star_outline,
                () => _showRateAppDialog(context),
              ),
            ]),

            SizedBox(height: context.responsiveSpacing),

            // About
            _buildSettingsSection(context, 'About', Icons.info_outline, [
              _buildListTile(
                context,
                'App Version',
                'Version 1.0.0',
                Icons.info_outlined,
                null, // Non-clickable
              ),
              _buildListTile(
                context,
                'About Aurame',
                'Learn more about our company',
                Icons.business_outlined,
                () => context.navigateToAbout(),
              ),
              _buildListTile(
                context,
                'Open Source Licenses',
                'View third-party licenses',
                Icons.code_outlined,
                () => _showLicenses(context),
              ),
            ]),

            SizedBox(height: context.responsiveLargeSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.responsiveSmallSpacing),
          child: Row(
            children: [
              Icon(icon, color: context.primaryColor, size: 20),
              SizedBox(width: context.responsiveSmallSpacing / 2),
              Text(
                title,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.responsiveSmallSpacing),
        Container(
          decoration: context.professionalCardDecoration,
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;

              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
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

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? context.textMediumEmphasisColor,
        size: 24,
      ),
      title: Text(
        title,
        style: context.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: textColor ?? context.textHighEmphasisColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.bodySmall.copyWith(
          color: context.textMediumEmphasisColor,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.textMediumEmphasisColor.withOpacity(0.6),
            )
          : null,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.responsiveSmallSpacing / 2,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: context.bodySmall.copyWith(
          color: context.textMediumEmphasisColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: context.primaryColor,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.responsiveSmallSpacing / 2,
      ),
    );
  }

  Widget _buildDropdownTile(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: context.bodySmall.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing / 2),
          DropdownButtonFormField<String>(
            value: value,
            decoration: context.getInputDecoration(),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            isDense: true,
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.responsiveSpacing,
      ),
    );
  }

  // Dialog methods
  void _showChangePasswordDialog(BuildContext context) {
    context.showInfoSnackBar('Change password feature coming soon!');
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.showErrorSnackBar(
                'Account deletion feature coming soon!',
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorLight),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showNotificationPreferences(BuildContext context) {
    context.showInfoSnackBar('Detailed notification settings coming soon!');
  }

  void _showReportIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What type of issue would you like to report?'),
            const SizedBox(height: 16),
            ...[
              'Bug Report',
              'Feature Request',
              'Performance Issue',
              'Other',
            ].map(
              (type) => ListTile(
                title: Text(type),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  context.navigateToSupport();
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Rate Aurame'),
        content: const Text(
          'If you enjoy using Aurame, would you mind taking a moment to rate it? It won\'t take more than a minute. Thanks for your support!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Not Now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.showSuccessSnackBar('Thanks for the feedback!');
            },
            child: const Text('Rate App'),
          ),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Aurame',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.spa, size: 48, color: context.primaryColor),
    );
  }

  void _showComingSoonMessage(BuildContext context) {
    context.showInfoSnackBar('This feature is coming soon!');
  }
}
