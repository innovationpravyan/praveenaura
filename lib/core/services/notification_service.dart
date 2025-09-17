import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Handling a background message: ${message.messageId}');

  // Handle background message
  await NotificationService().handleBackgroundMessage(message);
}

class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  // Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Local Notifications plugin
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _fcmToken;

  // Notification callback
  Function(RemoteMessage)? _onMessageReceived;
  Function(RemoteMessage)? _onMessageOpenedApp;

  // Initialize notification service
  Future<void> initialize({
    Function(RemoteMessage)? onMessageReceived,
    Function(RemoteMessage)? onMessageOpenedApp,
  }) async {
    if (_isInitialized) return;

    try {
      developer.log('Initializing NotificationService');

      // Set callbacks
      _onMessageReceived = onMessageReceived;
      _onMessageOpenedApp = onMessageOpenedApp;

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      _isInitialized = true;
      developer.log('NotificationService initialized successfully');
    } catch (e) {
      developer.log('Failed to initialize NotificationService: $e');
      throw BusinessException(
        'Failed to initialize notifications',
        'notification-init-error',
      );
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher', // Default app icon
      );

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      );

      developer.log('Local notifications initialized');
    } catch (e) {
      developer.log('Error initializing local notifications: $e');
    }
  }

  // Public method to request permissions
  Future<bool> requestPermissions() async {
    try {
      final settings = await _requestPermissions();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      developer.log('Error requesting permissions: $e');
      return false;
    }
  }

  // Request notification permissions
  Future<NotificationSettings> _requestPermissions() async {
    try {
      developer.log('Requesting notification permissions');

      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      developer.log('Permission status: ${settings.authorizationStatus}');
      return settings;
    } catch (e) {
      developer.log('Error requesting permissions: $e');
      rethrow;
    }
  }

  // Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      developer.log('FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      developer.log('Error getting FCM token: $e');
      return null;
    }
  }

  // Set up message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log('Received foreground message: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Handle message when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Message opened app: ${message.messageId}');
      _onMessageOpenedApp?.call(message);
    });

    // Handle initial message when app is launched from notification
    _checkForInitialMessage();
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification
    _showLocalNotification(message);

    // Call callback
    _onMessageReceived?.call(message);
  }

  // Handle background messages
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    developer.log('Processing background message: ${message.messageId}');

    // Process the message (save to local storage, update badge, etc.)
    // This runs in the background, so avoid heavy operations
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Notifications',
        channelDescription: 'Default notification channel for the app',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: message.data.toString(),
      );

      developer.log('Local notification shown: ${notification.title}');
    } catch (e) {
      developer.log('Error showing local notification: $e');
    }
  }

  // Handle local notification tap
  void _onLocalNotificationTapped(NotificationResponse response) {
    developer.log('Local notification tapped: ${response.payload}');

    // Handle notification tap
    // You can navigate to specific screens based on payload
  }

  // Check for initial message
  Future<void> _checkForInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        developer.log('App launched from notification: ${initialMessage.messageId}');
        _onMessageOpenedApp?.call(initialMessage);
      }
    } catch (e) {
      developer.log('Error checking initial message: $e');
    }
  }

  // Get current FCM token
  String? get fcmToken => _fcmToken;

  // Refresh FCM token
  Future<String?> refreshToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      return await _getFCMToken();
    } catch (e) {
      developer.log('Error refreshing FCM token: $e');
      return null;
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      developer.log('Subscribing to topic: $topic');
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      developer.log('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      developer.log('Unsubscribing from topic: $topic');
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      developer.log('Error unsubscribing from topic: $e');
    }
  }

  // Show local notification manually
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'local_notifications',
        'Local Notifications',
        channelDescription: 'Local notifications for the app',
        importance: _getAndroidImportance(priority),
        priority: _getAndroidPriority(priority),
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      developer.log('Local notification shown: $title');
    } catch (e) {
      developer.log('Error showing manual local notification: $e');
    }
  }

  // Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final scheduledTime = scheduledDate.toLocal();

      const androidDetails = AndroidNotificationDetails(
        'scheduled_notifications',
        'Scheduled Notifications',
        channelDescription: 'Scheduled notifications for bookings and reminders',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Note: This is a simplified version
      // In a real app, you'd use timezone package and proper scheduling
      // await _localNotifications.zonedSchedule(
      //   id,
      //   title,
      //   body,
      //   tz.TZDateTime.from(scheduledTime, tz.local),
      //   notificationDetails,
      //   payload: payload,
      //   uiLocalNotificationDateInterpretation:
      //       UILocalNotificationDateInterpretation.absoluteTime,
      // );

      developer.log('Notification scheduled for: $scheduledTime');
    } catch (e) {
      developer.log('Error scheduling notification: $e');
    }
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      developer.log('Notification cancelled: $id');
    } catch (e) {
      developer.log('Error cancelling notification: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      developer.log('All notifications cancelled');
    } catch (e) {
      developer.log('Error cancelling all notifications: $e');
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      developer.log('Error getting pending notifications: $e');
      return [];
    }
  }

  // Check notification permissions
  Future<bool> hasNotificationPermissions() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      developer.log('Error checking notification permissions: $e');
      return false;
    }
  }

  // Request permissions again
  Future<bool> requestNotificationPermissions() async {
    try {
      final settings = await _requestPermissions();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      developer.log('Error requesting notification permissions: $e');
      return false;
    }
  }

  // Create booking reminder notifications
  Future<void> scheduleBookingReminders({
    required String bookingId,
    required String salonName,
    required String serviceName,
    required DateTime bookingDateTime,
  }) async {
    try {
      final reminders = [
        {
          'time': bookingDateTime.subtract(Duration(hours: 24)),
          'title': 'Booking Reminder',
          'body': 'You have a $serviceName appointment tomorrow at $salonName',
          'id': '${bookingId}_24h'.hashCode,
        },
        {
          'time': bookingDateTime.subtract(Duration(hours: 2)),
          'title': 'Appointment Soon',
          'body': 'Your $serviceName appointment at $salonName starts in 2 hours',
          'id': '${bookingId}_2h'.hashCode,
        },
        {
          'time': bookingDateTime.subtract(Duration(minutes: 30)),
          'title': 'Time to Go!',
          'body': 'Your appointment at $salonName starts in 30 minutes',
          'id': '${bookingId}_30m'.hashCode,
        },
      ];

      for (final reminder in reminders) {
        final reminderTime = reminder['time'] as DateTime;

        if (reminderTime.isAfter(DateTime.now())) {
          await scheduleNotification(
            id: reminder['id'] as int,
            title: reminder['title'] as String,
            body: reminder['body'] as String,
            scheduledDate: reminderTime,
            payload: 'booking_reminder:$bookingId',
          );
        }
      }

      developer.log('Booking reminders scheduled for booking: $bookingId');
    } catch (e) {
      developer.log('Error scheduling booking reminders: $e');
    }
  }

  // Cancel booking reminders
  Future<void> cancelBookingReminders(String bookingId) async {
    try {
      final reminderIds = [
        '${bookingId}_24h'.hashCode,
        '${bookingId}_2h'.hashCode,
        '${bookingId}_30m'.hashCode,
      ];

      for (final id in reminderIds) {
        await cancelNotification(id);
      }

      developer.log('Booking reminders cancelled for booking: $bookingId');
    } catch (e) {
      developer.log('Error cancelling booking reminders: $e');
    }
  }

  // Show booking confirmation notification
  Future<void> showBookingConfirmation({
    required String salonName,
    required String serviceName,
    required DateTime bookingDateTime,
  }) async {
    final formattedDate = '${bookingDateTime.day}/${bookingDateTime.month}/${bookingDateTime.year}';
    final formattedTime = '${bookingDateTime.hour.toString().padLeft(2, '0')}:${bookingDateTime.minute.toString().padLeft(2, '0')}';

    await showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Booking Confirmed! ✅',
      body: '$serviceName at $salonName on $formattedDate at $formattedTime',
      priority: NotificationPriority.high,
    );
  }

  // Show promotional notification
  Future<void> showPromotionalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      payload: payload,
      priority: NotificationPriority.medium,
    );
  }

  // Helper methods for Android notification importance/priority
  Importance _getAndroidImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.medium:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.urgent:
        return Importance.max;
    }
  }

  Priority _getAndroidPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.medium:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.urgent:
        return Priority.max;
    }
  }

  // Subscribe to user-specific topics
  Future<void> subscribeToUserTopics(String userId) async {
    await subscribeToTopic('user_$userId');
    await subscribeToTopic('all_users');
    await subscribeToTopic('app_updates');
  }

  // Unsubscribe from user-specific topics
  Future<void> unsubscribeFromUserTopics(String userId) async {
    await unsubscribeFromTopic('user_$userId');
    await unsubscribeFromTopic('all_users');
    await unsubscribeFromTopic('app_updates');
  }

  // Get notification settings
  Map<String, dynamic> getNotificationSettings() {
    return {
      'isInitialized': _isInitialized,
      'hasToken': _fcmToken != null,
      'token': _fcmToken,
    };
  }

  // Clear all data (for logout)
  Future<void> clearNotificationData() async {
    try {
      await cancelAllNotifications();
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      developer.log('Notification data cleared');
    } catch (e) {
      developer.log('Error clearing notification data: $e');
    }
  }
}

// Notification priority enum
enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

// Notification model for better type safety
class AppNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final NotificationPriority priority;
  final DateTime? scheduledTime;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.priority = NotificationPriority.medium,
    this.scheduledTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'priority': priority.name,
      'scheduledTime': scheduledTime?.toIso8601String(),
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      payload: map['payload'],
      priority: NotificationPriority.values.firstWhere(
            (p) => p.name == map['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      scheduledTime: map['scheduledTime'] != null
          ? DateTime.parse(map['scheduledTime'])
          : null,
    );
  }
}

// Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});