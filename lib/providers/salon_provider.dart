import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/database_service.dart';
import '../models/salon_model.dart';

class SalonState {
  const SalonState({
    this.salons = const [],
    this.isLoading = false,
    this.error,
  });

  final List<SalonModel> salons;
  final bool isLoading;
  final String? error;

  SalonState copyWith({
    List<SalonModel>? salons,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return SalonState(
      salons: salons ?? this.salons,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SalonNotifier extends Notifier<SalonState> {
  DatabaseService? _databaseService;

  @override
  SalonState build() {
    _databaseService = ref.read(databaseServiceProvider);
    _loadSalons();
    return const SalonState(isLoading: true);
  }

  Future<void> _loadSalons() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final salons = await _databaseService!.getAllSalons();
      state = state.copyWith(salons: salons, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load salons: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> refreshSalons() async {
    await _loadSalons();
  }

  // Get all salons
  List<SalonModel> getAllSalons() {
    return state.salons;
  }

  // Get salon by ID
  SalonModel? getSalonById(String id) {
    try {
      return state.salons.firstWhere((salon) => salon.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get salon by ID from database
  Future<SalonModel?> getSalonByIdFromDatabase(String id) async {
    try {
      return await _databaseService!.getSalonById(id);
    } catch (e) {
      return null;
    }
  }

  // Get salons by city
  List<SalonModel> getSalonsByCity(String city) {
    return state.salons.where((salon) =>
      salon.city.toLowerCase().contains(city.toLowerCase())).toList();
  }

  // Search salons in database
  Future<List<SalonModel>> searchSalonsInDatabase(String query) async {
    try {
      return await _databaseService!.searchSalons(query);
    } catch (e) {
      return [];
    }
  }

  // Get featured salons
  List<SalonModel> getFeaturedSalons() {
    return state.salons.where((salon) => salon.isFeatured).toList();
  }

  // Get nearby salons
  Future<List<SalonModel>> getNearbySalons(double latitude, double longitude) async {
    try {
      return await _databaseService!.getNearbySalons(latitude, longitude, 10.0);
    } catch (e) {
      return state.salons.take(5).toList();
    }
  }

  // Search salons locally
  List<SalonModel> searchSalons(String query) {
    final lowercaseQuery = query.toLowerCase();
    return state.salons.where((salon) {
      return salon.name.toLowerCase().contains(lowercaseQuery) ||
             salon.description.toLowerCase().contains(lowercaseQuery) ||
             salon.city.toLowerCase().contains(lowercaseQuery) ||
             salon.categories.any((category) =>
               category.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

}

// Providers
final salonProvider = NotifierProvider<SalonNotifier, SalonState>(() {
  return SalonNotifier();
});

// Convenience providers
final salonsListProvider = Provider<List<SalonModel>>((ref) {
  return ref.watch(salonProvider.select((state) => state.salons));
});

final salonLoadingProvider = Provider<bool>((ref) {
  return ref.watch(salonProvider.select((state) => state.isLoading));
});

final salonErrorProvider = Provider<String?>((ref) {
  return ref.watch(salonProvider.select((state) => state.error));
});

final featuredSalonsProvider = Provider<List<SalonModel>>((ref) {
  final salons = ref.watch(salonsListProvider);
  return salons.where((salon) => salon.isFeatured).toList();
});

final nearbySalonsProvider = FutureProvider.family<List<SalonModel>, Map<String, double>>((ref, location) async {
  final salonNotifier = ref.read(salonProvider.notifier);
  final latitude = location['latitude']!;
  final longitude = location['longitude']!;
  return await salonNotifier.getNearbySalons(latitude, longitude);
});