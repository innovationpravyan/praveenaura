import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/exceptions/app_exceptions.dart';
import '../core/services/database_service.dart';
import '../providers/auth_provider.dart';

// Wishlist state
class WishlistState {
  const WishlistState({
    this.salonIds = const [],
    this.serviceIds = const [],
    this.isLoading = false,
    this.error,
  });

  final List<String> salonIds;
  final List<String> serviceIds;
  final bool isLoading;
  final String? error;

  WishlistState copyWith({
    List<String>? salonIds,
    List<String>? serviceIds,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return WishlistState(
      salonIds: salonIds ?? this.salonIds,
      serviceIds: serviceIds ?? this.serviceIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  // Convenience getters
  bool isSalonInWishlist(String salonId) => salonIds.contains(salonId);
  bool isServiceInWishlist(String serviceId) => serviceIds.contains(serviceId);
  int get totalItems => salonIds.length + serviceIds.length;
  bool get isEmpty => salonIds.isEmpty && serviceIds.isEmpty;
}

// Wishlist notifier
class WishlistNotifier extends Notifier<WishlistState> {
  static const String _salonWishlistKey = 'salon_wishlist';
  static const String _serviceWishlistKey = 'service_wishlist';
  DatabaseService? _databaseService;

  @override
  WishlistState build() {
    _databaseService = ref.read(databaseServiceProvider);
    _loadWishlist();
    return const WishlistState();
  }

  // Load wishlist from database and local storage
  Future<void> _loadWishlist() async {
    final authState = ref.read(authProvider);
    if (authState.user == null && !authState.isGuest) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      List<String> salonIds = [];
      List<String> serviceIds = [];

      if (authState.user != null) {
        // Load from database for authenticated users
        try {
          final wishlist = await _databaseService!.getUserWishlist(authState.user!.uid);
          salonIds = wishlist['salons'] ?? [];
          serviceIds = wishlist['services'] ?? [];
        } catch (e) {
          // Fallback to local storage if database fails
          final prefs = await SharedPreferences.getInstance();
          final userId = authState.user!.uid;
          salonIds = prefs.getStringList('${_salonWishlistKey}_$userId') ?? [];
          serviceIds = prefs.getStringList('${_serviceWishlistKey}_$userId') ?? [];
        }
      } else {
        // Load from local storage for guest users
        final prefs = await SharedPreferences.getInstance();
        salonIds = prefs.getStringList('${_salonWishlistKey}_guest') ?? [];
        serviceIds = prefs.getStringList('${_serviceWishlistKey}_guest') ?? [];
      }

      state = state.copyWith(
        salonIds: salonIds,
        serviceIds: serviceIds,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load wishlist: ${e.toString()}',
      );
    }
  }

  // Add salon to wishlist
  Future<void> addSalonToWishlist(String salonId) async {
    if (state.salonIds.contains(salonId)) return;

    try {
      final updatedSalonIds = [...state.salonIds, salonId];

      final authState = ref.read(authProvider);
      if (authState.user != null) {
        // Save to database for authenticated users
        await _databaseService!.addToWishlist(authState.user!.uid, salonId, 'salon');
      }

      // Also save locally as backup
      await _saveSalonWishlist(updatedSalonIds);

      state = state.copyWith(
        salonIds: updatedSalonIds,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add salon to wishlist: ${e.toString()}',
      );
      throw BusinessException(
        'Failed to add to wishlist',
        'wishlist-add-failed',
      );
    }
  }

  // Remove salon from wishlist
  Future<void> removeSalonFromWishlist(String salonId) async {
    if (!state.salonIds.contains(salonId)) return;

    try {
      final updatedSalonIds = state.salonIds.where((id) => id != salonId).toList();

      final authState = ref.read(authProvider);
      if (authState.user != null) {
        // Remove from database for authenticated users
        await _databaseService!.removeFromWishlist(authState.user!.uid, salonId, 'salon');
      }

      // Also update locally
      await _saveSalonWishlist(updatedSalonIds);

      state = state.copyWith(
        salonIds: updatedSalonIds,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to remove salon from wishlist: ${e.toString()}',
      );
      throw BusinessException(
        'Failed to remove from wishlist',
        'wishlist-remove-failed',
      );
    }
  }

  // Toggle salon wishlist status
  Future<void> toggleSalonWishlist(String salonId) async {
    if (state.salonIds.contains(salonId)) {
      await removeSalonFromWishlist(salonId);
    } else {
      await addSalonToWishlist(salonId);
    }
  }

  // Add service to wishlist
  Future<void> addServiceToWishlist(String serviceId) async {
    if (state.serviceIds.contains(serviceId)) return;

    try {
      final updatedServiceIds = [...state.serviceIds, serviceId];

      final authState = ref.read(authProvider);
      if (authState.user != null) {
        // Save to database for authenticated users
        await _databaseService!.addToWishlist(authState.user!.uid, serviceId, 'service');
      }

      // Also save locally as backup
      await _saveServiceWishlist(updatedServiceIds);

      state = state.copyWith(
        serviceIds: updatedServiceIds,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add service to wishlist: ${e.toString()}',
      );
      throw BusinessException(
        'Failed to add to wishlist',
        'wishlist-add-failed',
      );
    }
  }

  // Remove service from wishlist
  Future<void> removeServiceFromWishlist(String serviceId) async {
    if (!state.serviceIds.contains(serviceId)) return;

    try {
      final updatedServiceIds = state.serviceIds.where((id) => id != serviceId).toList();

      final authState = ref.read(authProvider);
      if (authState.user != null) {
        // Remove from database for authenticated users
        await _databaseService!.removeFromWishlist(authState.user!.uid, serviceId, 'service');
      }

      // Also update locally
      await _saveServiceWishlist(updatedServiceIds);

      state = state.copyWith(
        serviceIds: updatedServiceIds,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to remove service from wishlist: ${e.toString()}',
      );
      throw BusinessException(
        'Failed to remove from wishlist',
        'wishlist-remove-failed',
      );
    }
  }

  // Toggle service wishlist status
  Future<void> toggleServiceWishlist(String serviceId) async {
    if (state.serviceIds.contains(serviceId)) {
      await removeServiceFromWishlist(serviceId);
    } else {
      await addServiceToWishlist(serviceId);
    }
  }

  // Clear all wishlist items
  Future<void> clearWishlist() async {
    try {
      await _saveSalonWishlist([]);
      await _saveServiceWishlist([]);

      state = state.copyWith(
        salonIds: [],
        serviceIds: [],
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to clear wishlist: ${e.toString()}',
      );
      throw BusinessException(
        'Failed to clear wishlist',
        'wishlist-clear-failed',
      );
    }
  }

  // Get wishlist statistics
  Map<String, int> getWishlistStats() {
    return {
      'totalItems': state.totalItems,
      'salons': state.salonIds.length,
      'services': state.serviceIds.length,
    };
  }

  // Check if user can add to wishlist (authentication check)
  bool canAddToWishlist() {
    final authState = ref.read(authProvider);
    return authState.isAuthenticated; // Both guest and full auth can use wishlist
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // Refresh wishlist (reload from storage)
  Future<void> refreshWishlist() async {
    await _loadWishlist();
  }

  // Migrate wishlist when user logs in (from guest to authenticated)
  Future<void> migrateGuestWishlist(String newUserId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get guest wishlist data
      final guestSalonIds = prefs.getStringList('${_salonWishlistKey}_guest') ?? [];
      final guestServiceIds = prefs.getStringList('${_serviceWishlistKey}_guest') ?? [];

      if (guestSalonIds.isEmpty && guestServiceIds.isEmpty) return;

      // Save to database for the new authenticated user
      for (final salonId in guestSalonIds) {
        await _databaseService!.addToWishlist(newUserId, salonId, 'salon');
      }
      for (final serviceId in guestServiceIds) {
        await _databaseService!.addToWishlist(newUserId, serviceId, 'service');
      }

      // Save to new user's local storage
      await prefs.setStringList('${_salonWishlistKey}_$newUserId', guestSalonIds);
      await prefs.setStringList('${_serviceWishlistKey}_$newUserId', guestServiceIds);

      // Clear guest wishlist
      await prefs.remove('${_salonWishlistKey}_guest');
      await prefs.remove('${_serviceWishlistKey}_guest');

      // Update state
      state = state.copyWith(
        salonIds: guestSalonIds,
        serviceIds: guestServiceIds,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to migrate wishlist: ${e.toString()}',
      );
    }
  }

  // Save salon wishlist to local storage
  Future<void> _saveSalonWishlist(List<String> salonIds) async {
    final authState = ref.read(authProvider);
    final userId = authState.user?.uid ?? 'guest';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${_salonWishlistKey}_$userId', salonIds);
  }

  // Save service wishlist to local storage
  Future<void> _saveServiceWishlist(List<String> serviceIds) async {
    final authState = ref.read(authProvider);
    final userId = authState.user?.uid ?? 'guest';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${_serviceWishlistKey}_$userId', serviceIds);
  }
}

// Wishlist provider
final wishlistProvider = NotifierProvider<WishlistNotifier, WishlistState>(() {
  return WishlistNotifier();
});

// Convenience providers
final wishlistStatsProvider = Provider<Map<String, int>>((ref) {
  final wishlistNotifier = ref.read(wishlistProvider.notifier);
  return wishlistNotifier.getWishlistStats();
});

final canAddToWishlistProvider = Provider<bool>((ref) {
  final wishlistNotifier = ref.read(wishlistProvider.notifier);
  return wishlistNotifier.canAddToWishlist();
});

// Specific item wishlist status providers
final salonWishlistStatusProvider = Provider.family<bool, String>((ref, salonId) {
  final wishlistState = ref.watch(wishlistProvider);
  return wishlistState.isSalonInWishlist(salonId);
});

final serviceWishlistStatusProvider = Provider.family<bool, String>((ref, serviceId) {
  final wishlistState = ref.watch(wishlistProvider);
  return wishlistState.isServiceInWishlist(serviceId);
});