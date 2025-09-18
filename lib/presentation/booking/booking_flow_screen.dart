import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_router.dart';
import '../../models/salon_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/salon_provider.dart';
import '../../providers/service_provider.dart';
import '../../widgets/base_screen.dart';
import './widgets/booking_summary_widget.dart';
import './widgets/booking_type_widget.dart';
import './widgets/date_time_selection_widget.dart';
import './widgets/professional_selection_widget.dart';
import './widgets/service_selection_widget.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final String? salonId;
  final String? serviceId;

  const BookingFlowScreen({super.key, this.salonId, this.serviceId});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen>
    with TickerProviderStateMixin {
  int currentStep = 0;
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  // Booking data
  Map<String, dynamic>? selectedService;
  Map<String, dynamic>? selectedProfessional;
  DateTime? selectedDate;
  String? selectedTime;
  String? bookingType = 'salon';
  String? selectedAddress;
  SalonModel? selectedSalon;

  final List<String> stepTitles = [
    'Select Service',
    // 'Choose Professional',
    'Pick Date & Time',
    'Booking Details',
    'Review & Confirm',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressAnimationController = AnimationController(
      duration: context.mediumAnimation,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _updateProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final progress = (currentStep + 1) / stepTitles.length;
    _progressAnimationController.animateTo(progress);
  }

  void _nextStep() {
    if (currentStep < stepTitles.length - 1) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: context.mediumAnimation,
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: context.mediumAnimation,
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  bool _canProceedToNext() {
    switch (currentStep) {
      case 0:
        return selectedService != null;
      // case 1:
      //   return selectedProfessional != null;
      case 1:
        return selectedDate != null && selectedTime != null;
      case 2:
        return bookingType != null &&
            (bookingType == 'home' ? selectedAddress != null : selectedSalon != null);
      case 3:
        return true;
      default:
        return false;
    }
  }

  Future<void> _confirmBooking() async {
    final authState = ref.read(authProvider);

    // Check authentication
    if (authState.user == null) {
      context.showErrorSnackBar('Please login to make a booking');
      return;
    }

    // Show loading dialog
    context.showLoadingDialog(message: 'Confirming your booking...');

    try {
      final bookingNotifier = ref.read(bookingProvider.notifier);

      // Create booking in Firebase
      final booking = await bookingNotifier.createBooking(
        salonId: selectedSalon?.id ?? selectedService?['salonId'] ?? widget.salonId ?? '',
        serviceIds: [selectedService?['id'] ?? widget.serviceId ?? ''],
        bookingDateTime: DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          _parseHour(selectedTime!),
          _parseMinute(selectedTime!),
        ),
        serviceType: bookingType == 'home' ? 'home' : 'salon',
        address: bookingType == 'home' ? selectedAddress : null,
      );

      if (!mounted) return;
      context.hideLoadingDialog();

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: context.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w(context)),
              Text(
                'Booking Confirmed!',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textHighEmphasisColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your appointment has been successfully booked.',
                style: context.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: #${booking?.id.substring(0, 8).toUpperCase() ?? 'N/A'}',
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: context.responsiveBorderRadius,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close success dialog
                AppRouter.pushNamedAndClearStack(AppRoutes.home);
              },
              child: const Text('Go to Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close success dialog
                _navigateToPayment(booking?.id ?? '');
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      context.hideLoadingDialog();
      context.showErrorSnackBar('Failed to create booking: ${e.toString()}');
    }
  }

  Future<bool> _onWillPop() async {
    if (currentStep > 0) {
      _previousStep();
      return false;
    }
    return true;
  }

  int _parseHour(String timeString) {
    // Handle formats like "2:30 PM", "10:00 AM", "12 PM", "1 AM"
    final parts = timeString.split(' ');
    if (parts.length < 2) return 0;

    final timePart = parts[0];
    final period = parts[1].toUpperCase();

    int hour;
    if (timePart.contains(':')) {
      hour = int.tryParse(timePart.split(':')[0]) ?? 0;
    } else {
      hour = int.tryParse(timePart) ?? 0;
    }

    // Convert to 24-hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return hour;
  }

  int _parseMinute(String timeString) {
    // Handle formats like "2:30 PM", "10:00 AM", "12 PM", "1 AM"
    final parts = timeString.split(' ');
    if (parts.isEmpty) return 0;

    final timePart = parts[0];
    if (timePart.contains(':')) {
      final timeParts = timePart.split(':');
      if (timeParts.length > 1) {
        return int.tryParse(timeParts[1]) ?? 0;
      }
    }

    return 0; // Default to 0 minutes if no minutes specified
  }

  void _navigateToPayment(String bookingId) {
    final salonNotifier = ref.read(salonProvider.notifier);
    final serviceNotifier = ref.read(serviceProvider.notifier);

    final salon = selectedSalon ?? salonNotifier.getSalonById(selectedService?['salonId'] ?? widget.salonId ?? '');
    final service = serviceNotifier.getServiceById(selectedService?['id'] ?? widget.serviceId ?? '');

    final bookingData = {
      'bookingId': bookingId,
      'salon': {
        'id': salon?.id ?? '',
        'name': salon?.name ?? 'Unknown Salon',
        'image': salon?.images.isNotEmpty == true ? salon!.images.first : '',
      },
      'service': {
        'id': service?.id ?? '',
        'name': service?.name ?? 'Unknown Service',
        'price': service?.price ?? 0.0,
        'duration': service?.duration ?? 0,
      },
      'booking': {
        'date': selectedDate,
        'time': selectedTime,
        'type': bookingType,
        'professional': selectedProfessional,
        'address': bookingType == 'home' ? selectedAddress : null,
        'salon': selectedSalon,
      },
      'amount': double.tryParse(selectedService?['price']?.toString().replaceAll('₹', '').replaceAll(',', '') ?? '0') ?? 0.0,
    };

    // Navigate to simple payment screen
    Navigator.of(context).pushNamed(
      AppRoutes.paymentCheckout,
      arguments: bookingData,
    ).then((_) {
      // After payment, close this screen and go to booking history
      AppRouter.pushNamedAndClearStack(AppRoutes.bookingHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: stepTitles[currentStep],
      onWillPop: _onWillPop,
      showBottomNavigation: false,
      leading: IconButton(
        icon: Icon(
          currentStep > 0 ? Icons.arrow_back : Icons.close,
          color: context.textHighEmphasisColor,
          size: context.responsiveIconSize,
        ),
        onPressed: () {
          if (currentStep > 0) {
            _previousStep();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        if (currentStep < stepTitles.length - 1)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: context.bodyMedium.copyWith(
                color: context.errorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
      floatingActionButton: currentStep < stepTitles.length - 1
          ? Container(
              width: double.infinity,
              margin: context.responsivePadding,
              child: ElevatedButton(
                onPressed: _canProceedToNext() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.responsiveBorderRadius,
                  ),
                ),
                child: Text(
                  'Continue',
                  style: context.titleMedium.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
      child: Column(
        children: [
          // Progress Indicator
          Container(
            padding: context.horizontalPadding,
            color: context.surfaceColor,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: context.dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    );
                  },
                ),
                SizedBox(height: context.responsiveSmallSpacing),
              ],
            ),
          ),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Service Selection
                ServiceSelectionWidget(
                  selectedService: selectedService,
                  onServiceSelected: (service) {
                    setState(() {
                      selectedService = service;
                    });
                  },
                ),

                // Step 2: Professional Selection (COMMENTED OUT)
                // ProfessionalSelectionWidget(
                //   selectedProfessional: selectedProfessional,
                //   onProfessionalSelected: (professional) {
                //     setState(() {
                //       selectedProfessional = professional;
                //     });
                //   },
                // ),

                // Step 2: Date & Time Selection (was Step 3)
                DateTimeSelectionWidget(
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  onDateTimeSelected: (date, time) {
                    setState(() {
                      selectedDate = date;
                      selectedTime = time;
                    });
                  },
                ),

                // Step 3: Booking Type Selection (was Step 4)
                BookingTypeWidget(
                  selectedType: bookingType,
                  selectedAddress: selectedAddress,
                  selectedSalon: selectedSalon,
                  onBookingTypeSelected: (type, address, salon) {
                    setState(() {
                      bookingType = type;
                      selectedAddress = address;
                      selectedSalon = salon;
                    });
                  },
                ),

                // Step 4: Booking Summary (was Step 5)
                BookingSummaryWidget(
                  selectedService: selectedService,
                  selectedProfessional: selectedProfessional,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  bookingType: bookingType,
                  address: selectedAddress,
                  selectedSalon: selectedSalon,
                  onConfirmBooking: _confirmBooking,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
