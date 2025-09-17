import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/exceptions/app_exceptions.dart';
import '../core/services/database_service.dart';
import '../core/services/firebase_service.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../providers/auth_provider.dart';

// Booking state
class BookingState {
  const BookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
    this.currentBooking,
  });

  final List<BookingModel> bookings;
  final bool isLoading;
  final String? error;
  final BookingModel? currentBooking;

  BookingState copyWith({
    List<BookingModel>? bookings,
    bool? isLoading,
    String? error,
    BookingModel? currentBooking,
    bool clearError = false,
    bool clearCurrentBooking = false,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      currentBooking: clearCurrentBooking ? null : (currentBooking ?? this.currentBooking),
    );
  }
}

// Booking notifier
class BookingNotifier extends Notifier<BookingState> {
  FirebaseService? _firebaseService;
  DatabaseService? _databaseService;

  @override
  BookingState build() {
    _firebaseService = ref.read(firebaseServiceProvider);
    _databaseService = ref.read(databaseServiceProvider);
    _loadUserBookings();
    return const BookingState();
  }

  // Load user bookings
  Future<void> _loadUserBookings() async {
    final authState = ref.read(authProvider);
    if (authState.user == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final bookings = await _getUserBookings(authState.user!.uid);
      state = state.copyWith(
        bookings: bookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load bookings: ${e.toString()}',
      );
    }
  }

