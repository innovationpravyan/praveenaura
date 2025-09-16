import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static const String _defaultDateFormat = 'MMM dd, yyyy';
  static const String _defaultTimeFormat = 'hh:mm a';
  static const String _defaultDateTimeFormat = 'MMM dd, yyyy • hh:mm a';
  static const String _apiDateFormat = 'yyyy-MM-dd';
  static const String _apiTimeFormat = 'HH:mm:ss';
  static const String _apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';

  // Format date for display
  static String formatDate(DateTime date, {String? format}) {
    return DateFormat(format ?? _defaultDateFormat).format(date);
  }

  // Format time for display
  static String formatTime(DateTime time, {String? format}) {
    return DateFormat(format ?? _defaultTimeFormat).format(time);
  }

  // Format datetime for display
  static String formatDateTime(DateTime dateTime, {String? format}) {
    return DateFormat(format ?? _defaultDateTimeFormat).format(dateTime);
  }

  // Format date for API
  static String formatDateForApi(DateTime date) {
    return DateFormat(_apiDateFormat).format(date);
  }

  // Format time for API
  static String formatTimeForApi(DateTime time) {
    return DateFormat(_apiTimeFormat).format(time);
  }

  // Format datetime for API
  static String formatDateTimeForApi(DateTime dateTime) {
    return DateFormat(_apiDateTimeFormat).format(dateTime);
  }

  // Parse date from API
  static DateTime? parseDateFromApi(String dateString) {
    try {
      return DateFormat(_apiDateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse datetime from API
  static DateTime? parseDateTimeFromApi(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  // Get relative time (e.g., "2 hours ago", "Tomorrow")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'Yesterday' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Get future relative time
  static String getFutureRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? 'In 1 year' : 'In $years years';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'In 1 month' : 'In $months months';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'Tomorrow' : 'In ${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? 'In 1 hour' : 'In ${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? 'In 1 minute' : 'In ${difference.inMinutes} minutes';
    } else {
      return 'Now';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Get day name (Monday, Tuesday, etc.)
  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  // Get short day name (Mon, Tue, etc.)
  static String getShortDayName(DateTime date) {
    return DateFormat('E').format(date);
  }

  // Get month name (January, February, etc.)
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  // Get short month name (Jan, Feb, etc.)
  static String getShortMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  // Get time slots for booking
  static List<String> getTimeSlots({
    int startHour = 9,
    int endHour = 21,
    int intervalMinutes = 30,
  }) {
    final List<String> timeSlots = [];
    final startTime = DateTime(2023, 1, 1, startHour);
    final endTime = DateTime(2023, 1, 1, endHour);

    DateTime currentTime = startTime;

    while (currentTime.isBefore(endTime)) {
      timeSlots.add(formatTime(currentTime));
      currentTime = currentTime.add(Duration(minutes: intervalMinutes));
    }

    return timeSlots;
  }

  // Get available dates for booking (next 30 days)
  static List<DateTime> getAvailableDates({int days = 30}) {
    final List<DateTime> availableDates = [];
    final today = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = today.add(Duration(days: i));
      // Skip Sundays for salon bookings (business logic)
      if (date.weekday != DateTime.sunday) {
        availableDates.add(date);
      }
    }

    return availableDates;
  }

  // Check if time is within business hours
  static bool isWithinBusinessHours(
      DateTime dateTime, {
        int startHour = 9,
        int endHour = 21,
      }) {
    return dateTime.hour >= startHour && dateTime.hour < endHour;
  }

  // Get booking display text
  static String getBookingDisplayText(DateTime bookingDate) {
    if (isToday(bookingDate)) {
      return 'Today at ${formatTime(bookingDate)}';
    } else if (isTomorrow(bookingDate)) {
      return 'Tomorrow at ${formatTime(bookingDate)}';
    } else {
      return '${formatDate(bookingDate)} at ${formatTime(bookingDate)}';
    }
  }

  // Calculate duration between two times
  static String calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);

    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${hours}h';
      }
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Less than a minute';
    }
  }
}