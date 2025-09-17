import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/database_service.dart';
import '../core/services/notification_service.dart';
import '../models/booking_model.dart';
import '../providers/auth_provider.dart';

// Notification types
enum NotificationType {
  booking,
  promotion,
  reminder,
  system,
  offer,
}

// In-app notification model
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
    this.imageUrl,
    this.actionUrl,
  });

  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  // Time-based getters
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
           createdAt.month == now.month &&
           createdAt.day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return createdAt.isAfter(weekStart);
  }

  Duration get timeAgo => DateTime.now().difference(createdAt);

  String get formattedTimeAgo {
    final duration = timeAgo;

    if (duration.inMinutes < 1) {
      return 'Just now';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inDays < 1) {
      return '${duration.inHours}h ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    } else {
      return '${(duration.inDays / 7).floor()}w ago';
    }
  }
}

// Notification state
class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
    this.isPermissionGranted = false,
  });

  final List<AppNotification> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;
  final bool isPermissionGranted;

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
    bool? isPermissionGranted,
    bool clearError = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      unreadCount: unreadCount ?? this.unreadCount,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
    );
  }

  // Convenience getters
  List<AppNotification> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<AppNotification> get todayNotifications =>
      notifications.where((n) => n.isToday).toList();

  List<AppNotification> get thisWeekNotifications =>
      notifications.where((n) => n.isThisWeek).toList();

  Map<NotificationType, List<AppNotification>> get notificationsByType {
    final grouped = <NotificationType, List<AppNotification>>{};
    for (final notification in notifications) {
      grouped.putIfAbsent(notification.type, () => []).add(notification);
    }
    return grouped;
  }
}

// Notification notifier
class NotificationNotifier extends Notifier<NotificationState> {
  NotificationService? _notificationService;
  DatabaseService? _databaseService;

  @override
  NotificationState build() {
    _notificationService = ref.read(notificationServiceProvider);
    _databaseService = ref.read(databaseServiceProvider);
    _initialize();
    return const NotificationState();
  }

  // Initialize notification service
  Future<void> _initialize() async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Initialize notification service
      await _notificationService!.initialize();

      // Check permission status
      final isPermissionGranted = await _notificationService!.requestPermissions();

      // Load notifications
      await _loadNotifications();

