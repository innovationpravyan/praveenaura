import 'package:equatable/equatable.dart';

import '../core/constants/app_constants.dart';

// Booking Status Enum
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get value {
    switch (this) {
      case BookingStatus.pending:
        return AppConstants.pending;
      case BookingStatus.confirmed:
        return AppConstants.confirmed;
      case BookingStatus.inProgress:
        return AppConstants.inProgress;
      case BookingStatus.completed:
        return AppConstants.completed;
      case BookingStatus.cancelled:
        return AppConstants.cancelled;
    }
  }

  String get displayText {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending Confirmation';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  static BookingStatus fromString(String value) {
    switch (value) {
      case AppConstants.pending:
        return BookingStatus.pending;
      case AppConstants.confirmed:
        return BookingStatus.confirmed;
      case AppConstants.inProgress:
        return BookingStatus.inProgress;
      case AppConstants.completed:
        return BookingStatus.completed;
      case AppConstants.cancelled:
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}

// Payment Status Enum
enum PaymentStatus {
  pending,
  success,
  failed,
}

extension PaymentStatusExtension on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return AppConstants.paymentPending;
      case PaymentStatus.success:
        return AppConstants.paymentSuccess;
      case PaymentStatus.failed:
        return AppConstants.paymentFailed;
    }
  }

  String get displayText {
    switch (this) {
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.success:
        return 'Payment Successful';
      case PaymentStatus.failed:
        return 'Payment Failed';
    }
  }

  static PaymentStatus fromString(String value) {
    switch (value) {
      case AppConstants.paymentPending:
        return PaymentStatus.pending;
      case AppConstants.paymentSuccess:
        return PaymentStatus.success;
      case AppConstants.paymentFailed:
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending;
    }
  }
}

