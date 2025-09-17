import 'package:equatable/equatable.dart';

import '../core/constants/app_constants.dart';

// Working hours model for salon
class WorkingHours extends Equatable {
  const WorkingHours({
    required this.day,
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  final String day; // monday, tuesday, etc.
  final bool isOpen;
  final String? openTime; // "09:00"
  final String? closeTime; // "21:00"
  final String? breakStartTime; // "13:00" (lunch break start)
  final String? breakEndTime; // "14:00" (lunch break end)

  @override
  List<Object?> get props => [
    day,
    isOpen,
    openTime,
    closeTime,
    breakStartTime,
    breakEndTime,
  ];

  String get displayTime {
    if (!isOpen) return 'Closed';
    if (openTime == null || closeTime == null) return 'Hours not set';

    String time = '$openTime - $closeTime';
    if (breakStartTime != null && breakEndTime != null) {
      time += ' (Break: $breakStartTime - $breakEndTime)';
    }
    return time;
  }

  bool get hasBreak => breakStartTime != null && breakEndTime != null;

  // Factory method to create from map
  factory WorkingHours.fromMap(Map<String, dynamic> map) {
    return WorkingHours(
      day: map['day'] ?? '',
      isOpen: map['isOpen'] ?? false,
      openTime: map['openTime'],
      closeTime: map['closeTime'],
      breakStartTime: map['breakStartTime'],
      breakEndTime: map['breakEndTime'],
    );
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
      'breakStartTime': breakStartTime,
      'breakEndTime': breakEndTime,
    };
  }

  // Copy with method
  WorkingHours copyWith({
    String? day,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    String? breakStartTime,
    String? breakEndTime,
  }) {
    return WorkingHours(
      day: day ?? this.day,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStartTime: breakStartTime ?? this.breakStartTime,
      breakEndTime: breakEndTime ?? this.breakEndTime,
    );
  }

  @override
  String toString() {
    return 'WorkingHours(day: $day, isOpen: $isOpen, openTime: $openTime, closeTime: $closeTime)';
  }
}

class SalonModel extends Equatable {
  const SalonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.ownerId,
    this.images = const [],
    this.services = const [],
    this.amenities = const [],
    this.categories = const [],
    this.workingHours = const {},
    this.socialMedia = const {},
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalBookings = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.isPremium = false,
    this.isVerified = false,
    this.licenseNumber,
    this.gstNumber,
    this.establishedYear,
    this.website,
    this.minPrice,
    this.maxPrice,
    this.avgServiceTime = 60,
    this.specializations = const [],
    this.awards = const [],
    this.certifications = const [],
    this.createdAt,
    this.updatedAt,
    this.lastActiveAt,
  });

  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final String ownerId;
  final List<String> images;
  final List<String> services; // Service IDs
  final List<String> amenities;
  final List<String> categories;
  final Map<String, WorkingHours> workingHours; // day -> WorkingHours
  final Map<String, String> socialMedia; // platform -> handle
  final double rating;
  final int totalReviews;
  final int totalBookings;
  final bool isActive;
  final bool isFeatured;
  final bool isPremium;
  final bool isVerified;
  final String? licenseNumber;
  final String? gstNumber;
  final int? establishedYear;
  final String? website;
  final double? minPrice;
  final double? maxPrice;
  final int avgServiceTime; // in minutes
  final List<String> specializations;
  final List<String> awards;
  final List<String> certifications;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActiveAt;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    city,
    state,
    pincode,
    latitude,
    longitude,
    phoneNumber,
    email,
    ownerId,
    images,
    services,
    amenities,
    categories,
    workingHours,
    socialMedia,
    rating,
    totalReviews,
    totalBookings,
    isActive,
    isFeatured,
    isPremium,
    isVerified,
    licenseNumber,
    gstNumber,
    establishedYear,
    website,
    minPrice,
    maxPrice,
    avgServiceTime,
    specializations,
    awards,
    certifications,
    createdAt,
    updatedAt,
    lastActiveAt,
  ];

  // Computed properties
  String get displayName => name.trim();

  String get shortAddress => '$city, $state';

  String get fullAddress => '$address, $city, $state $pincode';

  List<String> get primaryImages => images.take(3).toList();

  String get primaryImage => images.isNotEmpty
      ? images.first
      : 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=2940';

  bool get hasMultipleImages => images.length > 1;

  String get ratingText => rating > 0 ? rating.toStringAsFixed(1) : 'New';

  String get reviewsText {
    if (totalReviews == 0) return 'No reviews yet';
    if (totalReviews == 1) return '1 review';
    return '$totalReviews reviews';
  }

  String get ratingWithReviews => '$ratingText ($reviewsText)';

  bool get hasGoodRating => rating >= 4.0;

  bool get hasExcellentRating => rating >= 4.5;

  String get priceRange {
    if (minPrice == null || maxPrice == null) return 'Price on request';
    if (minPrice == maxPrice) return '₹${minPrice!.toInt()}';
    return '₹${minPrice!.toInt()} - ₹${maxPrice!.toInt()}';
  }

  String get experienceText {
    if (establishedYear == null) return '';
    final years = DateTime.now().year - establishedYear!;
    if (years <= 0) return 'New';
    if (years == 1) return '1 year of experience';
    return '$years years of experience';
  }

  bool get isNew => DateTime.now().difference(createdAt ?? DateTime.now()).inDays < 30;

  bool get isRecentlyActive {
    if (lastActiveAt == null) return false;
    final difference = DateTime.now().difference(lastActiveAt!);
    return difference.inHours < 48; // Active in the last 2 days
  }

  bool get hasSocialLinks => socialMedia.isNotEmpty;

  bool get hasWebsite => website != null && website!.isNotEmpty;

  bool get hasLicense => licenseNumber != null && licenseNumber!.isNotEmpty;

  bool get hasGST => gstNumber != null && gstNumber!.isNotEmpty;

  bool get hasCertifications => certifications.isNotEmpty;

  bool get hasAwards => awards.isNotEmpty;

  // Check if salon is currently open based on working hours
  bool get isOpen {
    if (!isActive) return false;

    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);

    if (!workingHours.containsKey(currentDay)) return false;

    final todayHours = workingHours[currentDay];
    if (todayHours == null || !todayHours.isOpen) return false;

    // If no specific times are set, assume open
    if (todayHours.openTime == null || todayHours.closeTime == null) return true;

    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Simple time comparison (assumes 24-hour format)
    return currentTime.compareTo(todayHours.openTime!) >= 0 &&
           currentTime.compareTo(todayHours.closeTime!) <= 0;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Monday';
    }
  }
}