  // Create new booking
  Future<BookingModel?> createBooking({
    required String salonId,
    required List<String> serviceIds,
    required DateTime bookingDateTime,
    required String serviceType, // 'salon' or 'home'
    String? specialInstructions,
    String? address, // For home service
  }) async {
    final authState = ref.read(authProvider);
    if (authState.user == null) {
      throw AuthException('Please login to book appointments', 'not-authenticated');
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Calculate total price and duration from services
      final services = await _getServicesByIds(serviceIds);
      final totalAmount = services.fold(0.0, (sum, service) => sum + service.price);
      final totalDuration = services.fold(0, (sum, service) => sum + service.duration);

      // Create booking model
      final booking = BookingModel(
        id: '', // Will be set by Firestore
        userId: authState.user!.uid,
        salonId: salonId,
        serviceIds: serviceIds,
        bookingDateTime: bookingDateTime,
        serviceType: serviceType,
        totalAmount: totalAmount,
        estimatedDuration: totalDuration,
        status: 'pending',
        paymentStatus: 'pending',
        specialRequests: specialInstructions,
        address: address,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      final savedBooking = await _saveBooking(booking);

      // Update state
      final updatedBookings = [...state.bookings, savedBooking];
      state = state.copyWith(
        bookings: updatedBookings,
        currentBooking: savedBooking,
        isLoading: false,
      );

      return savedBooking;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create booking: ${e.toString()}',
      );
      throw BusinessException('Failed to create booking', 'booking-creation-failed');
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _updateBookingInFirestore(bookingId, {'status': status});

      // Update local state
      final updatedBookings = state.bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();

      state = state.copyWith(
        bookings: updatedBookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update booking: ${e.toString()}',
      );
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId, String reason) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _updateBookingInFirestore(bookingId, {
        'status': 'cancelled',
        'cancellationReason': reason,
        'cancelledAt': DateTime.now().toIso8601String(),
      });

      // Update local state
      final updatedBookings = state.bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            status: 'cancelled',
            cancellationReason: reason,
            cancelledAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();

      state = state.copyWith(
        bookings: updatedBookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel booking: ${e.toString()}',
      );
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(String bookingId, String paymentStatus, {
    String? paymentId,
    String? paymentMethod,
  }) async {
    try {
      final updateData = {
        'paymentStatus': paymentStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (paymentId != null) {
        updateData['paymentId'] = paymentId;
      }
      if (paymentMethod != null) {
        updateData['paymentMethod'] = paymentMethod;
      }

      await _updateBookingInFirestore(bookingId, updateData);

      // Update local state
      final updatedBookings = state.bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            paymentStatus: paymentStatus,
            paymentId: paymentId ?? booking.paymentId,
            paymentMethod: paymentMethod ?? booking.paymentMethod,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();

      state = state.copyWith(bookings: updatedBookings);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update payment status: ${e.toString()}',
      );
    }
  }

  // Get booking by ID
  BookingModel? getBookingById(String bookingId) {
    try {
      return state.bookings.firstWhere((booking) => booking.id == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Get upcoming bookings
  List<BookingModel> getUpcomingBookings() {
    final now = DateTime.now();
    return state.bookings
        .where((booking) =>
            booking.bookingDateTime.isAfter(now) &&
            booking.status != 'cancelled')
        .toList()
      ..sort((a, b) => a.bookingDateTime.compareTo(b.bookingDateTime));
  }

  // Get past bookings
  List<BookingModel> getPastBookings() {
    final now = DateTime.now();
    return state.bookings
        .where((booking) => booking.bookingDateTime.isBefore(now))
        .toList()
      ..sort((a, b) => b.bookingDateTime.compareTo(a.bookingDateTime));
  }

  // Get bookings by status
  List<BookingModel> getBookingsByStatus(String status) {
    return state.bookings
        .where((booking) => booking.status == status)
        .toList()
      ..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // Clear current booking
  void clearCurrentBooking() {
    state = state.copyWith(clearCurrentBooking: true);
  }

  // Refresh bookings
  Future<void> refreshBookings() async {
    await _loadUserBookings();
  }

  // Check if time slot is available
  Future<bool> isTimeSlotAvailable(
    String salonId,
    DateTime bookingDateTime,
    int duration,
  ) async {
    try {
      // Get all bookings for the salon on that date
      final existingBookings = await _getSalonBookingsForDate(salonId, bookingDateTime);

      // Check for conflicts
      final appointmentEnd = bookingDateTime.add(Duration(minutes: duration));

      for (final booking in existingBookings) {
        if (booking.status == 'cancelled') continue;

        final bookingEnd = booking.bookingDateTime.add(
          Duration(minutes: booking.estimatedDuration),
        );

        // Check for overlap
        if (bookingDateTime.isBefore(bookingEnd) &&
            appointmentEnd.isAfter(booking.bookingDateTime)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false; // Assume not available if error
    }
  }

  // Get available time slots for a date
  Future<List<String>> getAvailableTimeSlots(
    String salonId,
    DateTime date,
    int serviceDurationMinutes,
  ) async {
    try {
      const businessHours = {
        'start': '09:00',
        'end': '21:00',
        'slotDuration': 30, // minutes
      };

      final allSlots = <String>[];
      var currentTime = DateTime(
        date.year,
        date.month,
        date.day,
        9, // 9 AM
        0,
      );
      final endTime = DateTime(
        date.year,
        date.month,
        date.day,
        21, // 9 PM
        0,
      );

      // Generate all possible slots
      while (currentTime.isBefore(endTime)) {
        allSlots.add(_formatTime(currentTime));
        currentTime = currentTime.add(const Duration(minutes: 30));
      }

      // Get existing bookings for the date
      final existingBookings = await _getSalonBookingsForDate(salonId, date);

      // Filter out unavailable slots
      final availableSlots = <String>[];

      for (final timeSlot in allSlots) {
        final slotDateTime = _parseTimeSlot(date, timeSlot);
        if (await isTimeSlotAvailable(salonId, slotDateTime, serviceDurationMinutes)) {
          availableSlots.add(timeSlot);
        }
      }

      return availableSlots;
    } catch (e) {
      return [];
    }
  }

  // Helper methods
  Future<List<BookingModel>> _getUserBookings(String userId) async {
    try {
      return await _databaseService!.getUserBookings(userId);
    } catch (e) {
      return [];
    }
  }

  Future<List<ServiceModel>> _getServicesByIds(List<String> serviceIds) async {
    try {
      final services = <ServiceModel>[];
      for (final serviceId in serviceIds) {
        final service = await _databaseService!.getServiceById(serviceId);
        if (service != null) {
          services.add(service);
        }
      }
      return services;
    } catch (e) {
      return [];
    }
  }

  Future<BookingModel> _saveBooking(BookingModel booking) async {
    try {
      return await _databaseService!.createBooking(booking);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateBookingInFirestore(String bookingId, Map<String, dynamic> updateData) async {
    try {
      final booking = await _databaseService!.getBookingById(bookingId);
      if (booking != null) {
        final updatedBooking = booking.copyWith(
          status: updateData['status'] ?? booking.status,
          paymentStatus: updateData['paymentStatus'] ?? booking.paymentStatus,
          paymentId: updateData['paymentId'] ?? booking.paymentId,
          paymentMethod: updateData['paymentMethod'] ?? booking.paymentMethod,
          cancellationReason: updateData['cancellationReason'] ?? booking.cancellationReason,
          cancelledAt: updateData['cancelledAt'] != null
            ? DateTime.parse(updateData['cancelledAt'])
            : booking.cancelledAt,
          updatedAt: DateTime.now(),
        );

        await _databaseService!.updateBooking(updatedBooking);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookingModel>> _getSalonBookingsForDate(String salonId, DateTime date) async {
    try {
      return await _databaseService!.getSalonBookingsForDate(salonId, date);
    } catch (e) {
      return [];
    }
  }

  DateTime _parseTimeSlot(DateTime date, String timeSlot) {
    final parts = timeSlot.split(' ');
    final timeParts = parts[0].split(':');
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;

    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

}

// Providers
final bookingProvider = NotifierProvider<BookingNotifier, BookingState>(() {
  return BookingNotifier();
});

// Convenience providers
final upcomingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingState = ref.watch(bookingProvider);
  final now = DateTime.now();
  return bookingState.bookings
      .where((booking) =>
          booking.bookingDateTime.isAfter(now) &&
          booking.status != 'cancelled')
      .toList()
    ..sort((a, b) => a.bookingDateTime.compareTo(b.bookingDateTime));
});

final pastBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingState = ref.watch(bookingProvider);
  final now = DateTime.now();
  return bookingState.bookings
      .where((booking) => booking.bookingDateTime.isBefore(now))
      .toList()
    ..sort((a, b) => b.bookingDateTime.compareTo(a.bookingDateTime));
});

final pendingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingState = ref.watch(bookingProvider);
  return bookingState.bookings
      .where((booking) => booking.status == 'pending')
      .toList()
    ..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
});