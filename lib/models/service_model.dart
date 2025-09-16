import 'package:equatable/equatable.dart';

class ServiceModel extends Equatable {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    required this.salonId,
    this.images = const [],
    this.subCategory,
    this.originalPrice,
    this.currency = 'INR',
    this.isActive = true,
    this.isPopular = false,
    this.isFeatured = false,
    this.isAvailable = true,
    this.forGender = 'both', // male, female, both
    this.requirements = const [],
    this.benefits = const [],
    this.procedures = const [],
    this.aftercare = const [],
    this.contraindications = const [],
    this.tags = const [],
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalBookings = 0,
    this.maxAdvanceBookingDays = 30,
    this.minAdvanceBookingHours = 2,
    this.cancellationPolicy,
    this.additionalInfo,
    this.preparationTime = 0,
    this.cleanupTime = 0,
    this.skillLevel,
    this.equipmentRequired = const [],
    this.productsUsed = const [],
    this.createdAt,
    this.updatedAt,
    this.lastBookedAt,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int duration; // in minutes
  final String salonId;
  final List<String> images;
  final String? subCategory;
  final double? originalPrice;
  final String currency;
  final bool isActive;
  final bool isPopular;
  final bool isFeatured;
  final bool isAvailable;
  final String forGender;
  final List<String> requirements;
  final List<String> benefits;
  final List<String> procedures;
  final List<String> aftercare;
  final List<String> contraindications;
  final List<String> tags;
  final double rating;
  final int totalReviews;
  final int totalBookings;
  final int maxAdvanceBookingDays;
  final int minAdvanceBookingHours;
  final String? cancellationPolicy;
  final String? additionalInfo;
  final int preparationTime; // in minutes
  final int cleanupTime; // in minutes
  final String? skillLevel; // beginner, intermediate, expert
  final List<String> equipmentRequired;
  final List<String> productsUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastBookedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    price,
    duration,
    salonId,
    images,
    subCategory,
    originalPrice,
    currency,
    isActive,
    isPopular,
    isFeatured,
    isAvailable,
    forGender,
    requirements,
    benefits,
    procedures,
    aftercare,
    contraindications,
    tags,
    rating,
    totalReviews,
    totalBookings,
    maxAdvanceBookingDays,
    minAdvanceBookingHours,
    cancellationPolicy,
    additionalInfo,
    preparationTime,
    cleanupTime,
    skillLevel,
    equipmentRequired,
    productsUsed,
    createdAt,
    updatedAt,
    lastBookedAt,
  ];

  // Computed properties
  String get displayName => name.trim();

  String get formattedPrice => '₹${price.toInt()}';

  String get formattedDuration {
    if (duration < 60) {
      return '${duration}min';
    } else {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}min';
      }
    }
  }

  String get priceWithDuration => '$formattedPrice • $formattedDuration';

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountAmount => hasDiscount ? originalPrice! - price : 0.0;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return ((discountAmount / originalPrice!) * 100).round();
  }

  String get discountText => hasDiscount ? '$discountPercentage% OFF' : '';

  String get primaryImage => images.isNotEmpty
      ? images.first
      : 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=2940';

  List<String> get primaryImages => images.take(3).toList();

  bool get hasMultipleImages => images.length > 1;

  String get ratingText => rating > 0 ? rating.toStringAsFixed(1) : 'New';

  String get reviewsText {
    if (totalReviews == 0) return 'No reviews';
    if (totalReviews == 1) return '1 review';
    return '$totalReviews reviews';
  }

  String get ratingWithReviews => '$ratingText ($reviewsText)';

  bool get hasGoodRating => rating >= 4.0;

  bool get hasExcellentRating => rating >= 4.5;

  int get totalServiceTime => preparationTime + duration + cleanupTime;

  String get formattedTotalTime {
    final total = totalServiceTime;
    if (total < 60) {
      return '${total}min';
    } else {
      final hours = total ~/ 60;
      final minutes = total % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}min';
      }
    }
  }

  List<String> get badges {
    final badges = <String>[];
    if (isPopular) badges.add('Popular');
    if (isFeatured) badges.add('Featured');
    if (hasExcellentRating) badges.add('Top Rated');
    if (hasDiscount) badges.add(discountText);
    if (totalBookings > 500) badges.add('Best Seller');
    return badges;
  }

  String get genderText {
    switch (forGender) {
      case 'male':
        return 'For Men';
      case 'female':
        return 'For Women';
      case 'both':
      default:
        return 'For All';
    }
  }

  bool get hasRequirements => requirements.isNotEmpty;
  bool get hasBenefits => benefits.isNotEmpty;
  bool get hasProcedures => procedures.isNotEmpty;
  bool get hasAftercare => aftercare.isNotEmpty;
  bool get hasContraindications => contraindications.isNotEmpty;
  bool get hasAdditionalInfo => additionalInfo != null && additionalInfo!.isNotEmpty;

  String get popularityText {
    if (totalBookings > 1000) return 'Very Popular';
    if (totalBookings > 500) return 'Popular';
    if (totalBookings > 100) return 'Well Booked';
    if (totalBookings > 0) return 'Booked';
    return 'New Service';
  }

  String get skillLevelText {
    switch (skillLevel) {
      case 'beginner':
        return 'Basic Service';
      case 'intermediate':
        return 'Advanced Service';
      case 'expert':
        return 'Premium Service';
      default:
        return '';
    }
  }

  // Factory constructors
  factory ServiceModel.empty() {
    return ServiceModel(
      id: '',
      name: '',
      description: '',
      category: '',
      price: 0.0,
      duration: 60,
      salonId: '',
      createdAt: DateTime.now(),
    );
  }

  factory ServiceModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ServiceModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      duration: data['duration'] ?? 60,
      salonId: data['salonId'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      subCategory: data['subCategory'],
      originalPrice: data['originalPrice']?.toDouble(),
      currency: data['currency'] ?? 'INR',
      isActive: data['isActive'] ?? true,
      isPopular: data['isPopular'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
      isAvailable: data['isAvailable'] ?? true,
      forGender: data['forGender'] ?? 'both',
      requirements: List<String>.from(data['requirements'] ?? []),
      benefits: List<String>.from(data['benefits'] ?? []),
      procedures: List<String>.from(data['procedures'] ?? []),
      aftercare: List<String>.from(data['aftercare'] ?? []),
      contraindications: List<String>.from(data['contraindications'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      totalBookings: data['totalBookings'] ?? 0,
      maxAdvanceBookingDays: data['maxAdvanceBookingDays'] ?? 30,
      minAdvanceBookingHours: data['minAdvanceBookingHours'] ?? 2,
      cancellationPolicy: data['cancellationPolicy'],
      additionalInfo: data['additionalInfo'],
      preparationTime: data['preparationTime'] ?? 0,
      cleanupTime: data['cleanupTime'] ?? 0,
      skillLevel: data['skillLevel'],
      equipmentRequired: List<String>.from(data['equipmentRequired'] ?? []),
      productsUsed: List<String>.from(data['productsUsed'] ?? []),
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : null,
      lastBookedAt: data['lastBookedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastBookedAt'])
          : null,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'duration': duration,
      'salonId': salonId,
      'images': images,
      'subCategory': subCategory,
      'originalPrice': originalPrice,
      'currency': currency,
      'isActive': isActive,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
      'forGender': forGender,
      'requirements': requirements,
      'benefits': benefits,
      'procedures': procedures,
      'aftercare': aftercare,
      'contraindications': contraindications,
      'tags': tags,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalBookings': totalBookings,
      'maxAdvanceBookingDays': maxAdvanceBookingDays,
      'minAdvanceBookingHours': minAdvanceBookingHours,
      'cancellationPolicy': cancellationPolicy,
      'additionalInfo': additionalInfo,
      'preparationTime': preparationTime,
      'cleanupTime': cleanupTime,
      'skillLevel': skillLevel,
      'equipmentRequired': equipmentRequired,
      'productsUsed': productsUsed,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'lastBookedAt': lastBookedAt?.millisecondsSinceEpoch,
    };
  }

  // Copy with method
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? duration,
    String? salonId,
    List<String>? images,
    String? subCategory,
    double? originalPrice,
    String? currency,
    bool? isActive,
    bool? isPopular,
    bool? isFeatured,
    bool? isAvailable,
    String? forGender,
    List<String>? requirements,
    List<String>? benefits,
    List<String>? procedures,
    List<String>? aftercare,
    List<String>? contraindications,
    List<String>? tags,
    double? rating,
    int? totalReviews,
    int? totalBookings,
    int? maxAdvanceBookingDays,
    int? minAdvanceBookingHours,
    String? cancellationPolicy,
    String? additionalInfo,
    int? preparationTime,
    int? cleanupTime,
    String? skillLevel,
    List<String>? equipmentRequired,
    List<String>? productsUsed,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastBookedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      salonId: salonId ?? this.salonId,
      images: images ?? this.images,
      subCategory: subCategory ?? this.subCategory,
      originalPrice: originalPrice ?? this.originalPrice,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
      forGender: forGender ?? this.forGender,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      procedures: procedures ?? this.procedures,
      aftercare: aftercare ?? this.aftercare,
      contraindications: contraindications ?? this.contraindications,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalBookings: totalBookings ?? this.totalBookings,
      maxAdvanceBookingDays: maxAdvanceBookingDays ?? this.maxAdvanceBookingDays,
      minAdvanceBookingHours: minAdvanceBookingHours ?? this.minAdvanceBookingHours,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      preparationTime: preparationTime ?? this.preparationTime,
      cleanupTime: cleanupTime ?? this.cleanupTime,
      skillLevel: skillLevel ?? this.skillLevel,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      productsUsed: productsUsed ?? this.productsUsed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastBookedAt: lastBookedAt ?? this.lastBookedAt,
    );
  }

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, price: $price, duration: $duration)';
  }
}