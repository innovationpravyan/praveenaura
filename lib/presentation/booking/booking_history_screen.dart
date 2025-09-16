import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/base_screen.dart';

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
      return BaseScreen(
        initialIndex: 2,
        title: 'Booking History',
        showBottomNavigation: true,
        child: _buildLoginRequiredContent(context),
      );
    }

    return BaseScreen(
      initialIndex: 2,
      title: 'Booking History',
      showBottomNavigation: true,
      child: Column(
        children: [
          Container(
            color: context.surfaceColor,
            child: TabBar(
              controller: _tabController,
              labelColor: context.primaryColor,
              unselectedLabelColor: context.textMediumEmphasisColor,
              indicatorColor: context.primaryColor,
              labelStyle: context.labelLarge,
              unselectedLabelStyle: context.labelMedium,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList('upcoming'),
                _buildBookingList('completed'),
                _buildBookingList('cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRequiredContent(BuildContext context) {
    return Center(
      child: context.responsiveContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: context.responsiveLargeIconSize,
              color: context.textDisabledColor,
            ),
            context.responsiveVerticalSpacing,
            Text(
              'Login Required',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            context.responsiveSmallVerticalSpacing,
            Text(
              'Please login to view your booking history',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              textAlign: TextAlign.center,
            ),
            context.responsiveLargeVerticalSpacing,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.navigateToLogin(),
                child: const Text('Login Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(String type) {
    // Mock data for demonstration
    if (type == 'upcoming') {
      return ListView.builder(
        padding: context.responsiveContentPadding,
        itemCount: 2,
        itemBuilder: (context, index) {
          return _buildBookingCard(
            'Hair Cut & Styling',
            'Glamour Studio',
            'Tomorrow, 2:00 PM',
            '₹800',
            context.getBookingStatusColor('confirmed'),
            'Confirmed',
            Icons.content_cut,
          );
        },
      );
    } else if (type == 'completed') {
      return ListView.builder(
        padding: context.responsiveContentPadding,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildBookingCard(
            'Facial Treatment',
            'Beauty Palace',
            'Dec 15, 2024',
            '₹1200',
            context.getBookingStatusColor('completed'),
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
            Icon(
              Icons.cancel_outlined,
              size: context.responsiveLargeIconSize,
              color: context.textDisabledColor,
            ),
            context.responsiveSmallVerticalSpacing,
            Text(
              'No cancelled bookings',
              style: context.titleMedium.copyWith(
                color: context.textMediumEmphasisColor,
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
    return context.responsiveCard(
      margin: EdgeInsets.only(bottom: context.responsiveSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.responsiveSmallSpacing),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: context.responsiveSmallBorderRadius,
                ),
                child: Icon(
                  icon,
                  color: statusColor,
                  size: context.responsiveIconSize,
                ),
              ),
              context.responsiveSmallHorizontalSpacing,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      salon,
                      style: context.bodySmall.copyWith(
                        color: context.textMediumEmphasisColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveSmallSpacing,
                  vertical: context.componentSpacing,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.defaultRadius),
                ),
                child: Text(
                  status,
                  style: context.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          context.responsiveSmallVerticalSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: context.responsiveSmallIconSize,
                    color: context.textMediumEmphasisColor,
                  ),
                  SizedBox(width: context.elementSpacing),
                  Text(
                    datetime,
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
              Text(
                price,
                style: context.titleSmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
