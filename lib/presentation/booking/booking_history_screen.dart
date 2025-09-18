import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../models/booking_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/salon_provider.dart';
import '../../../providers/service_provider.dart';
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

    // Trigger data loading after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookingData();
    });
  }

  void _loadBookingData() {
    final authState = ref.read(authProvider);
    if (authState.user != null) {
      // Trigger bookings reload
      ref.read(bookingProvider.notifier).refreshBookings();
    }
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
    final authState = ref.watch(authProvider);

    if (authState.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer(
      builder: (context, ref, child) {
        final bookingState = ref.watch(bookingProvider);
        final salonNotifier = ref.read(salonProvider.notifier);
        final serviceNotifier = ref.read(serviceProvider.notifier);

        if (bookingState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookingState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: context.responsiveLargeIconSize,
                  color: context.textDisabledColor,
                ),
                context.responsiveSmallVerticalSpacing,
                Text(
                  'Error loading bookings',
                  style: context.titleMedium.copyWith(
                    color: context.textMediumEmphasisColor,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(bookingProvider.notifier).refreshBookings();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Filter bookings by type and user
        final userBookings = bookingState.bookings
            .where((booking) => booking.userId == authState.user!.uid)
            .toList();

        List<BookingModel> filteredBookings;
        switch (type) {
          case 'upcoming':
            filteredBookings = userBookings
                .where((booking) =>
                    booking.status == BookingStatus.confirmed.value &&
                    booking.bookingDateTime.isAfter(DateTime.now()))
                .toList();
            break;
          case 'completed':
            filteredBookings = userBookings
                .where((booking) => booking.status == BookingStatus.completed.value)
                .toList();
            break;
          case 'cancelled':
            filteredBookings = userBookings
                .where((booking) => booking.status == BookingStatus.cancelled.value)
                .toList();
            break;
          default:
            filteredBookings = [];
        }

        if (filteredBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getEmptyStateIcon(type),
                  size: context.responsiveLargeIconSize,
                  color: context.textDisabledColor,
                ),
                context.responsiveSmallVerticalSpacing,
                Text(
                  _getEmptyStateMessage(type),
                  style: context.titleMedium.copyWith(
                    color: context.textMediumEmphasisColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(bookingProvider.notifier).refreshBookings();
          },
          child: ListView.builder(
            padding: context.responsiveContentPadding,
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = filteredBookings[index];
              final salon = salonNotifier.getSalonById(booking.salonId);
              final serviceId = booking.serviceIds.isNotEmpty ? booking.serviceIds.first : '';
              final service = serviceId.isNotEmpty ? serviceNotifier.getServiceById(serviceId) : null;

              return _buildBookingCard(
                booking,
                service?.name ?? 'Unknown Service',
                salon?.name ?? 'Unknown Salon',
                context,
              );
            },
          ),
        );
      },
    );
  }

  IconData _getEmptyStateIcon(String type) {
    switch (type) {
      case 'upcoming':
        return Icons.calendar_today_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.history;
    }
  }

  String _getEmptyStateMessage(String type) {
    switch (type) {
      case 'upcoming':
        return 'No upcoming bookings';
      case 'completed':
        return 'No completed bookings';
      case 'cancelled':
        return 'No cancelled bookings';
      default:
        return 'No bookings found';
    }
  }

  Widget _buildBookingCard(
    BookingModel booking,
    String serviceName,
    String salonName,
    BuildContext context,
  ) {
    final statusColor = _getBookingStatusColor(BookingStatusExtension.fromString(booking.status), context);
    final statusText = BookingStatusExtension.fromString(booking.status).displayText;
    final formattedDate = _formatBookingDate(booking.bookingDateTime);
    final formattedPrice = '₹${booking.totalAmount.toInt()}';
    final icon = _getServiceIcon(serviceName);
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
                      serviceName,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      salonName,
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
                  statusText,
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
                    formattedDate,
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
              Text(
                formattedPrice,
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

  Color _getBookingStatusColor(BookingStatus status, BuildContext context) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.pending:
        return Colors.orange;
      default:
        return context.textMediumEmphasisColor;
    }
  }

  String _formatBookingDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final bookingDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (bookingDate == today) {
      return 'Today, ${_formatTime(dateTime)}';
    } else if (bookingDate == tomorrow) {
      return 'Tomorrow, ${_formatTime(dateTime)}';
    } else {
      return '${_formatDate(dateTime)}, ${_formatTime(dateTime)}';
    }
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  IconData _getServiceIcon(String serviceName) {
    final lowerService = serviceName.toLowerCase();
    if (lowerService.contains('hair') || lowerService.contains('cut')) {
      return Icons.content_cut;
    } else if (lowerService.contains('facial') || lowerService.contains('face')) {
      return Icons.face;
    } else if (lowerService.contains('nail') || lowerService.contains('manicure') || lowerService.contains('pedicure')) {
      return Icons.back_hand;
    } else if (lowerService.contains('makeup')) {
      return Icons.palette;
    } else if (lowerService.contains('massage') || lowerService.contains('spa')) {
      return Icons.spa;
    } else {
      return Icons.room_service;
    }
  }
}
