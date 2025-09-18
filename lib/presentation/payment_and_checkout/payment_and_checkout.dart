/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config/app_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/services/razorpay_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/new_payment_form.dart';
import './widgets/payment_breakdown_card.dart';
import './widgets/promo_code_section.dart';
import './widgets/saved_payment_methods.dart';
import './widgets/service_summary_card.dart';
import './widgets/tip_selection_widget.dart';

class PaymentAndCheckout extends ConsumerStatefulWidget {
  final Map<String, dynamic>? bookingData;

  const PaymentAndCheckout({super.key, this.bookingData});

  @override
  ConsumerState<PaymentAndCheckout> createState() => _PaymentAndCheckoutState();
}

class _PaymentAndCheckoutState extends ConsumerState<PaymentAndCheckout> {
  bool _isProcessingPayment = false;
  Map<String, dynamic>? _selectedPaymentMethod;
  Map<String, dynamic>? _newPaymentData;
  double _tipAmount = 0.0;
  double _discountAmount = 0.0;
  bool _showNewPaymentForm = false;

  // Mock booking data - will be overridden if bookingData is passed
  late Map<String, dynamic> _bookingData;

  // Payment calculation data
  late Map<String, dynamic> _paymentData;

  @override
  void initState() {
    super.initState();

    // Use passed booking data or fallback to mock data
    _bookingData =
        widget.bookingData ??
        {
          "salon": {
            "id": "salon_1",
            "name": "Luxe Beauty Salon",
            "image":
                "https://images.unsplash.com/photo-1560066984-138dadb4c035?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
            "address": "123 Beauty Street, Downtown",
            "rating": 4.8,
          },
          "services": [
            {
              "id": "service_1",
              "name": "Hair Cut & Style",
              "price": "₹65.00",
              "duration": "60 min",
            },
            {
              "id": "service_2",
              "name": "Hair Color",
              "price": "₹120.00",
              "duration": "120 min",
            },
          ],
          "date": "Dec 15, 2024",
          "time": "2:30 PM",
          "type": "salon_visit",
        };

    _calculatePaymentBreakdown();
  }

  void _calculatePaymentBreakdown() {
    // Calculate service cost from booking data
    double serviceCost = 0.0;
    if (_bookingData['services'] != null) {
      final services = _bookingData['services'] as List;
      for (var service in services) {
        final priceString = service['price'] as String;
        // Extract numeric value from price string (e.g., "₹65.00" -> 65.0)
        final priceValue =
            double.tryParse(priceString.replaceAll(RegExp(r'[^\d.]'), '')) ??
            0.0;
        serviceCost += priceValue;
      }
    }

    // Fallback to default if no services found
    if (serviceCost == 0.0) {
      serviceCost = 185.00; // Default fallback
    }

    final platformFee = 5.00;
    final taxes = serviceCost * 0.08; // 8% tax
    final discount = _discountAmount;
    final tip = _tipAmount;

    final total = serviceCost + platformFee + taxes - discount + tip;

    _paymentData = {
      "serviceCost": "\${serviceCost.toStringAsFixed(2)}",
      "platformFee": "\${platformFee.toStringAsFixed(2)}",
      "taxes": "\${taxes.toStringAsFixed(2)}",
      "discount": "\${discount.toStringAsFixed(2)}",
      "tip": "\${tip.toStringAsFixed(2)}",
      "total": "\${total.toStringAsFixed(2)}",
      "totalAmount": total,
    };
  }

  void _onPaymentMethodSelected(Map<String, dynamic>? method) {
    setState(() {
      _selectedPaymentMethod = method;
      _showNewPaymentForm = method == null;
    });
  }

  void _onNewPaymentDataChanged(Map<String, dynamic> data) {
    setState(() {
      _newPaymentData = data;
    });
  }

  void _onTipChanged(double tipAmount) {
    setState(() {
      _tipAmount = tipAmount;
      _calculatePaymentBreakdown();
    });
  }

  void _onDiscountApplied(double discountAmount) {
    setState(() {
      _discountAmount = discountAmount;
      _calculatePaymentBreakdown();
    });
  }

  double _getServiceAmount() {
    double serviceCost = 0.0;
    if (_bookingData['services'] != null) {
      final services = _bookingData['services'] as List;
      for (var service in services) {
        final priceString = service['price'] as String;
        // Extract numeric value from price string (e.g., "₹65.00" -> 65.0)
        final priceValue =
            double.tryParse(priceString.replaceAll(RegExp(r'[^\d.]'), '')) ??
            0.0;
        serviceCost += priceValue;
      }
    }
    return serviceCost > 0 ? serviceCost : 185.00; // Fallback to default
  }

  bool _canProcessPayment() {
    if (_selectedPaymentMethod != null) return true;
    if (_newPaymentData != null &&
        (_newPaymentData!["isValid"] as bool? ?? false))
      return true;
    return false;
  }

