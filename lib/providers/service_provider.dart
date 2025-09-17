import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/database_service.dart';
import '../models/service_model.dart';

class ServiceState {
  const ServiceState({
    this.services = const [],
    this.isLoading = false,
    this.error,
  });

  final List<ServiceModel> services;
  final bool isLoading;
  final String? error;

  ServiceState copyWith({
    List<ServiceModel>? services,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ServiceState(
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ServiceNotifier extends Notifier<ServiceState> {
  DatabaseService? _databaseService;

  @override
  ServiceState build() {
    _databaseService = ref.read(databaseServiceProvider);

    // Schedule loading for next frame to avoid circular dependency
    ref.onCancel(() {
      // Cleanup if needed
    });

    // Load data asynchronously using post frame callback
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadServices();
    });

    return const ServiceState(isLoading: true);
  }

  Future<void> _loadServices() async {
    try {
      final services = await _databaseService!.getAllServices();
      state = ServiceState(
        services: services,
        isLoading: false,
      );
    } catch (e) {
      state = ServiceState(
        services: const [],
        isLoading: false,
        error: 'Failed to load services: ${e.toString()}',
      );
    }
  }

  Future<void> refreshServices() async {
    await _loadServices();
  }

  // Get all services
  List<ServiceModel> getAllServices() {
    return state.services;
  }

  // Get service by ID
  ServiceModel? getServiceById(String id) {
    try {
      return state.services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get service by ID from database
  Future<ServiceModel?> getServiceByIdFromDatabase(String id) async {
    try {
      return await _databaseService!.getServiceById(id);
    } catch (e) {
      return null;
    }
  }

  // Get services by salon ID
  List<ServiceModel> getServicesBySalonId(String salonId) {
    return state.services.where((service) => service.salonId == salonId).toList();
  }

  // Get services by salon ID from database
  Future<List<ServiceModel>> getServicesBySalonIdFromDatabase(String salonId) async {
    try {
      return await _databaseService!.getServicesBySalon(salonId);
    } catch (e) {
      return [];
    }
  }

  // Get services by category
  List<ServiceModel> getServicesByCategory(String category) {
    return state.services.where((service) =>
      service.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Get services by category from database
  Future<List<ServiceModel>> getServicesByCategoryFromDatabase(String category) async {
    try {
      return await _databaseService!.getServicesByCategory(category);
    } catch (e) {
      return [];
    }
  }

  // Get popular services
  List<ServiceModel> getPopularServices() {
    return state.services.where((service) => service.isPopular).toList();
  }

  // Search services locally
  List<ServiceModel> searchServices(String query) {
    final lowercaseQuery = query.toLowerCase();
    return state.services.where((service) {
      return service.name.toLowerCase().contains(lowercaseQuery) ||
             service.description.toLowerCase().contains(lowercaseQuery) ||
             service.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Search services in database
  Future<List<ServiceModel>> searchServicesInDatabase(String query) async {
    try {
      return await _databaseService!.searchServices(query);
    } catch (e) {
      return [];
    }
  }

  // Get all categories
  List<String> getAllCategories() {
    return state.services.map((service) => service.category).toSet().toList();
  }
}

// Providers
final serviceProvider = NotifierProvider<ServiceNotifier, ServiceState>(() {
  return ServiceNotifier();
});

// Convenience providers
final servicesListProvider = Provider<List<ServiceModel>>((ref) {
  return ref.watch(serviceProvider.select((state) => state.services));
});

final serviceLoadingProvider = Provider<bool>((ref) {
  return ref.watch(serviceProvider.select((state) => state.isLoading));
});

final serviceErrorProvider = Provider<String?>((ref) {
  return ref.watch(serviceProvider.select((state) => state.error));
});

final popularServicesProvider = Provider<List<ServiceModel>>((ref) {
  final services = ref.watch(servicesListProvider);
  return services.where((service) => service.isPopular).toList();
});

final serviceCategoriesProvider = Provider<List<String>>((ref) {
  final services = ref.watch(servicesListProvider);
  return services.map((service) => service.category).toSet().toList();
});

final servicesBySalonProvider = FutureProvider.family<List<ServiceModel>, String>((ref, salonId) async {
  final serviceNotifier = ref.read(serviceProvider.notifier);
  return await serviceNotifier.getServicesBySalonIdFromDatabase(salonId);
});

final servicesByCategoryProvider = FutureProvider.family<List<ServiceModel>, String>((ref, category) async {
  final serviceNotifier = ref.read(serviceProvider.notifier);
  return await serviceNotifier.getServicesByCategoryFromDatabase(category);
});