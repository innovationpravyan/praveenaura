import '../constants/app_constants.dart';
import 'date_utils.dart';

class BookingUtils {
  BookingUtils._();

  // Get booking status color
  static String getBookingStatusColor(String status) {
    switch (status) {
      case AppConstants.pending:
        return '#FF9800'; // Orange
      case AppConstants.confirmed:
        return '#2196F3'; // Blue
      case AppConstants.inProgress:
        return '#9C27B0'; // Purple
      case AppConstants.completed:
        return '#4CAF50'; // Green
      case AppConstants.cancelled:
        return '#F44336'; // Red
      default:
        return '#757575'; // Grey
    }
  }

  // Get booking status display text
  static String getBookingStatusDisplayText(String status) {
    switch (status) {
      case AppConstants.pending:
        return 'Pending Confirmation';
      case AppConstants.confirmed:
        return 'Confirmed';
      case AppConstants.inProgress:
        return 'In Progress';
      case AppConstants.completed:
        return 'Completed';
      case AppConstants.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  // Get booking status icon
  static String getBookingStatusIcon(String status) {
    switch (status) {
      case AppConstants.pending:
        return 'schedule';
      case AppConstants.confirmed:
        return 'check_circle';
      case AppConstants.inProgress:
        return 'play_circle';
      case AppConstants.completed:
        return 'done_all';
      case AppConstants.cancelled:
        return 'cancel';
      default:
        return 'help';
    }
  }

  // Check if booking can be cancelled
  static bool canCancelBooking(String status, DateTime bookingDateTime) {
    if (status == AppConstants.completed || status == AppConstants.cancelled) {
      return false;
    }

    // Can't cancel if booking is within 2 hours
    final now = DateTime.now();
    final timeDifference = bookingDateTime.difference(now);

    return timeDifference.inHours >= 2;
  }

  // Check if booking can be rescheduled
  static bool canRescheduleBooking(String status, DateTime bookingDateTime) {
    if (status == AppConstants.completed || status == AppConstants.cancelled) {
      return false;
    }

    // Can't reschedule if booking is within 4 hours
    final now = DateTime.now();
    final timeDifference = bookingDateTime.difference(now);

    return timeDifference.inHours >= 4;
  }

  // Check if booking can be reviewed
  static bool canReviewBooking(String status) {
    return status == AppConstants.completed;
  }

  // Generate booking reference number
  static String generateBookingReference() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString();
    // Take last 8 digits and add prefix
    return 'AB${timestamp.substring(timestamp.length - 8)}';
  }

  // Calculate booking duration
  static Duration calculateBookingDuration(List<String> serviceIds) {
    // This would normally fetch service durations from database
    // For now, return default duration based on number of services
    final baseDuration = Duration(minutes: 60); // 1 hour base
    final additionalTime = Duration(minutes: serviceIds.length * 30);

    return baseDuration + additionalTime;
  }

  // Get estimated completion time
  static DateTime getEstimatedCompletionTime(
      DateTime startTime,
      List<String> serviceIds,
      ) {
    final duration = calculateBookingDuration(serviceIds);
    return startTime.add(duration);
  }

  // Format booking duration for display
  static String formatBookingDuration(List<String> serviceIds) {
    final duration = calculateBookingDuration(serviceIds);
    return AppDateUtils.calculateDuration(DateTime.now(), DateTime.now().add(duration));
  }

  // Check if booking is upcoming
  static bool isUpcomingBooking(DateTime bookingDateTime) {
    final now = DateTime.now();
    return bookingDateTime.isAfter(now);
  }

  // Check if booking is overdue
  static bool isOverdueBooking(String status, DateTime bookingDateTime) {
    if (status == AppConstants.completed || status == AppConstants.cancelled) {
      return false;
    }

    final now = DateTime.now();
    return bookingDateTime.isBefore(now);
  }

  // Get next available time slots
  static List<String> getNextAvailableTimeSlots(
      DateTime date,
      List<String> bookedSlots,
      ) {
    final allSlots = AppDateUtils.getTimeSlots();
    final now = DateTime.now();

    // Filter out past slots for today
    List<String> availableSlots = allSlots.where((slot) {
      if (!AppDateUtils.isToday(date)) return true;

      // Parse slot time and check if it's in the future
      final slotTime = _parseTimeSlot(slot);
      final slotDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        slotTime.hour,
        slotTime.minute,
      );

      return slotDateTime.isAfter(now.add(Duration(hours: 1))); // 1 hour buffer
    }).toList();

    // Remove already booked slots
    availableSlots.removeWhere((slot) => bookedSlots.contains(slot));

    return availableSlots;
  }