  Future<void> _processPayment() async {
    final authState = ref.read(authProvider);
    if (authState.user == null) {
      context.showErrorSnackBar('Please login to process payment');
      return;
    }

    if (!_canProcessPayment()) {
      Fluttertoast.showToast(
        msg: "Please select a payment method",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final bookingId = _bookingData['bookingId'] as String?;
      final totalAmount = _paymentData['total'] as double;

      if (bookingId != null) {
        // Update booking payment status to processing
        final bookingNotifier = ref.read(bookingProvider.notifier);
        await bookingNotifier.updateBookingPaymentStatus(
          bookingId,
          'processing',
          null, // paymentId will be set after successful payment
        );

        // Initialize Razorpay service
        final razorpayService = RazorpayService();
        razorpayService.initialize();

        // Process payment with Razorpay
        await razorpayService.startPayment(
          amount: totalAmount,
          name: authState.user!.displayName ?? 'Customer',
          email: authState.user!.email ?? '',
          phone: authState.user!.phoneNumber ?? '',
          description: 'Payment for ${_bookingData['service']?['name'] ?? 'Service'}',
          onSuccess: (response) async {
            // Payment successful
            await bookingNotifier.updateBookingPaymentStatus(
              bookingId,
              'completed',
              response.paymentId,
            );
            _handlePaymentSuccess(response.paymentId!);
          },
          onError: (response) {
            // Payment failed
            bookingNotifier.updateBookingPaymentStatus(
              bookingId,
              'failed',
              null,
            );
            _handlePaymentError(response.message ?? 'Payment failed');
          },
        );
      } else {
        // Fallback to simulated payment for testing
        await Future.delayed(const Duration(seconds: 2));
        _handlePaymentSuccess('test_payment_id');
      }

      // Provide haptic feedback for success
      HapticFeedback.lightImpact();

    } catch (e) {
      setState(() {
        _isProcessingPayment = false;
      });
      _handlePaymentError('Payment failed: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(String paymentId) {
    setState(() {
      _isProcessingPayment = false;
    });

    // Show success message
    Fluttertoast.showToast(
      msg: "Payment successful! Booking confirmed.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    // Navigate to booking history or success screen
    Navigator.of(context).pop(); // Close payment screen
    AppRouter.pushNamedAndClearStack(AppRoutes.bookingHistory);
  }

  void _handlePaymentError(String error) {
    setState(() {
      _isProcessingPayment = false;
    });

    // Show error message
    Fluttertoast.showToast(
      msg: error,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      // Navigate to success screen or back to home
      if (mounted) {
        context.navigateToHomeInitial();
      }
    } catch (e) {
      // Handle payment failure
      Fluttertoast.showToast(
        msg: "Payment failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showBottomNavigation: false,
      title: 'Payment & Checkout',
      actions: [
        Container(
          margin: EdgeInsets.only(right: context.responsiveSpacing),
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveSmallSpacing,
            vertical: context.elementSpacing,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'security',
                size: 16,
                color: context.colorScheme.tertiary,
              ),
              SizedBox(width: context.elementSpacing),
              Text(
                'Secure',
                style: context.labelSmall.copyWith(
                  color: context.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: context.componentSpacing),
                  ServiceSummaryCard(bookingData: _bookingData),
                  PaymentBreakdownCard(paymentData: _paymentData),
                  TipSelectionWidget(
                    serviceAmount: _getServiceAmount(),
                    onTipChanged: _onTipChanged,
                  ),
                  PromoCodeSection(onDiscountApplied: _onDiscountApplied),
                  SizedBox(height: context.sectionSpacing),
                  if (!_showNewPaymentForm)
                    SavedPaymentMethods(
                      onPaymentMethodSelected: _onPaymentMethodSelected,
                    )
                  else
                    NewPaymentForm(
                      onPaymentDataChanged: _onNewPaymentDataChanged,
                    ),
                  SizedBox(height: context.beautyImageHeight * 0.6),
                  // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(context.responsiveSpacing),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: context.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.textHighEmphasisColor,
                    ),
                  ),
                  Text(
                    _paymentData["total"] as String,
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.sectionSpacing),
              SizedBox(
                width: double.infinity,
                height: context.responsiveListTileHeight * 0.8,
                child: ElevatedButton(
                  onPressed: _isProcessingPayment ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canProcessPayment()
                        ? context.primaryColor
                        : context.textHighEmphasisColor.withOpacity(0.3),
                    foregroundColor: _canProcessPayment()
                        ? context.colorScheme.onPrimary
                        : context.textHighEmphasisColor.withOpacity(0.6),
                    elevation: _canProcessPayment() ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.responsiveBorderRadius,
                    ),
                  ),
                  child: _isProcessingPayment
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: context.responsiveSmallIconSize,
                              height: context.responsiveSmallIconSize,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: context.responsiveSmallSpacing),
                            Text(
                              'Processing Payment...',
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'lock',
                              size: 20,
                              color: context.colorScheme.onPrimary,
                            ),
                            SizedBox(width: context.componentSpacing),
                            Text(
                              'Pay Now',
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: context.componentSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'verified_user',
                    size: 16,
                    color: context.textMediumEmphasisColor,
                  ),
                  SizedBox(width: context.elementSpacing),
                  Text(
                    'Your payment is protected by 256-bit SSL encryption',
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
