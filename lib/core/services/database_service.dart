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

  // Mock data for now
  Future<List<SalonModel>> getAllSalons() async {
    // Return mock data since we haven't implemented Firestore data
    return _getMockSalons();
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
    return _getMockServices();
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
        services: ['service_1', 'service_2'],
        amenities: ['AC', 'WiFi', 'Parking'],
        categories: ['Hair Care', 'Skin Care'],
        rating: 4.8,
        totalReviews: 156,
        totalBookings: 892,
        isActive: true,
        isFeatured: true,
        workingHours: {
          'Monday': const WorkingHours(
            day: 'Monday',
            isOpen: true,
            openTime: '09:00',
            closeTime: '21:00',
          ),
        },
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<ServiceModel> _getMockServices() {
    return [
      ServiceModel(
        id: 'service_1',
        name: 'Hair Cut & Styling',
        description: 'Professional hair cutting and styling',
        price: 800.0,
        duration: 60,
        category: 'Hair Care',
        salonId: 'salon_1',
        isActive: true,
        isPopular: true,
        images: ['https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=2940'],
        rating: 4.8,
        totalBookings: 245,
        createdAt: DateTime.now(),
      ),
    ];
  }
}

// Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});