  // Parse time slot string to DateTime
  static DateTime _parseTimeSlot(String timeSlot) {
    // Parse "09:00 AM" format
    final parts = timeSlot.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(2023, 1, 1, hour, minute);
  }

  // Get booking priority based on status and time
  static int getBookingPriority(String status, DateTime bookingDateTime) {
    final now = DateTime.now();

    switch (status) {
      case AppConstants.inProgress:
        return 1; // Highest priority
      case AppConstants.confirmed:
        if (bookingDateTime.difference(now).inHours <= 2) {
          return 2; // High priority for soon bookings
        }
        return 3;
      case AppConstants.pending:
        return 4;
      case AppConstants.completed:
        return 5;
      case AppConstants.cancelled:
        return 6; // Lowest priority
      default:
        return 7;
    }
  }

  // Sort bookings by priority
  static List<T> sortBookingsByPriority<T>(
      List<T> bookings,
      String Function(T) getStatus,
      DateTime Function(T) getDateTime,
      ) {
    bookings.sort((a, b) {
      final priorityA = getBookingPriority(getStatus(a), getDateTime(a));
      final priorityB = getBookingPriority(getStatus(b), getDateTime(b));

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      // If same priority, sort by date/time
      return getDateTime(a).compareTo(getDateTime(b));
    });

    return bookings;
  }

  // Get cancellation fee
  static double getCancellationFee(DateTime bookingDateTime, double bookingAmount) {
    final now = DateTime.now();
    final hoursUntilBooking = bookingDateTime.difference(now).inHours;

    if (hoursUntilBooking >= 24) {
      return 0.0; // Free cancellation 24+ hours before
    } else if (hoursUntilBooking >= 4) {
      return bookingAmount * 0.25; // 25% fee for 4-24 hours before
    } else if (hoursUntilBooking >= 2) {
      return bookingAmount * 0.50; // 50% fee for 2-4 hours before
    } else {
      return bookingAmount; // Full charge for <2 hours before
    }
  }

  // Get refund amount after cancellation
  static double getRefundAmount(DateTime bookingDateTime, double bookingAmount) {
    final cancellationFee = getCancellationFee(bookingDateTime, bookingAmount);
    return bookingAmount - cancellationFee;
  }

  // Validate booking time
  static bool isValidBookingTime(DateTime bookingDateTime) {
    final now = DateTime.now();

    // Must be at least 1 hour in the future
    if (bookingDateTime.difference(now).inHours < 1) {
      return false;
    }

    // Must be within business hours
    if (!AppDateUtils.isWithinBusinessHours(bookingDateTime)) {
      return false;
    }

    // Must not be on Sunday (salon closed)
    if (bookingDateTime.weekday == DateTime.sunday) {
      return false;
    }

    return true;
  }

  // Get booking reminder times
  static List<DateTime> getBookingReminderTimes(DateTime bookingDateTime) {
    return [
      bookingDateTime.subtract(Duration(hours: 24)), // 1 day before
      bookingDateTime.subtract(Duration(hours: 2)),  // 2 hours before
      bookingDateTime.subtract(Duration(minutes: 30)), // 30 minutes before
    ].where((time) => time.isAfter(DateTime.now())).toList();
  }

  // Format booking summary
  static String formatBookingSummary({
    required String salonName,
    required List<String> serviceNames,
    required DateTime bookingDateTime,
    required String serviceType,
  }) {
    final services = serviceNames.length > 2
        ? '${serviceNames.take(2).join(', ')} +${serviceNames.length - 2} more'
        : serviceNames.join(', ');

    final timeText = AppDateUtils.getBookingDisplayText(bookingDateTime);
    final location = serviceType == AppConstants.homeService ? 'at Home' : 'at $salonName';

    return '$services • $timeText • $location';
  }
}