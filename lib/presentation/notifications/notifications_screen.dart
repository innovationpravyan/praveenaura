import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/base_screen.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return BaseScreen(
      title: 'Notifications',
      showBottomNavigation: false,
      actions: authState.requiresLogin
          ? null
          : [
              IconButton(
                onPressed: () {
                  // Mark all as read
                  context.showInfoSnackBar('All notifications marked as read');
                },
                icon: const Icon(Icons.done_all),
                tooltip: 'Mark all as read',
              ),
            ],
      child: authState.requiresLogin
          ? _buildLoginRequiredContent(context)
          : _buildNotificationsContent(context),
    );
  }

  Widget _buildLoginRequiredContent(BuildContext context) {
    return Center(
      child: context.responsiveContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
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
              'Please login to view your personalized notifications',
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

  Widget _buildNotificationsContent(BuildContext context) {
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
      {
        'title': 'Reminder',
        'message': 'Don\'t forget your appointment tomorrow at Glamour Studio',
        'time': '5 hours ago',
        'type': 'reminder',
        'isRead': false,
      },
    ];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: context.responsiveLargeIconSize,
              color: context.textDisabledColor,
            ),
            context.responsiveVerticalSpacing,
            Text(
              'No Notifications',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            context.responsiveSmallVerticalSpacing,
            Text(
              'You\'ll see notifications about bookings, offers, and updates here',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(context, notifications[index]);
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    Map<String, dynamic> notification,
  ) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;

    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? Colors.transparent
            : context.primaryColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: context.dividerColor, width: 0.5),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: context.responsive(mobile: 48.0, tablet: 52.0, desktop: 56.0),
          height: context.responsive(mobile: 48.0, tablet: 52.0, desktop: 56.0),
          decoration: BoxDecoration(
            color: _getNotificationColor(context, type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(type),
            color: _getNotificationColor(context, type),
            size: context.responsiveIconSize,
          ),
        ),
        title: Text(
          notification['title'] as String,
          style: context.titleSmall.copyWith(
            fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
            color: isRead
                ? context.textMediumEmphasisColor
                : context.textHighEmphasisColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.elementSpacing),
            Text(
              notification['message'] as String,
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.componentSpacing),
            Text(
              notification['time'] as String,
              style: context.labelSmall.copyWith(
                color: context.textDisabledColor,
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: context.responsive(
                  mobile: 8.0,
                  tablet: 10.0,
                  desktop: 12.0,
                ),
                height: context.responsive(
                  mobile: 8.0,
                  tablet: 10.0,
                  desktop: 12.0,
                ),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        contentPadding: context.responsiveHorizontalPadding.copyWith(
          top: context.responsiveSmallSpacing,
          bottom: context.responsiveSmallSpacing,
        ),
        onTap: () {
          // Handle notification tap - navigate to relevant screen or show details
          _handleNotificationTap(context, notification);
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    Map<String, dynamic> notification,
  ) {
    final type = notification['type'] as String;

    // Mark as read (in a real app, this would update the backend)

    // Navigate based on notification type
    switch (type) {
      case 'booking':
      case 'reminder':
        context.navigateToBookingHistory();
        break;
      case 'offer':
        context.navigateToSearch();
        break;
      case 'service':
        // Navigate to rating/review screen
        context.showInfoSnackBar('Opening service details...');
        break;
      case 'info':
        context.navigateToSearch();
        break;
      default:
        context.showInfoSnackBar('Notification opened');
    }
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
      case 'reminder':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(BuildContext context, String type) {
    switch (type) {
      case 'booking':
        return context.getBookingStatusColor('confirmed');
      case 'offer':
        return context.getCategoryColor('offer');
      case 'service':
        return context.getBookingStatusColor('completed');
      case 'info':
        return context.primaryColor;
      case 'reminder':
        return context.getCategoryColor('reminder');
      default:
        return context.textMediumEmphasisColor;
    }
  }
}
