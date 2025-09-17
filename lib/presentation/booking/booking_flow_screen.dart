import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../config/app_router.dart';
import '../../widgets/base_screen.dart';
import './widgets/booking_summary_widget.dart';
import './widgets/booking_type_widget.dart';
import './widgets/date_time_selection_widget.dart';
import './widgets/professional_selection_widget.dart';
import './widgets/service_selection_widget.dart';

class BookingFlowScreen extends StatefulWidget {
  final String? salonId;
  final String? serviceId;

  const BookingFlowScreen({super.key, this.salonId, this.serviceId});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen>
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

  final List<String> stepTitles = [
    'Select Service',
    'Choose Professional',
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
      case 1:
        return selectedProfessional != null;
      case 2:
        return selectedDate != null && selectedTime != null;
      case 3:
        return bookingType != null &&
            (bookingType != 'home' || selectedAddress != null);
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _confirmBooking() {
    // Show loading dialog
    context.showLoadingDialog(message: 'Confirming your booking...');

    // Simulate booking process
    Future.delayed(const Duration(seconds: 2), () {
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
                'Booking ID: #BK${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
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
                // Navigate to payment screen if available
                context.showInfoSnackBar(
                  'Payment functionality will be implemented soon',
                );
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      );
    });
  }

  Future<bool> _onWillPop() async {
    if (currentStep > 0) {
      _previousStep();
      return false;
    }
    return true;
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

                // Step Indicator
                Row(
                  children: List.generate(stepTitles.length, (index) {
                    final isActive = index == currentStep;
                    final isCompleted = index < currentStep;

                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index < stepTitles.length - 1
                              ? 1.w(context)
                              : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted || isActive
                              ? context.primaryColor
                              : context.dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
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

                // Step 2: Professional Selection
                ProfessionalSelectionWidget(
                  selectedProfessional: selectedProfessional,
                  onProfessionalSelected: (professional) {
                    setState(() {
                      selectedProfessional = professional;
                    });
                  },
                ),

                // Step 3: Date & Time Selection
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

                // Step 4: Booking Type Selection
                BookingTypeWidget(
                  selectedType: bookingType,
                  selectedAddress: selectedAddress,
                  onBookingTypeSelected: (type, address) {
                    setState(() {
                      bookingType = type;
                      selectedAddress = address;
                    });
                  },
                ),

                // Step 5: Booking Summary
                BookingSummaryWidget(
                  selectedService: selectedService,
                  selectedProfessional: selectedProfessional,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  bookingType: bookingType,
                  address: selectedAddress,
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
