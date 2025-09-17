import 'package:flutter_riverpod/flutter_riverpod.dart';

// Popular searches provider
class PopularSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return _getDefaultPopularSearches();
  }

  // Get popular searches (could be fetched from Firebase in the future)
  List<String> _getDefaultPopularSearches() {
    return [
      'Hair cut for women',
      'Bridal makeup',
      'Facial treatment',
      'Hair coloring',
      'Manicure pedicure',
      'Deep tissue massage',
      'Eyebrow threading',
      'Hair spa',
      'Anti-aging facial',
      'Professional blowdry',
      'Nail art',
      'Hair straightening',
    ];
  }

  // Update popular searches based on user activity
  void updatePopularSearches(List<String> newSearches) {
    state = newSearches;
  }

  // Add a search term (could be used for analytics)
  void addSearchTerm(String searchTerm) {
    if (searchTerm.trim().isNotEmpty && !state.contains(searchTerm.trim())) {
      final updatedSearches = [searchTerm.trim(), ...state];
      // Keep only top 10 popular searches
      state = updatedSearches.take(10).toList();
    }
  }
}

// Provider
final popularSearchesProvider = NotifierProvider<PopularSearchesNotifier, List<String>>(() {
  return PopularSearchesNotifier();
});