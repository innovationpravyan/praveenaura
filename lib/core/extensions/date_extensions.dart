import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Format date with default format
  String get formatted => DateFormat('MMM dd, yyyy').format(this);

  // Format time with default format
  String get timeFormatted => DateFormat('hh:mm a').format(this);

  // Format datetime with default format
  String get dateTimeFormatted => DateFormat('MMM dd, yyyy • hh:mm a').format(this);

  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Check if date is in current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    return isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
        isBefore(endOfWeek.add(Duration(days: 1)));
  }

  // Check if date is in current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  // Check if date is in current year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  // Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  // Get start of week (Monday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  // Get end of week (Sunday)
  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  // Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  // Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  // Get start of year
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  // Get end of year
  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999);
  }

  // Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

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

  // Get future relative time string
  String get futureRelativeTime {
    final now = DateTime.now();
    final difference = this.difference(now);

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

  // Get smart date display
  String get smartFormat {
    if (isToday) return 'Today at ${timeFormatted}';
    if (isTomorrow) return 'Tomorrow at ${timeFormatted}';
    if (isYesterday) return 'Yesterday at ${timeFormatted}';
    if (isThisWeek) return '${DateFormat('EEEE').format(this)} at ${timeFormatted}';
    if (isThisYear) return '${DateFormat('MMM dd').format(this)} at ${timeFormatted}';
    return dateTimeFormatted;
  }

  // Get day name
  String get dayName => DateFormat('EEEE').format(this);

  // Get short day name
  String get shortDayName => DateFormat('E').format(this);

  // Get month name
  String get monthName => DateFormat('MMMM').format(this);

  // Get short month name
  String get shortMonthName => DateFormat('MMM').format(this);

  // Check if it's a weekend
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  // Check if it's a weekday
  bool get isWeekday => !isWeekend;

  // Get age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - year;

    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }

    return age;
  }

  // Check if date is in the past
  bool get isInPast => isBefore(DateTime.now());

  // Check if date is in the future
  bool get isInFuture => isAfter(DateTime.now());

  // Get quarter of the year
  int get quarter => ((month - 1) / 3).floor() + 1;

  // Get days until this date
  int get daysUntil => difference(DateTime.now().startOfDay).inDays;

  // Get days since this date
  int get daysSince => DateTime.now().startOfDay.difference(this.startOfDay).inDays;

  // Check if it's a leap year
  bool get isLeapYear {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
  }

  // Get number of days in current month
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  // Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(Duration(days: 1));
      if (result.isWeekday) {
        addedDays++;
      }
    }

    return result;
  }

  // Subtract business days (excluding weekends)
  DateTime subtractBusinessDays(int days) {
    DateTime result = this;
    int subtractedDays = 0;

    while (subtractedDays < days) {
      result = result.subtract(Duration(days: 1));
      if (result.isWeekday) {
        subtractedDays++;
      }
    }

    return result;
  }

  // Get next business day
  DateTime get nextBusinessDay {
    DateTime next = add(Duration(days: 1));
    while (next.isWeekend) {
      next = next.add(Duration(days: 1));
    }
    return next;
  }

  // Get previous business day
  DateTime get previousBusinessDay {
    DateTime previous = subtract(Duration(days: 1));
    while (previous.isWeekend) {
      previous = previous.subtract(Duration(days: 1));
    }
    return previous;
  }

  // Check if time is within business hours
  bool isWithinBusinessHours({int startHour = 9, int endHour = 17}) {
    return hour >= startHour && hour < endHour && isWeekday;
  }

  // Get time of day category
  String get timeOfDayCategory {
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    if (hour >= 17 && hour < 21) return 'Evening';
    return 'Night';
  }

  // Get timezone offset string
  String get timezoneOffset {
    final offset = timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);
    final sign = hours >= 0 ? '+' : '-';

    return 'GMT$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.abs().toString().padLeft(2, '0')}';
  }

  // Format for API (ISO 8601)
  String get apiFormat => toIso8601String();

  // Format for filename (safe characters)
  String get filenameFormat => DateFormat('yyyy-MM-dd_HH-mm-ss').format(this);

  // Get ordinal day (1st, 2nd, 3rd, etc.)
  String get ordinalDay {
    final d = day;
    if (d >= 11 && d <= 13) return '${d}th';

    switch (d % 10) {
      case 1: return '${d}st';
      case 2: return '${d}nd';
      case 3: return '${d}rd';
      default: return '${d}th';
    }
  }

  // Check if two dates are on the same day
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  // Check if two dates are in the same week
  bool isSameWeek(DateTime other) {
    final thisStart = startOfWeek;
    final otherStart = other.startOfWeek;
    return thisStart.isSameDay(otherStart);
  }

  // Check if two dates are in the same month
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  // Check if two dates are in the same year
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  // Get booking-specific formatting
  String get bookingFormat {
    if (isToday) return 'Today at ${timeFormatted}';
    if (isTomorrow) return 'Tomorrow at ${timeFormatted}';
    return '${formatted} at ${timeFormatted}';
  }

  // Round to nearest minute
  DateTime get roundedToMinute {
    return DateTime(year, month, day, hour, minute);
  }

  // Round to nearest hour
  DateTime get roundedToHour {
    return DateTime(year, month, day, hour);
  }

  // Get duration string until this date
  String get durationUntil {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours.remainder(24)}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }

  // Check if it's a valid booking time (business logic)
  bool get isValidBookingTime {
    // Must be in the future
    if (!isInFuture) return false;

    // Must be at least 1 hour from now
    if (difference(DateTime.now()).inHours < 1) return false;

    // Must be during business hours (9 AM to 9 PM)
    if (hour < 9 || hour >= 21) return false;

    // Must not be on Sunday
    if (weekday == DateTime.sunday) return false;

    return true;
  }

  // Get next valid booking slot
  DateTime get nextValidBookingSlot {
    DateTime next = DateTime(year, month, day, 9); // Start at 9 AM

    // If today and past business hours, move to next day
    if (isToday && hour >= 20) {
      next = add(Duration(days: 1));
      next = DateTime(next.year, next.month, next.day, 9);
    }

    // Skip Sunday
    if (next.weekday == DateTime.sunday) {
      next = next.add(Duration(days: 1));
    }

    // Ensure at least 1 hour from now
    final now = DateTime.now();
    if (next.difference(now).inHours < 1) {
      next = now.add(Duration(hours: 1));
      // Round up to next half hour
      final minutes = next.minute;
      if (minutes <= 30) {
        next = DateTime(next.year, next.month, next.day, next.hour, 30);
      } else {
        next = DateTime(next.year, next.month, next.day, next.hour + 1, 0);
      }
    }

    return next;
  }

  // Format for calendar display
  String get calendarFormat {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';
    if (isYesterday) return 'Yesterday';
    if (isThisWeek) return shortDayName;
    if (isThisYear) return DateFormat('MMM dd').format(this);
    return DateFormat('MMM dd, yyyy').format(this);
  }

  // Get time slots for this date
  List<DateTime> getTimeSlots({
    int startHour = 9,
    int endHour = 21,
    int intervalMinutes = 30,
  }) {
    final List<DateTime> slots = [];
    DateTime current = DateTime(year, month, day, startHour);
    final end = DateTime(year, month, day, endHour);

    while (current.isBefore(end)) {
      slots.add(current);
      current = current.add(Duration(minutes: intervalMinutes));
    }

    return slots;
  }
}

extension NullableDateTimeExtensions on DateTime? {
  // Safe formatting for nullable DateTime
  String get safeFormatted {
    if (this == null) return 'Not set';
    return this!.formatted;
  }

  String get safeTimeFormatted {
    if (this == null) return 'Not set';
    return this!.timeFormatted;
  }

  String get safeDateTimeFormatted {
    if (this == null) return 'Not set';
    return this!.dateTimeFormatted;
  }

  String get safeRelativeTime {
    if (this == null) return 'Not set';
    return this!.relativeTime;
  }

  bool get isNullOrPast {
    if (this == null) return true;
    return this!.isInPast;
  }

  bool get isNullOrFuture {
    if (this == null) return true;
    return this!.isInFuture;
  }
}