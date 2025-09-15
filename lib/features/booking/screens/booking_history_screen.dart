import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:aurame/core/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';

class BookingHistoryScreen extends ConsumerStatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  ConsumerState<BookingHistoryScreen> createState() =>
      _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends ConsumerState<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Check if user needs authentication
    if (authState.requiresLogin) {
      return _buildLoginRequiredScreen(context);
    }

    return BaseScreen(
      initialIndex: 2,
      title: 'Booking History',
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList('upcoming'),
          _buildBookingList('completed'),
          _buildBookingList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildLoginRequiredScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 80, color: AppColors.grey400),
              const SizedBox(height: AppConstants.mediumSpacing),
              Text(
                'Login Required',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              Text(
                'Please login to view your booking history',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.largeSpacing),
              ElevatedButton(
                onPressed: () => context.navigateToLogin(),
                child: const Text('Login Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(String type) {
    // Mock data for demonstration
    if (type == 'upcoming') {
      return ListView.builder(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        itemCount: 2,
        itemBuilder: (context, index) {
          return _buildBookingCard(
            'Hair Cut & Styling',
            'Glamour Studio',
            'Tomorrow, 2:00 PM',
            '₹800',
            AppColors.info,
            'Confirmed',
            Icons.content_cut,
          );
        },
      );
    } else if (type == 'completed') {
      return ListView.builder(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildBookingCard(
            'Facial Treatment',
            'Beauty Palace',
            'Dec 15, 2024',
            '₹1200',
            AppColors.success,
            'Completed',
            Icons.face,
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              'No cancelled bookings',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBookingCard(
    String service,
    String salon,
    String datetime,
    String price,
    Color statusColor,
    String status,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumSpacing),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        salon,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text(
                      datetime,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
                Text(
                  price,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primaryPink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