class BookingModel extends Equatable {
  const BookingModel({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.serviceIds,
    required this.bookingDateTime,
    required this.serviceType,
    required this.status,
    required this.totalAmount,
    this.referenceNumber,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.salonName,
    this.salonAddress,
    this.salonPhone,
    this.serviceNames = const [],
    this.servicePrices = const [],
    this.serviceDurations = const [],
    this.specialRequests,
    this.notes,
    this.address,
    this.latitude,
    this.longitude,
    this.estimatedDuration = 60,
    this.actualStartTime,
    this.actualEndTime,
    this.cancelledAt,
    this.cancellationReason,
    this.cancelledBy,
    this.rescheduleCount = 0,
    this.lastRescheduledAt,
    this.remindersSent = const [],
    this.paymentStatus,
    this.paymentMethod,
    this.paymentId,
    this.refundAmount,
    this.refundId,
    this.subtotal,
    this.discountAmount = 0.0,
    this.taxAmount = 0.0,
    this.convenienceFee = 0.0,
    this.couponCode,
    this.couponDiscount = 0.0,
    this.loyaltyPointsUsed = 0,
    this.loyaltyDiscount = 0.0,
    this.feedbackGiven = false,
    this.rating,
    this.reviewText,
    this.reviewImages = const [],
    this.metadata = const {},
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String salonId;
  final List<String> serviceIds;
  final DateTime bookingDateTime;
  final String serviceType; // salon or home
  final String status; // pending, confirmed, in_progress, completed, cancelled
  final double totalAmount;
  final String? referenceNumber;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? salonName;
  final String? salonAddress;
  final String? salonPhone;
  final List<String> serviceNames;
  final List<double> servicePrices;
  final List<int> serviceDurations;
  final String? specialRequests;
  final String? notes;
  final String? address; // For home service
  final double? latitude;
  final double? longitude;
  final int estimatedDuration;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? cancelledBy; // user, salon, system
  final int rescheduleCount;
  final DateTime? lastRescheduledAt;
  final List<String> remindersSent;
  final String? paymentStatus; // pending, success, failed
  final String? paymentMethod; // card, upi, netbanking, wallet
  final String? paymentId;
  final double? refundAmount;
  final String? refundId;
  final double? subtotal;
  final double discountAmount;
  final double taxAmount;
  final double convenienceFee;
  final String? couponCode;
  final double couponDiscount;
  final int loyaltyPointsUsed;
  final double loyaltyDiscount;
  final bool feedbackGiven;
  final double? rating;
  final String? reviewText;
  final List<String> reviewImages;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  @override
  List<Object?> get props => [
    id,
    userId,
    salonId,
    serviceIds,
    bookingDateTime,
    serviceType,
    status,
    totalAmount,
    referenceNumber,
    customerName,
    customerPhone,
    customerEmail,
    salonName,
    salonAddress,
    salonPhone,
    serviceNames,
    servicePrices,
    serviceDurations,
    specialRequests,
    notes,
    address,
    latitude,
    longitude,
    estimatedDuration,
    actualStartTime,
    actualEndTime,
    cancelledAt,
    cancellationReason,
    cancelledBy,
    rescheduleCount,
    lastRescheduledAt,
    remindersSent,
    paymentStatus,
    paymentMethod,
    paymentId,
    refundAmount,
    refundId,
    subtotal,
    discountAmount,
    taxAmount,
    convenienceFee,
    couponCode,
    couponDiscount,
    loyaltyPointsUsed,
    loyaltyDiscount,
    feedbackGiven,
    rating,
    reviewText,
    reviewImages,
    metadata,
    createdAt,
    updatedAt,
    completedAt,
  ];

  // Computed properties
  String get displayId => referenceNumber ?? id.substring(0, 8).toUpperCase();

  bool get isHomeService => serviceType == AppConstants.homeService;
  bool get isSalonService => serviceType == AppConstants.salonService;

  bool get isPending => status == AppConstants.pending;
  bool get isConfirmed => status == AppConstants.confirmed;
  bool get isInProgress => status == AppConstants.inProgress;
  bool get isCompleted => status == AppConstants.completed;
  bool get isCancelled => status == AppConstants.cancelled;

  bool get canBeCancelled {
    if (isCompleted || isCancelled) return false;
    final now = DateTime.now();
    return bookingDateTime.difference(now).inHours >= 2;
  }

  bool get canBeRescheduled {
    if (isCompleted || isCancelled) return false;
    final now = DateTime.now();
    return bookingDateTime.difference(now).inHours >= 4;
  }

  bool get canBeReviewed => isCompleted && !feedbackGiven;

  bool get isUpcoming {
    final now = DateTime.now();
    return bookingDateTime.isAfter(now) && (isConfirmed || isPending);
  }

  bool get isOverdue {
    if (isCompleted || isCancelled) return false;
    final now = DateTime.now();
    return bookingDateTime.isBefore(now);
  }

  String get statusDisplayText {
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

  String get serviceTypeDisplayText {
    return isHomeService ? 'Home Service' : 'At Salon';
  }

  String get servicesDisplayText {
    if (serviceNames.isEmpty) return 'Services';
    if (serviceNames.length == 1) return serviceNames.first;
    if (serviceNames.length <= 2) return serviceNames.join(', ');
    return '${serviceNames.take(2).join(', ')} +${serviceNames.length - 2} more';
  }

  String get formattedAmount => '₹${totalAmount.toInt()}';

  String get bookingDateText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final bookingDate = DateTime(
      bookingDateTime.year,
      bookingDateTime.month,
      bookingDateTime.day,
    );

    if (bookingDate == today) {
      return 'Today';
    } else if (bookingDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${bookingDateTime.day}/${bookingDateTime.month}/${bookingDateTime.year}';
    }
  }

  String get bookingTimeText {
    final hour = bookingDateTime.hour;
    final minute = bookingDateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String get bookingDateTimeText => '$bookingDateText at $bookingTimeText';

  DateTime get estimatedEndTime => bookingDateTime.add(Duration(minutes: estimatedDuration));

  String get durationText {
    if (estimatedDuration < 60) {
      return '${estimatedDuration}min';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}min';
      }
    }
  }

  bool get hasPaymentInfo => paymentId != null && paymentStatus != null;
  bool get isPaymentPending => paymentStatus == AppConstants.paymentPending;
  bool get isPaymentSuccess => paymentStatus == AppConstants.paymentSuccess;
  bool get isPaymentFailed => paymentStatus == AppConstants.paymentFailed;

  bool get hasDiscount => couponDiscount > 0 || loyaltyDiscount > 0 || discountAmount > 0;

  double get totalDiscount => couponDiscount + loyaltyDiscount + discountAmount;

  bool get hasSpecialRequests => specialRequests != null && specialRequests!.isNotEmpty;
  bool get hasNotes => notes != null && notes!.isNotEmpty;
  bool get hasRating => rating != null && rating! > 0;
  bool get hasReview => reviewText != null && reviewText!.isNotEmpty;

  String get locationDisplayText {
    if (isHomeService) {
      return address ?? 'Home Service';
    } else {
      return salonName ?? 'At Salon';
    }
  }

  String get priorityLevel {
    if (isInProgress) return 'High';
    if (isUpcoming) {
      final hoursUntil = bookingDateTime.difference(DateTime.now()).inHours;
      if (hoursUntil <= 2) return 'High';
      if (hoursUntil <= 24) return 'Medium';
    }
    return 'Normal';
  }

  Duration? get actualServiceDuration {
    if (actualStartTime == null || actualEndTime == null) return null;
    return actualEndTime!.difference(actualStartTime!);
  }

  // Factory constructors
  factory BookingModel.empty() {
    return BookingModel(
      id: '',
      userId: '',
      salonId: '',
      serviceIds: [],
      bookingDateTime: DateTime.now(),
      serviceType: AppConstants.salonService,
      status: AppConstants.pending,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
    );
  }

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookingModel(
      id: id,
      userId: data['userId'] ?? '',
      salonId: data['salonId'] ?? '',
      serviceIds: List<String>.from(data['serviceIds'] ?? []),
      bookingDateTime: DateTime.fromMillisecondsSinceEpoch(data['bookingDateTime']),
      serviceType: data['serviceType'] ?? AppConstants.salonService,
      status: data['status'] ?? AppConstants.pending,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      referenceNumber: data['referenceNumber'],
      customerName: data['customerName'],
      customerPhone: data['customerPhone'],
      customerEmail: data['customerEmail'],
      salonName: data['salonName'],
      salonAddress: data['salonAddress'],
      salonPhone: data['salonPhone'],
      serviceNames: List<String>.from(data['serviceNames'] ?? []),
      servicePrices: List<double>.from(data['servicePrices']?.map((x) => x.toDouble()) ?? []),
      serviceDurations: List<int>.from(data['serviceDurations'] ?? []),
      specialRequests: data['specialRequests'],
      notes: data['notes'],
      address: data['address'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      estimatedDuration: data['estimatedDuration'] ?? 60,
      actualStartTime: data['actualStartTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['actualStartTime'])
          : null,
      actualEndTime: data['actualEndTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['actualEndTime'])
          : null,
      cancelledAt: data['cancelledAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['cancelledAt'])
          : null,
      cancellationReason: data['cancellationReason'],
      cancelledBy: data['cancelledBy'],
      rescheduleCount: data['rescheduleCount'] ?? 0,
      lastRescheduledAt: data['lastRescheduledAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastRescheduledAt'])
          : null,
      remindersSent: List<String>.from(data['remindersSent'] ?? []),
      paymentStatus: data['paymentStatus'],
      paymentMethod: data['paymentMethod'],
      paymentId: data['paymentId'],
      refundAmount: data['refundAmount']?.toDouble(),
      refundId: data['refundId'],
      subtotal: data['subtotal']?.toDouble(),
      discountAmount: (data['discountAmount'] ?? 0.0).toDouble(),
      taxAmount: (data['taxAmount'] ?? 0.0).toDouble(),
      convenienceFee: (data['convenienceFee'] ?? 0.0).toDouble(),
      couponCode: data['couponCode'],
      couponDiscount: (data['couponDiscount'] ?? 0.0).toDouble(),
      loyaltyPointsUsed: data['loyaltyPointsUsed'] ?? 0,
      loyaltyDiscount: (data['loyaltyDiscount'] ?? 0.0).toDouble(),
      feedbackGiven: data['feedbackGiven'] ?? false,
      rating: data['rating']?.toDouble(),
      reviewText: data['reviewText'],
      reviewImages: List<String>.from(data['reviewImages'] ?? []),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : null,
      completedAt: data['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['completedAt'])
          : null,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'salonId': salonId,
      'serviceIds': serviceIds,
      'bookingDateTime': bookingDateTime.millisecondsSinceEpoch,
      'serviceType': serviceType,
      'status': status,
      'totalAmount': totalAmount,
      'referenceNumber': referenceNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'salonName': salonName,
      'salonAddress': salonAddress,
      'salonPhone': salonPhone,
      'serviceNames': serviceNames,
      'servicePrices': servicePrices,
      'serviceDurations': serviceDurations,
      'specialRequests': specialRequests,
      'notes': notes,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'estimatedDuration': estimatedDuration,
      'actualStartTime': actualStartTime?.millisecondsSinceEpoch,
      'actualEndTime': actualEndTime?.millisecondsSinceEpoch,
      'cancelledAt': cancelledAt?.millisecondsSinceEpoch,
      'cancellationReason': cancellationReason,
      'cancelledBy': cancelledBy,
      'rescheduleCount': rescheduleCount,
      'lastRescheduledAt': lastRescheduledAt?.millisecondsSinceEpoch,
      'remindersSent': remindersSent,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'paymentId': paymentId,
      'refundAmount': refundAmount,
      'refundId': refundId,
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'convenienceFee': convenienceFee,
      'couponCode': couponCode,
      'couponDiscount': couponDiscount,
      'loyaltyPointsUsed': loyaltyPointsUsed,
      'loyaltyDiscount': loyaltyDiscount,
      'feedbackGiven': feedbackGiven,
      'rating': rating,
      'reviewText': reviewText,
      'reviewImages': reviewImages,
      'metadata': metadata,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
    };
  }

  // Copy with method
  BookingModel copyWith({
    String? id,
    String? userId,
    String? salonId,
    List<String>? serviceIds,
    DateTime? bookingDateTime,
    String? serviceType,
    String? status,
    double? totalAmount,
    String? referenceNumber,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? salonName,
    String? salonAddress,
    String? salonPhone,
    List<String>? serviceNames,
    List<double>? servicePrices,
    List<int>? serviceDurations,
    String? specialRequests,
    String? notes,
    String? address,
    double? latitude,
    double? longitude,
    int? estimatedDuration,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? cancelledBy,
    int? rescheduleCount,
    DateTime? lastRescheduledAt,
    List<String>? remindersSent,
    String? paymentStatus,
    String? paymentMethod,
    String? paymentId,
    double? refundAmount,
    String? refundId,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? convenienceFee,
    String? couponCode,
    double? couponDiscount,
    int? loyaltyPointsUsed,
    double? loyaltyDiscount,
    bool? feedbackGiven,
    double? rating,
    String? reviewText,
    List<String>? reviewImages,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      salonId: salonId ?? this.salonId,
      serviceIds: serviceIds ?? this.serviceIds,
      bookingDateTime: bookingDateTime ?? this.bookingDateTime,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      salonName: salonName ?? this.salonName,
      salonAddress: salonAddress ?? this.salonAddress,
      salonPhone: salonPhone ?? this.salonPhone,
      serviceNames: serviceNames ?? this.serviceNames,
      servicePrices: servicePrices ?? this.servicePrices,
      serviceDurations: serviceDurations ?? this.serviceDurations,
      specialRequests: specialRequests ?? this.specialRequests,
      notes: notes ?? this.notes,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      rescheduleCount: rescheduleCount ?? this.rescheduleCount,
      lastRescheduledAt: lastRescheduledAt ?? this.lastRescheduledAt,
      remindersSent: remindersSent ?? this.remindersSent,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentId: paymentId ?? this.paymentId,
      refundAmount: refundAmount ?? this.refundAmount,
      refundId: refundId ?? this.refundId,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      couponCode: couponCode ?? this.couponCode,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      loyaltyPointsUsed: loyaltyPointsUsed ?? this.loyaltyPointsUsed,
      loyaltyDiscount: loyaltyDiscount ?? this.loyaltyDiscount,
      feedbackGiven: feedbackGiven ?? this.feedbackGiven,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      reviewImages: reviewImages ?? this.reviewImages,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, status: $status, salonName: $salonName, date: $bookingDateTimeText)';
  }
}