import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/app_router.dart';
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
  bool _isMapView = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  // Default location (Varanasi)
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(25.3176, 82.9739),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeMarkers();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeMarkers() {
    // Get real salon data from provider
    final salonState = ref.read(salonProvider);
    final nearbyRadius = 50.0; // 50km radius from center point

    // Filter salons that are active and within reasonable distance
    final nearbySalons = salonState.salons.where((salon) {
      return salon.isActive &&
             _calculateDistance(
               _defaultLocation.target.latitude,
               _defaultLocation.target.longitude,
               salon.latitude,
               salon.longitude
             ) <= nearbyRadius;
    }).toList();

    // If no nearby salons found, show all active salons
    final salonsToShow = nearbySalons.isNotEmpty ? nearbySalons : salonState.salons.where((s) => s.isActive).take(20).toList();

    _markers = salonsToShow.map((salon) {
      return Marker(
        markerId: MarkerId(salon.id),
        position: LatLng(salon.latitude, salon.longitude),
        infoWindow: InfoWindow(
          title: salon.displayName,
          snippet: '⭐ ${salon.ratingText} • ${salon.isOpen ? "Open" : "Closed"} • Tap for details',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          salon.isOpen ? BitmapDescriptor.hueViolet : BitmapDescriptor.hueOrange
        ),
        onTap: () => _onSalonMarkerTapped(salon),
      );
    }).toSet();
  }

  // Calculate distance between two points using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  void _onSalonMarkerTapped(SalonModel salon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSalonBottomSheet(salon),
    );
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
            _buildViewToggle(),
            Expanded(
              child: _isMapView
                  ? Consumer(
                      builder: (context, ref, child) {
                        // Watch for salon data changes
                        ref.watch(salonProvider);
                        // Reinitialize markers when salon data changes
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _initializeMarkers();
                        });
                        return _buildMapView();
                      },
                    )
                  : (_searchQuery.isEmpty
                      ? _buildSearchSuggestions()
                      : _buildSearchResults()),
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

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleButton(
                  icon: Icons.list,
                  label: 'List',
                  isSelected: !_isMapView,
                  onTap: () => setState(() => _isMapView = false),
                ),
                _buildToggleButton(
                  icon: Icons.map,
                  label: 'Map',
                  isSelected: _isMapView,
                  onTap: () => setState(() => _isMapView = true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _defaultLocation,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
        ),
        // My Location Button
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor: Theme.of(context).primaryColor,
            onPressed: _goToMyLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }


  void _goToMyLocation() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(_defaultLocation),
      );
    }
  }

  Widget _buildSalonBottomSheet(SalonModel salon) {
    final distance = _calculateDistance(
      _defaultLocation.target.latitude,
      _defaultLocation.target.longitude,
      salon.latitude,
      salon.longitude,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Salon name with status badges
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              salon.displayName,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (salon.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, color: Colors.blue, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: TextStyle(color: Colors.blue, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Rating, status, and distance
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.getWarningColor(
                              isDark: Theme.of(context).brightness == Brightness.dark,
                            ),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            salon.ratingText,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${salon.totalReviews})',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: salon.isOpen
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              salon.isOpen ? 'Open' : 'Closed',
                              style: TextStyle(
                                color: salon.isOpen ? Colors.green : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).disabledColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${distance.toStringAsFixed(1)} km',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.place,
                            color: Theme.of(context).disabledColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              salon.fullAddress,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        salon.description.isNotEmpty
                            ? salon.description
                            : 'Premium beauty salon offering a wide range of professional services with experienced staff.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),

                      // Price range
                      if (salon.minPrice != null || salon.maxPrice != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              color: Theme.of(context).disabledColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              salon.priceRange,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Contact and booking buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Call functionality
                              },
                              icon: const Icon(Icons.call, size: 18),
                              label: const Text('Call'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigate to booking with salon pre-selected
                                _navigateToBookingFlow(salon);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Book Appointment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
          // _buildSectionTitle('Popular Searches'),
          // const SizedBox(height: 12),
          // _buildPopularSearches(),
          // const SizedBox(height: 24),
          _buildSectionTitle('Browse Categories'),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          _buildSectionTitle('Nearby Salons'),
          const SizedBox(height: 12),
          _buildSalonsList(),
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
        crossAxisCount: 3,
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

  Widget _buildSalonsList() {
    return Consumer(
      builder: (context, ref, child) {
        final salonState = ref.watch(salonProvider);

        if (salonState.salons.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No salons found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Filter active salons and sort by rating
        final activeSalons = salonState.salons
            .where((salon) => salon.isActive)
            .toList()
          ..sort((a, b) => b.rating.compareTo(a.rating));

        // Show top 10 salons
        final displaySalons = activeSalons.take(10).toList();

        return Column(
          children: [
            ...displaySalons.map((salon) => _buildSalonCard(salon)),
            if (activeSalons.length > 10)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to full salon list or show more
                    setState(() {
                      _searchQuery = 'salon';
                      _searchController.text = 'salon';
                    });
                  },
                  child: Text('View All ${activeSalons.length} Salons'),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSalonCard(SalonModel salon) {
    final distance = _calculateDistance(
      _defaultLocation.target.latitude,
      _defaultLocation.target.longitude,
      salon.latitude,
      salon.longitude,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _onSalonCardTapped(salon),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Salon image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: salon.images.isNotEmpty
                      ? Image.network(
                          salon.primaryImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(
                                Icons.store,
                                color: Theme.of(context).primaryColor,
                                size: 32,
                              ),
                        )
                      : Icon(
                          Icons.store,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Salon details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and badges
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            salon.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (salon.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified, color: Colors.blue, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Rating and status
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.getWarningColor(
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          ),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          salon.ratingText,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${salon.totalReviews})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: salon.isOpen
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            salon.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: salon.isOpen ? Colors.green : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Address and distance
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).disabledColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            salon.shortAddress,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${distance.toStringAsFixed(1)} km',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price range and categories
                    Row(
                      children: [
                        if (salon.minPrice != null || salon.maxPrice != null) ...[
                          Icon(
                            Icons.currency_rupee,
                            color: Theme.of(context).disabledColor,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            salon.priceRange,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (salon.categories.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              salon.categories.first,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSalonCardTapped(SalonModel salon) {
    // Navigate to salon detail or show bottom sheet
    _onSalonMarkerTapped(salon);
  }

  void _navigateToBookingFlow(SalonModel salon) {
    final Map<String, dynamic> arguments = {
      'salonId': salon.id,
    };

    Navigator.of(context).pushNamed(
      AppRoutes.bookingFlow,
      arguments: arguments,
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
