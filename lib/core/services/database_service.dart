import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking_model.dart';
import '../../models/salon_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _salonsCollection => _firestore.collection('salons');
  CollectionReference get _servicesCollection => _firestore.collection('services');
  CollectionReference get _bookingsCollection => _firestore.collection('bookings');
  CollectionReference get _notificationsCollection => _firestore.collection('notifications');
  CollectionReference get _reviewsCollection => _firestore.collection('reviews');
  CollectionReference get _categoriesCollection => _firestore.collection('categories');
  CollectionReference get _promosCollection => _firestore.collection('promotions');

  // User operations
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel(
          uid: doc.id,
          email: data['email'] ?? '',
          displayName: data['displayName'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          photoURL: data['photoURL'],
          gender: data['gender'] ?? 'female',
          dateOfBirth: data['dateOfBirth'] != null
              ? _parseDateTime(data['dateOfBirth'])
              : null,
          address: data['address'],
          city: data['city'],
          state: data['state'],
          pincode: data['pincode'],
          isEmailVerified: data['isEmailVerified'] ?? false,
          preferences: data['preferences'] != null
              ? UserPreferences.fromMap(data['preferences'])
              : null,
          createdAt: data['createdAt'] != null
              ? _parseDateTime(data['createdAt'])
              : DateTime.now(),
          updatedAt: data['updatedAt'] != null
              ? _parseDateTime(data['updatedAt'])
              : DateTime.now(),
          lastLoginAt: data['lastLoginAt'] != null
              ? _parseDateTime(data['lastLoginAt'])
              : null,
        );
      }
      return null;
    } catch (e) {
      developer.log('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toFirestore());
      developer.log('User created successfully: ${user.uid}');
    } catch (e) {
      developer.log('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).update(user.toFirestore());
      developer.log('User updated successfully: ${user.uid}');
    } catch (e) {
      developer.log('Error updating user: $e');
      rethrow;
    }
  }

  // Get all salons from Firestore
  Future<List<SalonModel>> getAllSalons() async {
    try {
      final snapshot = await _salonsCollection.where('isActive', isEqualTo: true).get();

      if (snapshot.docs.isEmpty) {
        developer.log('No salons found in Firestore, initializing with sample data...');
        await _initializeSampleData();
        // Retry after initialization
        final retrySnapshot = await _salonsCollection.where('isActive', isEqualTo: true).get();
        return retrySnapshot.docs.map((doc) => _salonFromFirestore(doc)).toList();
      }

      return snapshot.docs.map((doc) => _salonFromFirestore(doc)).toList();
    } catch (e) {
      developer.log('Error getting salons from Firestore: $e');
      // Fallback to mock data if Firestore fails
      return _getMockSalons();
    }
  }

  Future<SalonModel?> getSalonById(String salonId) async {
    final salons = await getAllSalons();
    try {
      return salons.firstWhere((salon) => salon.id == salonId);
    } catch (e) {
      return null;
    }
  }

  Future<List<SalonModel>> searchSalons(String query) async {
    final salons = await getAllSalons();
    return salons.where((salon) =>
      salon.name.toLowerCase().contains(query.toLowerCase()) ||
      salon.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<List<SalonModel>> getNearbySalons(double latitude, double longitude, double radius) async {
    final salons = await getAllSalons();
    return salons.take(5).toList(); // Mock implementation
  }

  Future<List<ServiceModel>> getAllServices() async {
    try {
      final snapshot = await _servicesCollection.where('isActive', isEqualTo: true).get();

      if (snapshot.docs.isEmpty) {
        developer.log('No services found in Firestore, using sample data...');
        // Services should be initialized with salons in _initializeSampleData
        return _getMockServices();
      }

      return snapshot.docs.map((doc) => _serviceFromFirestore(doc)).toList();
    } catch (e) {
      developer.log('Error getting services from Firestore: $e');
      // Fallback to mock data if Firestore fails
      return _getMockServices();
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    final services = await getAllServices();
    try {
      return services.firstWhere((service) => service.id == serviceId);
    } catch (e) {
      return null;
    }
  }

  Future<List<ServiceModel>> getServicesBySalon(String salonId) async {
    final services = await getAllServices();
    return services.where((service) => service.salonId == salonId).toList();
  }

  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    final services = await getAllServices();
    return services.where((service) => service.category == category).toList();
  }

  Future<List<ServiceModel>> searchServices(String query) async {
    final services = await getAllServices();
    return services.where((service) =>
      service.name.toLowerCase().contains(query.toLowerCase()) ||
      service.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Booking operations
  Future<BookingModel> createBooking(BookingModel booking) async {
    final bookingWithId = booking.copyWith(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
    );
    // In real implementation, save to Firestore
    return bookingWithId;
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    // Return mock data for now
    return [];
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    // Mock implementation
    return null;
  }

  Future<void> updateBooking(BookingModel booking) async {
    // Mock implementation
  }

  Future<List<BookingModel>> getSalonBookingsForDate(String salonId, DateTime date) async {
    // Mock implementation
    return [];
  }

  // Notification operations
  Future<void> saveNotification(Map<String, dynamic> notification) async {
    // Mock implementation
  }

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    // Return empty list for now
    return [];
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    // Mock implementation
  }

  Future<void> deleteNotification(String notificationId) async {
    // Mock implementation
  }

  // Manual data upload to Firestore
  Future<void> uploadSampleDataToFirestore() async {
    developer.log('Starting manual upload of sample data to Firestore...');
    try {
      await _initializeSampleData();
      developer.log('Manual data upload completed successfully');
    } catch (e) {
      developer.log('Error during manual data upload: $e');
      rethrow;
    }
  }

  // Force clear and re-upload all data
  Future<void> resetAndUploadData() async {
    developer.log('Resetting Firestore data and uploading fresh sample data...');
    try {
      // Delete all existing documents from all collections
      final collections = [
        _usersCollection,
        _salonsCollection,
        _servicesCollection,
        _bookingsCollection,
        _notificationsCollection,
        _reviewsCollection,
        _categoriesCollection,
        _promosCollection,
      ];

      for (final collection in collections) {
        final snapshots = await collection.get();
        for (final doc in snapshots.docs) {
          await doc.reference.delete();
        }
        developer.log('Cleared ${collection.id} collection (${snapshots.docs.length} documents)');
      }

      developer.log('All existing data cleared. Uploading fresh sample data...');

      // Upload fresh sample data
      await _initializeSampleData();

      developer.log('Data reset and upload completed successfully');
    } catch (e) {
      developer.log('Error during data reset and upload: $e');
      rethrow;
    }
  }

  // Wishlist operations
  Future<Map<String, List<String>>> getUserWishlist(String userId) async {
    return {'salons': [], 'services': []};
  }

  Future<void> addToWishlist(String userId, String itemId, String type) async {
    // Mock implementation
  }

  Future<void> removeFromWishlist(String userId, String itemId, String type) async {
    // Mock implementation
  }

  // Helper method to convert Firestore document to SalonModel
  SalonModel _salonFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SalonModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      pincode: data['pincode'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      ownerId: data['ownerId'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      services: List<String>.from(data['services'] ?? []),
      amenities: List<String>.from(data['amenities'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      workingHours: _parseWorkingHours(data['workingHours'] ?? {}),
      socialMedia: Map<String, String>.from(data['socialMedia'] ?? {}),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      totalBookings: data['totalBookings'] ?? 0,
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      isPremium: data['isPremium'] ?? false,
      isVerified: data['isVerified'] ?? false,
      licenseNumber: data['licenseNumber'],
      gstNumber: data['gstNumber'],
      establishedYear: data['establishedYear'],
      website: data['website'],
      minPrice: data['minPrice']?.toDouble(),
      maxPrice: data['maxPrice']?.toDouble(),
      avgServiceTime: data['avgServiceTime'] ?? 60,
      specializations: List<String>.from(data['specializations'] ?? []),
      awards: List<String>.from(data['awards'] ?? []),
      certifications: List<String>.from(data['certifications'] ?? []),
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
      lastActiveAt: _parseDateTime(data['lastActiveAt']),
    );
  }

  // Helper method to parse working hours from Firestore
  Map<String, WorkingHours> _parseWorkingHours(Map<String, dynamic> data) {
    final workingHours = <String, WorkingHours>{};

    data.forEach((day, dayData) {
      if (dayData is Map<String, dynamic>) {
        workingHours[day] = WorkingHours(
          day: dayData['day'] ?? day,
          isOpen: dayData['isOpen'] ?? false,
          openTime: dayData['openTime'],
          closeTime: dayData['closeTime'],
          breakStartTime: dayData['breakStartTime'],
          breakEndTime: dayData['breakEndTime'],
        );
      }
    });

    return workingHours;
  }

  // Initialize sample data in Firestore
  Future<void> _initializeSampleData() async {
    developer.log('Initializing comprehensive sample data for all collections...');

    try {
      final sampleSalons = _getMockSalons();
      final sampleServices = _getMockServices();
      final sampleUsers = _getMockUsers();
      final sampleBookings = _getMockBookings();
      final sampleNotifications = _getMockNotifications();
      final sampleReviews = _getMockReviews();
      final sampleCategories = _getMockCategories();
      final samplePromotions = _getMockPromotions();

      // Add users to Firestore
      for (final user in sampleUsers) {
        await _usersCollection.doc(user.uid).set(user.toFirestore());
        developer.log('Added user: ${user.displayName}');
      }

      // Add salons to Firestore
      for (final salon in sampleSalons) {
        await _salonsCollection.doc(salon.id).set(_salonToFirestore(salon));
        developer.log('Added salon: ${salon.name}');
      }

      // Add services to Firestore
      for (final service in sampleServices) {
        await _servicesCollection.doc(service.id).set(_serviceToFirestore(service));
        developer.log('Added service: ${service.name}');
      }

      // Add bookings to Firestore
      for (final booking in sampleBookings) {
        await _bookingsCollection.doc(booking.id).set(_bookingToFirestore(booking));
        developer.log('Added booking: ${booking.id}');
      }

      // Add notifications to Firestore
      for (final notification in sampleNotifications) {
        await _notificationsCollection.doc(notification['id']).set(notification);
        developer.log('Added notification: ${notification['title']}');
      }

      // Add reviews to Firestore
      for (final review in sampleReviews) {
        await _reviewsCollection.doc(review['id']).set(review);
        developer.log('Added review: ${review['id']}');
      }

      // Add categories to Firestore
      for (final category in sampleCategories) {
        await _categoriesCollection.doc(category['id']).set(category);
        developer.log('Added category: ${category['name']}');
      }

      // Add promotions to Firestore
      for (final promo in samplePromotions) {
        await _promosCollection.doc(promo['id']).set(promo);
        developer.log('Added promotion: ${promo['title']}');
      }

      developer.log('All sample data initialized successfully!');
      developer.log('📊 Data Summary:');
      developer.log('  - ${sampleUsers.length} users');
      developer.log('  - ${sampleSalons.length} salons');
      developer.log('  - ${sampleServices.length} services');
      developer.log('  - ${sampleBookings.length} bookings');
      developer.log('  - ${sampleNotifications.length} notifications');
      developer.log('  - ${sampleReviews.length} reviews');
      developer.log('  - ${sampleCategories.length} categories');
      developer.log('  - ${samplePromotions.length} promotions');
    } catch (e) {
      developer.log('Error initializing sample data: $e');
      rethrow;
    }
  }

  // Helper method to convert SalonModel to Firestore data
  Map<String, dynamic> _salonToFirestore(SalonModel salon) {
    return {
      'name': salon.name,
      'description': salon.description,
      'address': salon.address,
      'city': salon.city,
      'state': salon.state,
      'pincode': salon.pincode,
      'latitude': salon.latitude,
      'longitude': salon.longitude,
      'phoneNumber': salon.phoneNumber,
      'email': salon.email,
      'ownerId': salon.ownerId,
      'images': salon.images,
      'services': salon.services,
      'amenities': salon.amenities,
      'categories': salon.categories,
      'workingHours': _workingHoursToFirestore(salon.workingHours),
      'socialMedia': salon.socialMedia,
      'rating': salon.rating,
      'totalReviews': salon.totalReviews,
      'totalBookings': salon.totalBookings,
      'isActive': salon.isActive,
      'isFeatured': salon.isFeatured,
      'isPremium': salon.isPremium,
      'isVerified': salon.isVerified,
      'licenseNumber': salon.licenseNumber,
      'gstNumber': salon.gstNumber,
      'establishedYear': salon.establishedYear,
      'website': salon.website,
      'minPrice': salon.minPrice,
      'maxPrice': salon.maxPrice,
      'avgServiceTime': salon.avgServiceTime,
      'specializations': salon.specializations,
      'awards': salon.awards,
      'certifications': salon.certifications,
      'createdAt': salon.createdAt?.toIso8601String(),
      'updatedAt': salon.updatedAt?.toIso8601String(),
      'lastActiveAt': salon.lastActiveAt?.toIso8601String(),
    };
  }

  // Helper method to convert working hours to Firestore
  Map<String, dynamic> _workingHoursToFirestore(Map<String, WorkingHours> workingHours) {
    final data = <String, dynamic>{};

    workingHours.forEach((day, hours) {
      data[day] = {
        'day': hours.day,
        'isOpen': hours.isOpen,
        'openTime': hours.openTime,
        'closeTime': hours.closeTime,
        'breakStartTime': hours.breakStartTime,
        'breakEndTime': hours.breakEndTime,
      };
    });

    return data;
  }

  // Helper method to convert ServiceModel to Firestore data
  Map<String, dynamic> _serviceToFirestore(ServiceModel service) {
    return {
      'name': service.name,
      'description': service.description,
      'price': service.price,
      'originalPrice': service.originalPrice,
      'duration': service.duration,
      'category': service.category,
      'salonId': service.salonId,
      'images': service.images,
      'isActive': service.isActive,
      'isPopular': service.isPopular,
      'isFeatured': service.isFeatured,
      'tags': service.tags,
      'rating': service.rating,
      'totalBookings': service.totalBookings,
      'totalReviews': service.totalReviews,
      'createdAt': service.createdAt?.toIso8601String(),
      'updatedAt': service.updatedAt?.toIso8601String(),
    };
  }

  // Helper method to convert BookingModel to Firestore data
  Map<String, dynamic> _bookingToFirestore(BookingModel booking) {
    return {
      'userId': booking.userId,
      'salonId': booking.salonId,
      'serviceIds': booking.serviceIds,
      'bookingDateTime': booking.bookingDateTime.toIso8601String(),
      'serviceType': booking.serviceType,
      'totalAmount': booking.totalAmount,
      'estimatedDuration': booking.estimatedDuration,
      'status': booking.status,
      'paymentStatus': booking.paymentStatus,
      'paymentId': booking.paymentId,
      'paymentMethod': booking.paymentMethod,
      'specialRequests': booking.specialRequests,
      'address': booking.address,
      'cancellationReason': booking.cancellationReason,
      'cancelledAt': booking.cancelledAt?.toIso8601String(),
      'createdAt': booking.createdAt?.toIso8601String(),
      'updatedAt': booking.updatedAt?.toIso8601String(),
    };
  }

  // Helper method to convert Firestore document to ServiceModel
  ServiceModel _serviceFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ServiceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      originalPrice: (data['originalPrice'] ?? 0.0).toDouble(),
      duration: data['duration'] ?? 60,
      category: data['category'] ?? '',
      salonId: data['salonId'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      isActive: data['isActive'] ?? true,
      isPopular: data['isPopular'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalBookings: data['totalBookings'] ?? 0,
      totalReviews: data['totalReviews'] ?? 0,
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  // Helper method to parse different timestamp formats
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        // Handle Unix timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is Timestamp) {
        // Handle Firestore Timestamp
        return value.toDate();
      } else {
        developer.log('Unknown timestamp format: ${value.runtimeType}');
        return null;
      }
    } catch (e) {
      developer.log('Error parsing timestamp: $value - $e');
      return null;
    }
  }

  // Mock data methods
  List<SalonModel> _getMockSalons() {
    final workingHours = {
      'Monday': const WorkingHours(day: 'Monday', isOpen: true, openTime: '09:00', closeTime: '21:00'),
      'Tuesday': const WorkingHours(day: 'Tuesday', isOpen: true, openTime: '09:00', closeTime: '21:00'),
      'Wednesday': const WorkingHours(day: 'Wednesday', isOpen: true, openTime: '09:00', closeTime: '21:00'),
      'Thursday': const WorkingHours(day: 'Thursday', isOpen: true, openTime: '09:00', closeTime: '21:00'),
      'Friday': const WorkingHours(day: 'Friday', isOpen: true, openTime: '09:00', closeTime: '21:00'),
      'Saturday': const WorkingHours(day: 'Saturday', isOpen: true, openTime: '10:00', closeTime: '20:00'),
      'Sunday': const WorkingHours(day: 'Sunday', isOpen: true, openTime: '10:00', closeTime: '18:00'),
    };

    return [
      SalonModel(
        id: 'salon_1',
        name: 'Elegance Beauty Salon',
        description: 'Premium beauty services for modern women',
        address: '123 Mall Road, Cantonment',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221001',
        latitude: 25.3176,
        longitude: 82.9739,
        phoneNumber: '+91 9876543210',
        email: 'info@elegancebeauty.com',
        ownerId: 'owner_1',
        images: ['https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=2940'],
        services: ['service_1', 'service_2', 'service_3'],
        amenities: ['AC', 'WiFi', 'Parking', 'Card Payment'],
        categories: ['Hair Care', 'Skin Care', 'Makeup'],
        rating: 4.8,
        totalReviews: 156,
        totalBookings: 892,
        isActive: true,
        isFeatured: true,
        workingHours: workingHours,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),
      SalonModel(
        id: 'salon_2',
        name: 'Glamour Studio',
        description: 'Professional styling and beauty treatments',
        address: '456 Godowlia Road',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221001',
        latitude: 25.3189,
        longitude: 82.9723,
        phoneNumber: '+91 9876543211',
        email: 'contact@glamourstudio.com',
        ownerId: 'owner_2',
        images: ['https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=2940'],
        services: ['service_4', 'service_5', 'service_6'],
        amenities: ['AC', 'WiFi', 'Parking'],
        categories: ['Hair Care', 'Nail Care'],
        rating: 4.6,
        totalReviews: 98,
        totalBookings: 567,
        isActive: true,
        isFeatured: false,
        workingHours: workingHours,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
      ),
      SalonModel(
        id: 'salon_3',
        name: 'Royal Beauty Parlour',
        description: 'Traditional and modern beauty services',
        address: '789 Lanka Road',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221005',
        latitude: 25.3123,
        longitude: 82.9845,
        phoneNumber: '+91 9876543212',
        email: 'info@royalbeauty.com',
        ownerId: 'owner_3',
        images: ['https://images.unsplash.com/photo-1600334129128-685c5582fd35?q=80&w=2940'],
        services: ['service_7', 'service_8'],
        amenities: ['AC', 'Parking'],
        categories: ['Skin Care', 'Hair Care'],
        rating: 4.4,
        totalReviews: 234,
        totalBookings: 1245,
        isActive: true,
        isFeatured: true,
        workingHours: workingHours,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
      ),
      SalonModel(
        id: 'salon_4',
        name: 'Shine Beauty Center',
        description: 'Complete beauty solutions under one roof',
        address: '321 Sigra Road',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221010',
        latitude: 25.2867,
        longitude: 82.9734,
        phoneNumber: '+91 9876543213',
        email: 'hello@shinebeauty.com',
        ownerId: 'owner_4',
        images: ['https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=2940'],
        services: ['service_9', 'service_10'],
        amenities: ['AC', 'WiFi', 'Parking', 'Card Payment'],
        categories: ['Hair Care', 'Makeup', 'Nail Care'],
        rating: 4.7,
        totalReviews: 178,
        totalBookings: 734,
        isActive: true,
        isFeatured: false,
        workingHours: workingHours,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now(),
      ),
      SalonModel(
        id: 'salon_5',
        name: 'Belle Femme Salon',
        description: 'Luxury beauty and wellness center',
        address: '654 Orderly Bazaar',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221002',
        latitude: 25.3234,
        longitude: 82.9678,
        phoneNumber: '+91 9876543214',
        email: 'info@bellefemme.com',
        ownerId: 'owner_5',
        images: ['https://images.unsplash.com/photo-1519415943484-9fa1873496d4?q=80&w=2940'],
        services: ['service_11', 'service_12'],
        amenities: ['AC', 'WiFi', 'Spa', 'Parking'],
        categories: ['Skin Care', 'Spa', 'Hair Care'],
        rating: 4.9,
        totalReviews: 89,
        totalBookings: 456,
        isActive: true,
        isFeatured: true,
        workingHours: workingHours,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<ServiceModel> _getMockServices() {
    return [
      // Elegance Beauty Salon services
      ServiceModel(
        id: 'service_1',
        name: 'Hair Cut & Styling',
        description: 'Professional hair cutting and styling with latest trends',
        price: 800.0,
        originalPrice: 1000.0,
        duration: 60,
        category: 'Hair Care',
        salonId: 'salon_1',
        isActive: true,
        isPopular: true,
        images: ['https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=2940'],
        rating: 4.8,
        totalBookings: 245,
        totalReviews: 89,
        tags: ['trending', 'popular'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_2',
        name: 'Facial Treatment',
        description: 'Deep cleansing and rejuvenating facial treatment',
        price: 1200.0,
        originalPrice: 1500.0,
        duration: 90,
        category: 'Skin Care',
        salonId: 'salon_1',
        isActive: true,
        isPopular: true,
        images: ['https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=2940'],
        rating: 4.9,
        totalBookings: 178,
        totalReviews: 65,
        tags: ['relaxing', 'rejuvenating'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_3',
        name: 'Bridal Makeup',
        description: 'Complete bridal makeup package with pre-wedding trial',
        price: 5000.0,
        originalPrice: 6000.0,
        duration: 180,
        category: 'Makeup',
        salonId: 'salon_1',
        isActive: true,
        isFeatured: true,
        images: ['https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=2940'],
        rating: 4.7,
        totalBookings: 45,
        totalReviews: 23,
        tags: ['bridal', 'special'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Glamour Studio services
      ServiceModel(
        id: 'service_4',
        name: 'Hair Color & Highlights',
        description: 'Professional hair coloring with premium products',
        price: 2500.0,
        originalPrice: 3000.0,
        duration: 120,
        category: 'Hair Care',
        salonId: 'salon_2',
        isActive: true,
        isPopular: true,
        images: ['https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=2940'],
        rating: 4.6,
        totalBookings: 134,
        totalReviews: 78,
        tags: ['trendy', 'color'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_5',
        name: 'Manicure & Pedicure',
        description: 'Complete nail care with gel polish',
        price: 1500.0,
        originalPrice: 1800.0,
        duration: 75,
        category: 'Nail Care',
        salonId: 'salon_2',
        isActive: true,
        images: ['https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=2940'],
        rating: 4.5,
        totalBookings: 98,
        totalReviews: 45,
        tags: ['nail-art', 'gel'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_6',
        name: 'Hair Spa Treatment',
        description: 'Intensive hair spa with oil massage and steam',
        price: 1800.0,
        originalPrice: 2200.0,
        duration: 90,
        category: 'Hair Care',
        salonId: 'salon_2',
        isActive: true,
        images: ['https://images.unsplash.com/photo-1522336284037-91f7da073525?q=80&w=2940'],
        rating: 4.8,
        totalBookings: 156,
        totalReviews: 89,
        tags: ['relaxing', 'nourishing'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Royal Beauty Parlour services
      ServiceModel(
        id: 'service_7',
        name: 'Anti-Aging Facial',
        description: 'Advanced anti-aging facial with collagen treatment',
        price: 2000.0,
        originalPrice: 2500.0,
        duration: 120,
        category: 'Skin Care',
        salonId: 'salon_3',
        isActive: true,
        isFeatured: true,
        images: ['https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=2940'],
        rating: 4.7,
        totalBookings: 89,
        totalReviews: 34,
        tags: ['anti-aging', 'premium'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_8',
        name: 'Hair Straightening',
        description: 'Professional hair straightening with keratin treatment',
        price: 4000.0,
        originalPrice: 5000.0,
        duration: 180,
        category: 'Hair Care',
        salonId: 'salon_3',
        isActive: true,
        images: ['https://images.unsplash.com/photo-1559599101-f09722fb4948?q=80&w=2940'],
        rating: 4.4,
        totalBookings: 67,
        totalReviews: 28,
        tags: ['straightening', 'keratin'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Shine Beauty Center services
      ServiceModel(
        id: 'service_9',
        name: 'Party Makeup',
        description: 'Glamorous party makeup for special occasions',
        price: 2500.0,
        originalPrice: 3000.0,
        duration: 90,
        category: 'Makeup',
        salonId: 'salon_4',
        isActive: true,
        isPopular: true,
        images: ['https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=2940'],
        rating: 4.6,
        totalBookings: 112,
        totalReviews: 56,
        tags: ['party', 'glamorous'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_10',
        name: 'Nail Art Design',
        description: 'Creative nail art with custom designs',
        price: 800.0,
        originalPrice: 1000.0,
        duration: 45,
        category: 'Nail Care',
        salonId: 'salon_4',
        isActive: true,
        images: ['https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=2940'],
        rating: 4.8,
        totalBookings: 156,
        totalReviews: 78,
        tags: ['art', 'creative'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Belle Femme Salon services
      ServiceModel(
        id: 'service_11',
        name: 'Premium Spa Package',
        description: 'Luxury spa experience with full body massage and facial',
        price: 6000.0,
        originalPrice: 7500.0,
        duration: 240,
        category: 'Spa',
        salonId: 'salon_5',
        isActive: true,
        isFeatured: true,
        images: ['https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=2940'],
        rating: 4.9,
        totalBookings: 45,
        totalReviews: 23,
        tags: ['luxury', 'spa', 'massage'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 'service_12',
        name: 'Hydrafacial Treatment',
        description: 'Advanced hydrafacial with instant glow',
        price: 3500.0,
        originalPrice: 4000.0,
        duration: 60,
        category: 'Skin Care',
        salonId: 'salon_5',
        isActive: true,
        isPopular: true,
        images: ['https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=2940'],
        rating: 4.8,
        totalBookings: 89,
        totalReviews: 45,
        tags: ['hydrafacial', 'glow'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Mock Users Data
  List<UserModel> _getMockUsers() {
    return [
      UserModel(
        uid: 'user_1',
        email: 'priya.sharma@gmail.com',
        displayName: 'Priya Sharma',
        phoneNumber: '+91 9876543210',
        photoURL: 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150',
        gender: 'female',
        dateOfBirth: DateTime(1995, 6, 15),
        address: '123 Green Park',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221001',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      UserModel(
        uid: 'user_2',
        email: 'aisha.khan@gmail.com',
        displayName: 'Aisha Khan',
        phoneNumber: '+91 9876543211',
        photoURL: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        gender: 'female',
        dateOfBirth: DateTime(1992, 3, 22),
        address: '456 Mall Road',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221002',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      UserModel(
        uid: 'user_3',
        email: 'kavya.patel@gmail.com',
        displayName: 'Kavya Patel',
        phoneNumber: '+91 9876543212',
        photoURL: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
        gender: 'female',
        dateOfBirth: DateTime(1988, 11, 8),
        address: '789 Sigra Road',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221010',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      UserModel(
        uid: 'user_4',
        email: 'riya.gupta@gmail.com',
        displayName: 'Riya Gupta',
        phoneNumber: '+91 9876543213',
        photoURL: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        gender: 'female',
        dateOfBirth: DateTime(1990, 7, 14),
        address: '321 Lanka Road',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221005',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      UserModel(
        uid: 'user_5',
        email: 'sneha.singh@gmail.com',
        displayName: 'Sneha Singh',
        phoneNumber: '+91 9876543214',
        photoURL: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        gender: 'female',
        dateOfBirth: DateTime(1993, 12, 3),
        address: '654 Godowlia',
        city: 'Varanasi',
        state: 'Uttar Pradesh',
        pincode: '221001',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  // Mock Bookings Data
  List<BookingModel> _getMockBookings() {
    final now = DateTime.now();
    return [
      BookingModel(
        id: 'booking_1',
        userId: 'user_1',
        salonId: 'salon_1',
        serviceIds: ['service_1', 'service_2'],
        bookingDateTime: now.add(const Duration(days: 2, hours: 10)),
        serviceType: 'salon',
        totalAmount: 2000.0,
        estimatedDuration: 150,
        status: 'confirmed',
        paymentStatus: 'paid',
        paymentId: 'pay_abc123',
        paymentMethod: 'upi',
        specialRequests: 'Please use organic products',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: 'booking_2',
        userId: 'user_2',
        salonId: 'salon_2',
        serviceIds: ['service_4'],
        bookingDateTime: now.add(const Duration(days: 5, hours: 14)),
        serviceType: 'salon',
        totalAmount: 2500.0,
        estimatedDuration: 120,
        status: 'pending',
        paymentStatus: 'pending',
        specialRequests: 'First time customer',
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      BookingModel(
        id: 'booking_3',
        userId: 'user_3',
        salonId: 'salon_3',
        serviceIds: ['service_7'],
        bookingDateTime: now.subtract(const Duration(days: 10)),
        serviceType: 'salon',
        totalAmount: 2000.0,
        estimatedDuration: 120,
        status: 'completed',
        paymentStatus: 'paid',
        paymentId: 'pay_xyz789',
        paymentMethod: 'card',
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      BookingModel(
        id: 'booking_4',
        userId: 'user_4',
        salonId: 'salon_1',
        serviceIds: ['service_3'],
        bookingDateTime: now.add(const Duration(days: 7, hours: 16)),
        serviceType: 'home',
        totalAmount: 5000.0,
        estimatedDuration: 180,
        status: 'confirmed',
        paymentStatus: 'paid',
        paymentId: 'pay_def456',
        paymentMethod: 'wallet',
        address: '321 Lanka Road, Varanasi',
        specialRequests: 'Bridal makeup for wedding',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      BookingModel(
        id: 'booking_5',
        userId: 'user_5',
        salonId: 'salon_5',
        serviceIds: ['service_11'],
        bookingDateTime: now.subtract(const Duration(days: 5)),
        serviceType: 'salon',
        totalAmount: 6000.0,
        estimatedDuration: 240,
        status: 'completed',
        paymentStatus: 'paid',
        paymentId: 'pay_ghi789',
        paymentMethod: 'upi',
        specialRequests: 'Relaxing spa day',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  // Mock Notifications Data
  List<Map<String, dynamic>> _getMockNotifications() {
    final now = DateTime.now();
    return [
      {
        'id': 'notif_1',
        'userId': 'user_1',
        'title': 'Booking Confirmed',
        'body': 'Your appointment at Elegance Beauty Salon is confirmed for tomorrow at 10:00 AM',
        'type': 'booking',
        'data': {
          'bookingId': 'booking_1',
          'salonId': 'salon_1',
        },
        'isRead': false,
        'createdAt': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'notif_2',
        'userId': 'user_2',
        'title': 'Special Offer',
        'body': '20% off on all hair treatments this weekend! Book now.',
        'type': 'promotion',
        'data': {
          'promoCode': 'HAIR20',
          'category': 'Hair Care',
        },
        'isRead': true,
        'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'notif_3',
        'userId': 'user_3',
        'title': 'Appointment Reminder',
        'body': 'Reminder: Your spa appointment is tomorrow at 2:00 PM',
        'type': 'reminder',
        'data': {
          'bookingId': 'booking_3',
          'salonId': 'salon_5',
        },
        'isRead': false,
        'createdAt': now.subtract(const Duration(hours: 12)).toIso8601String(),
      },
      {
        'id': 'notif_4',
        'userId': 'user_4',
        'title': 'Payment Successful',
        'body': 'Payment of ₹5000 for bridal makeup package completed successfully',
        'type': 'payment',
        'data': {
          'bookingId': 'booking_4',
          'amount': 5000,
          'paymentId': 'pay_def456',
        },
        'isRead': true,
        'createdAt': now.subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'id': 'notif_5',
        'userId': 'user_5',
        'title': 'Review Request',
        'body': 'How was your spa experience? Please rate and review.',
        'type': 'review',
        'data': {
          'bookingId': 'booking_5',
          'salonId': 'salon_5',
        },
        'isRead': false,
        'createdAt': now.subtract(const Duration(days: 4)).toIso8601String(),
      },
    ];
  }

  // Mock Reviews Data
  List<Map<String, dynamic>> _getMockReviews() {
    final now = DateTime.now();
    return [
      {
        'id': 'review_1',
        'userId': 'user_1',
        'salonId': 'salon_1',
        'bookingId': 'booking_1',
        'serviceIds': ['service_1', 'service_2'],
        'rating': 5.0,
        'comment': 'Excellent service! The staff was very professional and the results were amazing.',
        'images': ['https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=500'],
        'isVerified': true,
        'helpfulCount': 12,
        'createdAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 7)).toIso8601String(),
      },
      {
        'id': 'review_2',
        'userId': 'user_2',
        'salonId': 'salon_2',
        'bookingId': 'booking_2',
        'serviceIds': ['service_4'],
        'rating': 4.0,
        'comment': 'Good hair coloring service. Happy with the results, will come back.',
        'images': [],
        'isVerified': true,
        'helpfulCount': 8,
        'createdAt': now.subtract(const Duration(days: 15)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 15)).toIso8601String(),
      },
      {
        'id': 'review_3',
        'userId': 'user_3',
        'salonId': 'salon_5',
        'bookingId': 'booking_5',
        'serviceIds': ['service_11'],
        'rating': 5.0,
        'comment': 'Best spa experience ever! Very relaxing and rejuvenating. Highly recommended.',
        'images': ['https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500'],
        'isVerified': true,
        'helpfulCount': 25,
        'createdAt': now.subtract(const Duration(days: 3)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'id': 'review_4',
        'userId': 'user_4',
        'salonId': 'salon_3',
        'serviceIds': ['service_7'],
        'rating': 4.5,
        'comment': 'Great anti-aging facial. Skin feels much better and looks younger.',
        'images': [],
        'isVerified': true,
        'helpfulCount': 6,
        'createdAt': now.subtract(const Duration(days: 12)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 12)).toIso8601String(),
      },
      {
        'id': 'review_5',
        'userId': 'user_5',
        'salonId': 'salon_4',
        'serviceIds': ['service_9'],
        'rating': 4.8,
        'comment': 'Perfect party makeup! Got so many compliments. Thank you!',
        'images': ['https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=500'],
        'isVerified': true,
        'helpfulCount': 18,
        'createdAt': now.subtract(const Duration(days: 20)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 20)).toIso8601String(),
      },
    ];
  }

  // Mock Categories Data
  List<Map<String, dynamic>> _getMockCategories() {
    return [
      {
        'id': 'cat_1',
        'name': 'Hair Care',
        'description': 'Complete hair care services including cutting, styling, coloring, and treatments',
        'icon': 'hair_salon',
        'image': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=500',
        'isActive': true,
        'isPopular': true,
        'sortOrder': 1,
        'serviceCount': 4,
        'createdAt': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      },
      {
        'id': 'cat_2',
        'name': 'Skin Care',
        'description': 'Professional skin care treatments and facials for all skin types',
        'icon': 'face',
        'image': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=500',
        'isActive': true,
        'isPopular': true,
        'sortOrder': 2,
        'serviceCount': 3,
        'createdAt': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      },
      {
        'id': 'cat_3',
        'name': 'Makeup',
        'description': 'Professional makeup services for all occasions',
        'icon': 'palette',
        'image': 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=500',
        'isActive': true,
        'isPopular': true,
        'sortOrder': 3,
        'serviceCount': 2,
        'createdAt': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      },
      {
        'id': 'cat_4',
        'name': 'Nail Care',
        'description': 'Complete nail care services including manicures, pedicures, and nail art',
        'icon': 'nail_salon',
        'image': 'https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=500',
        'isActive': true,
        'isPopular': false,
        'sortOrder': 4,
        'serviceCount': 2,
        'createdAt': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      },
      {
        'id': 'cat_5',
        'name': 'Spa',
        'description': 'Relaxing spa treatments and wellness services',
        'icon': 'spa',
        'image': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500',
        'isActive': true,
        'isPopular': true,
        'sortOrder': 5,
        'serviceCount': 1,
        'createdAt': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      },
    ];
  }

  // Mock Promotions Data
  List<Map<String, dynamic>> _getMockPromotions() {
    final now = DateTime.now();
    return [
      {
        'id': 'promo_1',
        'title': 'First Time Customer Discount',
        'description': 'Get 30% off on your first booking at any salon',
        'code': 'FIRST30',
        'discountType': 'percentage',
        'discountValue': 30.0,
        'minOrderAmount': 500.0,
        'maxDiscountAmount': 1000.0,
        'validFrom': now.subtract(const Duration(days: 30)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 60)).toIso8601String(),
        'isActive': true,
        'isGlobal': true,
        'applicableCategories': ['Hair Care', 'Skin Care', 'Makeup', 'Nail Care', 'Spa'],
        'applicableSalons': [],
        'usageLimit': 100,
        'usedCount': 45,
        'image': 'https://images.unsplash.com/photo-1607344645866-009c7d0f2e8d?q=80&w=500',
        'createdAt': now.subtract(const Duration(days: 30)).toIso8601String(),
      },
      {
        'id': 'promo_2',
        'title': 'Weekend Hair Special',
        'description': '20% off on all hair services during weekends',
        'code': 'WEEKEND20',
        'discountType': 'percentage',
        'discountValue': 20.0,
        'minOrderAmount': 800.0,
        'maxDiscountAmount': 500.0,
        'validFrom': now.subtract(const Duration(days: 7)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 30)).toIso8601String(),
        'isActive': true,
        'isGlobal': false,
        'applicableCategories': ['Hair Care'],
        'applicableSalons': ['salon_1', 'salon_2'],
        'usageLimit': 50,
        'usedCount': 23,
        'image': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=500',
        'createdAt': now.subtract(const Duration(days: 7)).toIso8601String(),
      },
      {
        'id': 'promo_3',
        'title': 'Spa Package Deal',
        'description': 'Book any spa package and get a free facial',
        'code': 'SPAFREE',
        'discountType': 'fixed',
        'discountValue': 1500.0,
        'minOrderAmount': 5000.0,
        'maxDiscountAmount': 1500.0,
        'validFrom': now.subtract(const Duration(days: 15)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 45)).toIso8601String(),
        'isActive': true,
        'isGlobal': false,
        'applicableCategories': ['Spa'],
        'applicableSalons': ['salon_5'],
        'usageLimit': 20,
        'usedCount': 8,
        'image': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500',
        'createdAt': now.subtract(const Duration(days: 15)).toIso8601String(),
      },
      {
        'id': 'promo_4',
        'title': 'Bridal Package Discount',
        'description': 'Special 25% discount on bridal makeup packages',
        'code': 'BRIDAL25',
        'discountType': 'percentage',
        'discountValue': 25.0,
        'minOrderAmount': 3000.0,
        'maxDiscountAmount': 2000.0,
        'validFrom': now.toIso8601String(),
        'validUntil': now.add(const Duration(days: 90)).toIso8601String(),
        'isActive': true,
        'isGlobal': true,
        'applicableCategories': ['Makeup'],
        'applicableSalons': [],
        'usageLimit': 30,
        'usedCount': 12,
        'image': 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=500',
        'createdAt': now.toIso8601String(),
      },
      {
        'id': 'promo_5',
        'title': 'Refer & Earn',
        'description': 'Refer a friend and both get ₹200 off on next booking',
        'code': 'REFER200',
        'discountType': 'fixed',
        'discountValue': 200.0,
        'minOrderAmount': 1000.0,
        'maxDiscountAmount': 200.0,
        'validFrom': now.subtract(const Duration(days: 60)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 180)).toIso8601String(),
        'isActive': true,
        'isGlobal': true,
        'applicableCategories': ['Hair Care', 'Skin Care', 'Makeup', 'Nail Care', 'Spa'],
        'applicableSalons': [],
        'usageLimit': 1000,
        'usedCount': 156,
        'image': 'https://images.unsplash.com/photo-1559526324-593bc96d0f2b?q=80&w=500',
        'createdAt': now.subtract(const Duration(days: 60)).toIso8601String(),
      },
    ];
  }
}

// Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});