      state = state.copyWith(
        isLoading: false,
        isPermissionGranted: isPermissionGranted,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize notifications: ${e.toString()}',
      );
    }
  }

  // Load notifications
  Future<void> _loadNotifications() async {
    final authState = ref.read(authProvider);
    if (authState.user == null) return;

    try {
      final notificationData = await _databaseService!.getUserNotifications(authState.user!.uid);
      final notifications = notificationData.map((data) => AppNotification(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        message: data['message'] ?? '',
        type: NotificationType.values.firstWhere(
          (e) => e.toString().split('.').last == data['type'],
          orElse: () => NotificationType.system,
        ),
        createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
        isRead: data['isRead'] ?? false,
        data: data['data'],
        imageUrl: data['imageUrl'],
        actionUrl: data['actionUrl'],
      )).toList();
      final unreadCount = notifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load notifications: ${e.toString()}',
      );
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId && !notification.isRead) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );

      // Update in database
      await _databaseService!.markNotificationAsRead(notificationId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark notification as read: ${e.toString()}',
      );
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final updatedNotifications = state.notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );

      // In a real app, sync with backend
      await _syncAllNotificationsRead();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark all notifications as read: ${e.toString()}',
      );
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != notificationId)
          .toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );

      // In a real app, sync with backend
      await _deleteNotificationFromBackend(notificationId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete notification: ${e.toString()}',
      );
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      state = state.copyWith(
        notifications: [],
        unreadCount: 0,
      );

      // In a real app, sync with backend
      await _clearAllNotificationsFromBackend();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to clear notifications: ${e.toString()}',
      );
    }
  }

  // Send booking confirmation notification
  Future<void> sendBookingConfirmationNotification(BookingModel booking) async {
    try {
      await _notificationService!.showBookingConfirmation(
        salonName: 'Salon Name', // In real app, fetch from salon data
        serviceName: 'Service Name', // In real app, fetch from service data
        bookingDateTime: booking.bookingDateTime,
      );

      // Add to in-app notifications
      await _addInAppNotification(
        AppNotification(
          id: 'booking_${booking.id}',
          title: 'Booking Confirmed!',
          message: 'Your appointment has been confirmed for ${_formatDateTime(booking.bookingDateTime)}',
          type: NotificationType.booking,
          createdAt: DateTime.now(),
          data: {'bookingId': booking.id},
        ),
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send booking notification: ${e.toString()}',
      );
    }
  }

  // Send booking reminder notification
  Future<void> sendBookingReminderNotification(BookingModel booking) async {
    try {
      await _notificationService!.scheduleBookingReminders(
        bookingId: booking.id,
        salonName: 'Salon Name', // In real app, fetch from salon data
        serviceName: 'Service Name', // In real app, fetch from service data
        bookingDateTime: booking.bookingDateTime,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send reminder notification: ${e.toString()}',
      );
    }
  }

  // Schedule booking reminder
  Future<void> scheduleBookingReminder(BookingModel booking) async {
    try {
      await _notificationService!.scheduleBookingReminders(
        bookingId: booking.id,
        salonName: 'Salon Name', // In real app, fetch from salon data
        serviceName: 'Service Name', // In real app, fetch from service data
        bookingDateTime: booking.bookingDateTime,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to schedule reminder: ${e.toString()}',
      );
    }
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      final isGranted = await _notificationService!.requestPermissions();
      state = state.copyWith(isPermissionGranted: isGranted);
      return isGranted;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to request permissions: ${e.toString()}',
      );
      return false;
    }
  }

  // Add in-app notification
  Future<void> _addInAppNotification(AppNotification notification) async {
    final authState = ref.read(authProvider);
    if (authState.user == null) return;

    try {
      // Save to database
      await _databaseService!.saveNotification({
        'id': notification.id,
        'userId': authState.user!.uid,
        'title': notification.title,
        'message': notification.message,
        'type': notification.type.toString().split('.').last,
        'createdAt': notification.createdAt.toIso8601String(),
        'isRead': notification.isRead,
        'data': notification.data,
        'imageUrl': notification.imageUrl,
        'actionUrl': notification.actionUrl,
      });

      // Update local state
      final updatedNotifications = [notification, ...state.notifications];
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      // Still update local state even if database save fails
      final updatedNotifications = [notification, ...state.notifications];
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await _loadNotifications();
  }

  // Helper methods
  Future<void> _syncNotificationStatus(String notificationId, bool isRead) async {
    await _databaseService!.markNotificationAsRead(notificationId);
  }

  Future<void> _syncAllNotificationsRead() async {
    final authState = ref.read(authProvider);
    if (authState.user != null) {
      for (final notification in state.notifications) {
        if (!notification.isRead) {
          await _databaseService!.markNotificationAsRead(notification.id);
        }
      }
    }
  }

  Future<void> _deleteNotificationFromBackend(String notificationId) async {
    await _databaseService!.deleteNotification(notificationId);
  }

  Future<void> _clearAllNotificationsFromBackend() async {
    final authState = ref.read(authProvider);
    if (authState.user != null) {
      for (final notification in state.notifications) {
        await _databaseService!.deleteNotification(notification.id);
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

}

// Notification provider
final notificationProvider = NotifierProvider<NotificationNotifier, NotificationState>(() {
  return NotificationNotifier();
});

// Convenience providers
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationState = ref.watch(notificationProvider);
  return notificationState.unreadCount;
});

final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  final unreadCount = ref.watch(unreadNotificationCountProvider);
  return unreadCount > 0;
});

final todayNotificationsProvider = Provider<List<AppNotification>>((ref) {
  final notificationState = ref.watch(notificationProvider);
  return notificationState.todayNotifications;
});

final notificationsByTypeProvider = Provider<Map<NotificationType, List<AppNotification>>>((ref) {
  final notificationState = ref.watch(notificationProvider);
  return notificationState.notificationsByType;
});