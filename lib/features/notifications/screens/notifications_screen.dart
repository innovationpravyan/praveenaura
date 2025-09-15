import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Check if user needs authentication
    if (authState.requiresLogin) {
      return _buildLoginRequiredScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Mark all as read
            },
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: _buildNotificationsContent(),
    );
  }

  Widget _buildLoginRequiredScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 80,
                color: AppColors.grey400,
              ),
              const SizedBox(height: AppConstants.mediumSpacing),
              Text(
                'Login Required',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              Text(
                'Please login to view your personalized notifications',
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

  Widget _buildNotificationsContent() {
    // Mock notifications data
    final notifications = [
      {
        'title': 'Booking Confirmed',
        'message':
            'Your appointment for Hair Styling is confirmed for tomorrow at 2:00 PM',
        'time': '2 hours ago',
        'type': 'booking',
        'isRead': false,
      },
      {
        'title': 'Special Offer!',
        'message': '30% off on all facial treatments. Limited time offer!',
        'time': '1 day ago',
        'type': 'offer',
        'isRead': false,
      },
      {
        'title': 'Service Completed',
        'message':
            'Thank you for choosing our service. Please rate your experience.',
        'time': '3 days ago',
        'type': 'service',
        'isRead': true,
      },
      {
        'title': 'New Salon Added',
        'message':
            'Beauty Paradise is now available in your area. Check it out!',
        'time': '1 week ago',
        'type': 'info',
        'isRead': true,
      },
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;

    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? Colors.transparent
            : AppColors.primaryPink.withAlpha(13),
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 0.5),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getNotificationColor(type).withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(type),
            color: _getNotificationColor(type),
            size: 24,
          ),
        ),
        title: Text(
          notification['title'] as String,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'] as String,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 8),
            Text(
              notification['time'] as String,
              style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.mediumSpacing,
          vertical: AppConstants.smallSpacing,
        ),
        onTap: () {
          // Mark as read and handle notification action
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_month;
      case 'offer':
        return Icons.local_offer;
      case 'service':
        return Icons.star;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking':
        return AppColors.info;
      case 'offer':
        return AppColors.warning;
      case 'service':
        return AppColors.success;
      case 'info':
        return AppColors.primaryPink;
      default:
        return AppColors.grey500;
    }
  }
}
