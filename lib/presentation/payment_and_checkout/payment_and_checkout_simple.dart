import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config/app_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/base_screen.dart';

class PaymentAndCheckoutSimple extends ConsumerStatefulWidget {
  final Map<String, dynamic>? bookingData;

  const PaymentAndCheckoutSimple({super.key, this.bookingData});

  @override
  ConsumerState<PaymentAndCheckoutSimple> createState() => _PaymentAndCheckoutSimpleState();
}

class _PaymentAndCheckoutSimpleState extends ConsumerState<PaymentAndCheckoutSimple> {
  bool _isProcessingPayment = false;
  String _selectedPaymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showBottomNavigation: false,
      title: 'Payment & Checkout',
      child: SingleChildScrollView(
        padding: context.responsiveContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Booking Summary
            _buildBookingSummary(),

            SizedBox(height: context.responsiveSpacing),

            // Payment Methods
            _buildPaymentMethods(),

            SizedBox(height: context.responsiveSpacing),

            // Payment Button
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    final salon = widget.bookingData?['booking']?['salon'];
    final service = widget.bookingData?['service'];
    final booking = widget.bookingData?['booking'];

    return Container(
      padding: context.responsiveCardPadding,
      decoration: context.elegantContainerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: context.primaryColor,
                size: 20,
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Booking Summary',
                style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSpacing),

          // Service Details
          _buildSummaryRow('Service', service?['name'] ?? 'Hair Cut'),
          if (service?['duration'] != null)
            _buildSummaryRow('Duration', '${service['duration']} minutes'),

          // Salon Details
          _buildSummaryRow('Salon', widget.bookingData?['salon']?['name'] ?? 'Beauty Salon'),
          if (salon != null && salon is Map)
            _buildSummaryRow('Location', salon['fullAddress'] ?? salon['address'] ?? 'Salon Location'),

          // Booking Details
          _buildSummaryRow('Date', _formatDate(booking?['date'])),
          _buildSummaryRow('Time', booking?['time'] ?? '2:00 PM'),
          _buildSummaryRow('Type', booking?['type'] == 'home' ? 'Home Service' : 'Salon Visit'),

          if (booking?['type'] == 'home' && booking?['address'] != null)
            _buildSummaryRow('Service Address', booking['address']),

          const Divider(),
          _buildSummaryRow('Total Amount', '₹${widget.bookingData?['amount']?.toInt() ?? 500}', isTotal: true),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Today';
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return date.toString().split(' ')[0];
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? context.titleSmall.copyWith(fontWeight: FontWeight.bold)
                : context.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? context.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  )
                : context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: context.responsiveCardPadding,
      decoration: context.elegantContainerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment,
                color: context.primaryColor,
                size: 20,
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Text(
                'Payment Method',
                style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSpacing),
          _buildPaymentOption('card', 'Credit/Debit Card', Icons.credit_card),
          _buildPaymentOption('upi', 'UPI', Icons.account_balance_wallet),
          _buildPaymentOption('netbanking', 'Net Banking', Icons.account_balance),

          // Pay Later Option
          _buildPayLaterOption(),
        ],
      ),
    );
  }

  Widget _buildPayLaterOption() {
    final isSelected = _selectedPaymentMethod == 'pay_later';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = 'pay_later';
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange : context.dividerColor,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: isSelected ? Colors.orange : context.textMediumEmphasisColor,
                ),
                SizedBox(width: context.responsiveSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pay Later',
                        style: context.bodyMedium.copyWith(
                          color: isSelected ? Colors.orange : context.textHighEmphasisColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Pay with cash during service',
                        style: context.bodySmall.copyWith(
                          color: isSelected ? Colors.orange.shade700 : context.textMediumEmphasisColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.orange,
                  ),
              ],
            ),
            if (isSelected) ...[
              SizedBox(height: context.responsiveSmallSpacing),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 16,
                    ),
                    SizedBox(width: context.responsiveSmallSpacing),
                    Expanded(
                      child: Text(
                        'You can pay with cash when the service is completed. Please have exact change ready.',
                        style: context.bodySmall.copyWith(
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? context.primaryColor : context.dividerColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.primaryColor : context.textMediumEmphasisColor,
            ),
            SizedBox(width: context.responsiveSpacing),
            Expanded(
              child: Text(
                title,
                style: context.bodyMedium.copyWith(
                  color: isSelected ? context.primaryColor : context.textHighEmphasisColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    final isPayLater = _selectedPaymentMethod == 'pay_later';
    final amount = widget.bookingData?['amount']?.toInt() ?? 500;

    return ElevatedButton(
      onPressed: _isProcessingPayment ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPayLater ? Colors.orange : context.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: context.responsiveSpacing),
        shape: RoundedRectangleBorder(
          borderRadius: context.responsiveBorderRadius,
        ),
      ),
      child: _isProcessingPayment
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: context.responsiveSpacing),
                Text(isPayLater ? 'Confirming Booking...' : 'Processing Payment...'),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPayLater ? Icons.schedule : Icons.lock,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: context.responsiveSmallSpacing),
                Text(
                  isPayLater
                      ? 'Confirm Booking - Pay ₹$amount Later'
                      : 'Pay ₹$amount Now',
                  style: context.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _processPayment() async {
    final isPayLater = _selectedPaymentMethod == 'pay_later';

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      if (isPayLater) {
        // Handle pay later booking
        await _confirmPayLaterBooking();
      } else {
        // Handle regular payment processing
        await _processRegularPayment();
      }

      // Provide haptic feedback for success
      HapticFeedback.lightImpact();

      // Navigate to booking history
      if (mounted) {
        AppRouter.pushNamedAndClearStack(AppRoutes.bookingHistory);
      }
    } catch (e) {
      // Handle failure
      final errorMessage = isPayLater
          ? "Booking confirmation failed. Please try again."
          : "Payment failed. Please try again.";

      Fluttertoast.showToast(
        msg: errorMessage,
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

  Future<void> _confirmPayLaterBooking() async {
    // Simulate booking confirmation
    await Future.delayed(const Duration(seconds: 2));

    // Show success message for pay later
    Fluttertoast.showToast(
      msg: "Booking confirmed! Pay with cash during service.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    // Here you would update the booking status to 'confirmed' with payment_method: 'cash'
    // and payment_status: 'pending'
  }

  Future<void> _processRegularPayment() async {
    // Simulate regular payment processing
    await Future.delayed(const Duration(seconds: 3));

    // Show success message for regular payment
    Fluttertoast.showToast(
      msg: "Payment successful! Booking confirmed.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    // Here you would process the actual payment and update booking status
  }
}