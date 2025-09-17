import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../models/salon_model.dart';
import '../../models/service_model.dart';
import '../../widgets/base_screen.dart';

class SalonDetailScreen extends ConsumerStatefulWidget {
  final String salonId;

  const SalonDetailScreen({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends ConsumerState<SalonDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salon = _getMockSalon();

    return BaseScreen(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(salon),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildSalonInfo(salon),
                  _buildTabBar(),
                  _buildTabContent(salon),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(salon),
      ),
    );
  }

  Widget _buildSliverAppBar(SalonModel salon) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: salon.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.store,
                    size: 80,
                    color: Colors.white70,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: salon.images.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == entry.key
                          ? Colors.white
                          : Colors.white54,
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalonInfo(SalonModel salon) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      salon.displayName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      salon.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: salon.isActive
                      ? AppColors.getSuccessColor(
                          isDark: Theme.of(context).brightness == Brightness.dark,
                        ).withValues(alpha: 0.1)
                      : AppColors.getErrorColor(
                          isDark: Theme.of(context).brightness == Brightness.dark,
                        ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  salon.isActive ? 'Open' : 'Closed',
                  style: TextStyle(
                    color: salon.isActive
                        ? AppColors.getSuccessColor(
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          )
                        : AppColors.getErrorColor(
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          ),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${salon.totalReviews} reviews)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                salon.priceRange,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  salon.fullAddress,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.directions, size: 18),
                label: const Text('Directions'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).disabledColor,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Tab(text: 'Services'),
          Tab(text: 'Reviews'),
          Tab(text: 'Gallery'),
          Tab(text: 'Info'),
        ],
      ),
    );
  }

  Widget _buildTabContent(SalonModel salon) {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildServicesTab(salon),
          _buildReviewsTab(salon),
          _buildGalleryTab(salon),
          _buildInfoTab(salon),
        ],
      ),
    );
  }

  Widget _buildServicesTab(SalonModel salon) {
    final services = _getMockServices();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.design_services,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${service.price.toInt()}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${service.duration}min',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to booking flow
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Book'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(SalonModel salon) {
    final reviews = _getMockReviews();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Text(
                        review['name'][0].toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['name'],
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < review['rating'] ? Icons.star : Icons.star_border,
                                  size: 16,
                                  color: AppColors.getWarningColor(
                                    isDark: Theme.of(context).brightness == Brightness.dark,
                                  ),
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                review['date'],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review['comment'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGalleryTab(SalonModel salon) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.image,
            size: 40,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          ),
        );
      },
    );
  }

  Widget _buildInfoTab(SalonModel salon) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection('Contact Information', [
            _buildInfoRow(Icons.phone, 'Phone', salon.phoneNumber),
            _buildInfoRow(Icons.email, 'Email', salon.email),
            if (salon.website != null)
              _buildInfoRow(Icons.language, 'Website', salon.website!),
          ]),
          const SizedBox(height: 24),
          _buildInfoSection('Working Hours', [
            ...salon.workingHours.entries.map((entry) {
              return _buildInfoRow(
                Icons.access_time,
                entry.key.capitalize(),
                entry.value.displayTime,
              );
            }),
          ]),
          const SizedBox(height: 24),
          _buildInfoSection('Amenities', [
            ...salon.amenities.map((amenity) {
              return _buildInfoRow(Icons.check_circle, '', amenity);
            }),
          ]),
          if (salon.specializations.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildInfoSection('Specializations', [
              ...salon.specializations.map((spec) {
                return _buildInfoRow(Icons.star, '', spec);
              }),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).disabledColor),
          const SizedBox(width: 12),
          if (label.isNotEmpty) ...[
            Text(
              '$label: ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(SalonModel salon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call),
              label: const Text('Call'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to booking flow
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mock data methods
  SalonModel _getMockSalon() {
    return SalonModel(
      id: widget.salonId,
      name: 'Elegance Beauty Salon',
      description: 'Premium beauty services for modern women',
      address: '123 Mall Road',
      city: 'Varanasi',
      state: 'Uttar Pradesh',
      pincode: '221001',
      latitude: 25.3176,
      longitude: 82.9739,
      phoneNumber: '+91 9876543210',
      email: 'info@elegancebeauty.com',
      ownerId: 'owner1',
      images: List.generate(3, (index) => 'image_$index'),
      rating: 4.8,
      totalReviews: 156,
      isActive: true,
      minPrice: 500.0,
      maxPrice: 5000.0,
      amenities: ['AC', 'WiFi', 'Parking', 'Card Payment'],
      specializations: ['Bridal Makeup', 'Hair Styling', 'Skin Care'],
      workingHours: {
        'Monday': const WorkingHours(
          day: 'Monday',
          isOpen: true,
          openTime: '09:00',
          closeTime: '21:00',
        ),
        'Tuesday': const WorkingHours(
          day: 'Tuesday',
          isOpen: true,
          openTime: '09:00',
          closeTime: '21:00',
        ),
        'Wednesday': const WorkingHours(
          day: 'Wednesday',
          isOpen: true,
          openTime: '09:00',
          closeTime: '21:00',
        ),
        'Thursday': const WorkingHours(
          day: 'Thursday',
          isOpen: true,
          openTime: '09:00',
          closeTime: '21:00',
        ),
        'Friday': const WorkingHours(
          day: 'Friday',
          isOpen: true,
          openTime: '09:00',
          closeTime: '21:00',
        ),
        'Saturday': const WorkingHours(
          day: 'Saturday',
          isOpen: true,
          openTime: '10:00',
          closeTime: '22:00',
        ),
        'Sunday': const WorkingHours(
          day: 'Sunday',
          isOpen: false,
        ),
      },
    );
  }

  List<ServiceModel> _getMockServices() {
    return [
      ServiceModel(
        id: 'service1',
        name: 'Hair Cut & Style',
        description: 'Professional hair cutting and styling',
        price: 800.0,
        duration: 45,
        category: 'Hair',
        salonId: widget.salonId,
        isActive: true,
      ),
      ServiceModel(
        id: 'service2',
        name: 'Facial Treatment',
        description: 'Deep cleansing facial with natural ingredients',
        price: 1200.0,
        duration: 60,
        category: 'Skin Care',
        salonId: widget.salonId,
        isActive: true,
      ),
      ServiceModel(
        id: 'service3',
        name: 'Bridal Makeup',
        description: 'Complete bridal makeover package',
        price: 5000.0,
        duration: 180,
        category: 'Makeup',
        salonId: widget.salonId,
        isActive: true,
      ),
    ];
  }

  List<Map<String, dynamic>> _getMockReviews() {
    return [
      {
        'name': 'Priya Sharma',
        'rating': 5,
        'date': '2 days ago',
        'comment': 'Excellent service! The staff is very professional and the ambiance is great.',
      },
      {
        'name': 'Anjali Singh',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Good experience overall. Hair styling was perfect for my wedding.',
      },
      {
        'name': 'Deepika Yadav',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Best salon in the city! Highly recommend their facial services.',
      },
    ];
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}