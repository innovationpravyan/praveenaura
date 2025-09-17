import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/performance_utils.dart';
import '../../models/salon_model.dart';
import '../../models/service_model.dart';
import '../../providers/salon_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/popular_searches_provider.dart';
import '../../widgets/base_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _searchHistory = [];
  bool _isSearching = false;
  List<ServiceModel> _searchResults = [];
  List<SalonModel> _salonResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    PerformanceUtils.debounce(() {
      if (mounted) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchQuery = '';
        _searchResults = [];
        _salonResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    // Search in services
    final serviceState = ref.read(serviceProvider);
    final salonState = ref.read(salonProvider);

    final serviceResults = serviceState.services.where((service) {
      final matchesQuery =
          service.name.toLowerCase().contains(query.toLowerCase()) ||
          service.description.toLowerCase().contains(query.toLowerCase()) ||
          service.category.toLowerCase().contains(query.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' ||
          service.category.toLowerCase() == _selectedCategory.toLowerCase();

      return matchesQuery && matchesCategory;
    }).toList();

    final salonResults = salonState.salons.where((salon) {
      return salon.name.toLowerCase().contains(query.toLowerCase()) ||
          salon.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchResults = serviceResults;
      _salonResults = salonResults;
      _isSearching = false;
    });

    // Add to explore history
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.take(10).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildSearchFilters(),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildSearchSuggestions()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
          },
          onSubmitted: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search salons, services...',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            prefixIcon: const Icon(Icons.search, size: 22),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFilters() {
    final categories = ref.watch(categoriesListProvider);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.name == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category.name : 'All';
                });
              },
              selectedColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchHistory.isNotEmpty) ...[
            _buildSectionTitle('Recent Searches'),
            const SizedBox(height: 12),
            _buildRecentSearches(),
            const SizedBox(height: 24),
          ],
          _buildSectionTitle('Popular Searches'),
          const SizedBox(height: 12),
          _buildPopularSearches(),
          const SizedBox(height: 24),
          _buildSectionTitle('Browse Categories'),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      children: _searchHistory.map((search) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.history, size: 20),
          title: Text(search),
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              setState(() {
                _searchHistory.remove(search);
              });
            },
          ),
          onTap: () => _performSearch(search),
        );
      }).toList(),
    );
  }

  Widget _buildPopularSearches() {
    final popularSearches = ref.watch(popularSearchesProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: popularSearches.map((search) {
        return ActionChip(
          label: Text(search),
          onPressed: () => _performSearch(search),
          backgroundColor: Theme.of(context).cardColor,
        );
      }).toList(),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = ref.watch(categoriesListProvider);
    final displayCategories = categories.where((c) => c.name != 'All').toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];

        return InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = category.name;
              _searchQuery = category.name.toLowerCase();
              _searchController.text = category.name;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Text(
                category.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    // Mock explore results - in real app, this would fetch from backend
    final mockResults = _getMockSearchResults();

    if (mockResults.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockResults.length,
      itemBuilder: (context, index) {
        return _buildSearchResultCard(mockResults[index]);
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your explore terms or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      result['type'] == 'salon'
                          ? Icons.store
                          : Icons.design_services,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['name'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result['description'],
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.getWarningColor(
                              isDark:
                                  Theme.of(context).brightness ==
                                  Brightness.dark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${result['rating']}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            result['location'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockSearchResults() {
    // Mock data - in real app, this would filter based on explore query
    final allResults = [
      {
        'type': 'salon',
        'name': 'Elegance Beauty Salon',
        'description': 'Premium beauty services for women',
        'rating': 4.8,
        'location': 'Varanasi',
      },
      {
        'type': 'service',
        'name': 'Bridal Makeup Package',
        'description': 'Complete bridal makeover with hair styling',
        'rating': 4.9,
        'location': 'Multiple locations',
      },
      {
        'type': 'salon',
        'name': 'Gentlemen\'s Grooming',
        'description': 'Modern barbershop for men',
        'rating': 4.6,
        'location': 'Varanasi',
      },
    ];

    if (_searchQuery.isEmpty) return allResults;

    return allResults.where((result) {
      final query = _searchQuery.toLowerCase();
      return result['name'].toString().toLowerCase().contains(query) ||
          result['description'].toString().toLowerCase().contains(query);
    }).toList();
  }
}
