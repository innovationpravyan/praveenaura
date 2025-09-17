import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Category model for UI
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.image,
    required this.isActive,
    required this.isPopular,
    required this.sortOrder,
    required this.serviceCount,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String icon;
  final String image;
  final bool isActive;
  final bool isPopular;
  final int sortOrder;
  final int serviceCount;
  final DateTime? createdAt;

  factory Category.fromMap(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? 'category',
      image: data['image'] ?? '',
      isActive: data['isActive'] ?? true,
      isPopular: data['isPopular'] ?? false,
      sortOrder: data['sortOrder'] ?? 0,
      serviceCount: data['serviceCount'] ?? 0,
      createdAt: data['createdAt'] != null
        ? DateTime.parse(data['createdAt'])
        : DateTime.now(),
    );
  }
}

// Category state
class CategoryState {
  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Category> categories;
  final bool isLoading;
  final String? error;

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// Category notifier
class CategoryNotifier extends Notifier<CategoryState> {

  @override
  CategoryState build() {
    // Schedule loading for next frame to avoid circular dependency
    ref.onCancel(() {
      // Cleanup if needed
    });

    // Load data asynchronously using post frame callback
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });

    return const CategoryState(isLoading: true);
  }

  Future<void> _loadCategories() async {
    try {
      // Get categories from Firebase via database service
      // For now, using default categories until we implement proper category fetching in DatabaseService
      final categories = _getDefaultCategories();

      state = CategoryState(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      // Fallback to static categories if Firebase fails
      state = CategoryState(
        categories: _getDefaultCategories(),
        isLoading: false,
        error: 'Using default categories: ${e.toString()}',
      );
    }
  }

  // Fallback default categories
  List<Category> _getDefaultCategories() {
    final now = DateTime.now();
    return [
      Category(
        id: 'all',
        name: 'All',
        description: 'All categories',
        icon: 'all_inclusive',
        image: '',
        isActive: true,
        isPopular: true,
        sortOrder: 0,
        serviceCount: 0,
        createdAt: now,
      ),
      Category(
        id: 'hair_care',
        name: 'Hair Care',
        description: 'Complete hair care services',
        icon: 'hair_salon',
        image: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=500',
        isActive: true,
        isPopular: true,
        sortOrder: 1,
        serviceCount: 4,
        createdAt: now,
      ),
      Category(
        id: 'skin_care',
        name: 'Skin Care',
        description: 'Professional skin care treatments',
        icon: 'face',
        image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=500',
        isActive: true,
        isPopular: true,
        sortOrder: 2,
        serviceCount: 3,
        createdAt: now,
      ),
      Category(
        id: 'makeup',
        name: 'Makeup',
        description: 'Professional makeup services',
        icon: 'palette',
        image: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=500',
        isActive: true,
        isPopular: true,
        sortOrder: 3,
        serviceCount: 2,
        createdAt: now,
      ),
      Category(
        id: 'nail_care',
        name: 'Nail Care',
        description: 'Complete nail care services',
        icon: 'nail_salon',
        image: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=500',
        isActive: true,
        isPopular: false,
        sortOrder: 4,
        serviceCount: 2,
        createdAt: now,
      ),
      Category(
        id: 'spa',
        name: 'Spa',
        description: 'Relaxing spa treatments',
        icon: 'spa',
        image: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500',
        isActive: true,
        isPopular: true,
        sortOrder: 5,
        serviceCount: 1,
        createdAt: now,
      ),
    ];
  }

  // Refresh categories
  Future<void> refreshCategories() async {
    await _loadCategories();
  }

  // Get all categories
  List<Category> getAllCategories() {
    return state.categories;
  }

  // Get popular categories
  List<Category> getPopularCategories() {
    return state.categories.where((category) => category.isPopular).toList();
  }

  // Get category by ID
  Category? getCategoryById(String id) {
    try {
      return state.categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// Providers
final categoryProvider = NotifierProvider<CategoryNotifier, CategoryState>(() {
  return CategoryNotifier();
});

// Convenience providers
final categoriesListProvider = Provider<List<Category>>((ref) {
  return ref.watch(categoryProvider.select((state) => state.categories));
});

final popularCategoriesProvider = Provider<List<Category>>((ref) {
  final categories = ref.watch(categoriesListProvider);
  return categories.where((category) => category.isPopular).toList();
});

final categoryLoadingProvider = Provider<bool>((ref) {
  return ref.watch(categoryProvider.select((state) => state.isLoading));
});

final categoryErrorProvider = Provider<String?>((ref) {
  return ref.watch(categoryProvider.select((state) => state.error));
});