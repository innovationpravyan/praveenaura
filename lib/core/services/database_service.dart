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
      // Delete all existing salon and service documents
      final salonSnapshots = await _salonsCollection.get();
      for (final doc in salonSnapshots.docs) {
        await doc.reference.delete();
      }

      final serviceSnapshots = await _servicesCollection.get();
      for (final doc in serviceSnapshots.docs) {
        await doc.reference.delete();
      }

      developer.log('Existing data cleared. Uploading fresh sample data...');

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
    developer.log('Initializing sample salon and service data...');

    try {
      final sampleSalons = _getMockSalons();
      final sampleServices = _getMockServices();

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

      developer.log('Sample data initialized successfully: ${sampleSalons.length} salons, ${sampleServices.length} services');
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
}

// Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});