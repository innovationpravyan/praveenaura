import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  // Date formatters
  static final DateFormat _dayFormat = DateFormat('dd');
  static final DateFormat _monthFormat = DateFormat('MMM');
  static final DateFormat _yearFormat = DateFormat('yyyy');
  static final DateFormat _dayNameFormat = DateFormat('EEE');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _fullDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _fullDateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  // Get day from date
  static String getDay(DateTime date) {
    return _dayFormat.format(date);
  }

  // Get month from date
  static String getMonth(DateTime date) {
    return _monthFormat.format(date);
  }

  // Get year from date
  static String getYear(DateTime date) {
    return _yearFormat.format(date);
  }

  // Get day name from date
  static String getDayName(DateTime date) {
    return _dayNameFormat.format(date);
  }

  // Get time from date
  static String getTime(DateTime date) {
    return _timeFormat.format(date);
  }

  // Format date for display
  static String formatDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  // Format date and time for display
  static String formatDateTime(DateTime date) {
    return _fullDateTimeFormat.format(date);
  }

  // Format date for database storage
  static String formatForDatabase(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  // Parse date from database format
  static DateTime parseFromDatabase(String dateString) {
    return DateTime.parse(dateString);
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  // Get relative date string (Today, Tomorrow, Yesterday, or date)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return formatDate(date);
    }
  }

  // Get time difference in human readable format
  static String getTimeDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Get age from date of birth
  static int getAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  // Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Get start of week (Monday)
  static DateTime getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return getStartOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  // Get end of week (Sunday)
  static DateTime getEndOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return getEndOfDay(date.add(Duration(days: daysToSunday)));
  }

  // Get start of month
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  // Add business days to date (excluding weekends)
  static DateTime addBusinessDays(DateTime date, int businessDays) {
    var result = date;
    var daysAdded = 0;

    while (daysAdded < businessDays) {
      result = result.add(const Duration(days: 1));

      // Skip weekends (Saturday = 6, Sunday = 7)
      if (result.weekday != DateTime.saturday && result.weekday != DateTime.sunday) {
        daysAdded++;
      }
    }

    return result;
  }

  // Check if date is a weekend
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  // Check if date is a weekday
  static bool isWeekday(DateTime date) {
    return !isWeekend(date);
  }

  // Get next business day
  static DateTime getNextBusinessDay(DateTime date) {
    var nextDay = date.add(const Duration(days: 1));

    while (isWeekend(nextDay)) {
      nextDay = nextDay.add(const Duration(days: 1));
    }

    return nextDay;
  }

  // Get days between two dates
  static int getDaysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  // Get months between two dates
  static int getMonthsBetween(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 + (endDate.month - startDate.month);
  }

  // Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Get formatted duration
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Parse time string to DateTime (today with given time)
  static DateTime parseTimeString(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // Get available time slots for booking
  static List<String> getAvailableTimeSlots({
    required DateTime date,
    required String startTime,
    required String endTime,
    required Duration slotDuration,
    List<String> bookedSlots = const [],
  }) {
    final slots = <String>[];
    final start = parseTimeString(startTime);
    final end = parseTimeString(endTime);

    var current = start;

    while (current.isBefore(end)) {
      final timeString = getTime(current);

      if (!bookedSlots.contains(timeString)) {
        slots.add(timeString);
      }

      current = current.add(slotDuration);
    }

    return slots;
  }

  // Calculate duration between two DateTime objects and return as formatted string
  static String calculateDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    return formatDuration(duration);
  }

  // Get all available time slots (standard business hours)
  static List<String> getTimeSlots({
    String startTime = '09:00',
    String endTime = '21:00',
    Duration slotDuration = const Duration(minutes: 30),
  }) {
    final slots = <String>[];
    final start = parseTimeString(startTime);
    final end = parseTimeString(endTime);

    var current = start;

    while (current.isBefore(end)) {
      slots.add(getTime(current));
      current = current.add(slotDuration);
    }

    return slots;
  }

  // Check if time is within business hours
  static bool isWithinBusinessHours(
    DateTime dateTime, {
    String startTime = '09:00',
    String endTime = '21:00',
  }) {
    final timeString = getTime(dateTime);
    final time = parseTimeString(timeString);
    final businessStart = parseTimeString(startTime);
    final businessEnd = parseTimeString(endTime);

    return (time.isAtSameMomentAs(businessStart) || time.isAfter(businessStart)) &&
           time.isBefore(businessEnd);
  }

  // Get booking display text with relative date and time
  static String getBookingDisplayText(DateTime bookingDateTime) {
    final dateText = getRelativeDateString(bookingDateTime);
    final timeText = getTime(bookingDateTime);

    if (dateText == 'Today' || dateText == 'Tomorrow' || dateText == 'Yesterday') {
      return '$dateText at $timeText';
    } else {
      return '$dateText, $timeText';
    }
  }
}