import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:aurame/core/extensions/date_extensions.dart';
import 'package:flutter/material.dart';

class BookingSummaryWidget extends StatelessWidget {
  final Map<String, dynamic>? selectedService;
  final Map<String, dynamic>? selectedProfessional;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? bookingType;
  final String? address;
  final VoidCallback onConfirmBooking;

  const BookingSummaryWidget({
    super.key,
    this.selectedService,
    this.selectedProfessional,
    this.selectedDate,
    this.selectedTime,
    this.bookingType,
    this.address,
    required this.onConfirmBooking,
  });

  @override
  Widget build(BuildContext context) {
    final travelFee = bookingType == 'home' ? 15.0 : 0.0;
    final servicePrice = selectedService != null
        ? double.tryParse(
                selectedService!["price"].toString().replaceAll('\$', ''),
              ) ??
              0.0
        : 0.0;
    final totalPrice = servicePrice + travelFee;

    return Container(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textHighEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Please review your booking details before confirming',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveLargeSpacing),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Service Details
                  _buildSummaryCard(
                    context: context,
                    title: 'Service Details',
                    icon: Icons.spa,
                    children: [
                      if (selectedService != null) ...[
                        _buildDetailRow(
                          context,
                          'Service',
                          selectedService!["name"],
                        ),
                        _buildDetailRow(
                          context,
                          'Duration',
                          selectedService!["duration"],
                        ),
                        _buildDetailRow(
                          context,
                          'Price',
                          selectedService!["price"],
                        ),
                      ] else
                        _buildDetailRow(context, 'Service', 'Not selected'),
                    ],
                  ),

                  SizedBox(height: context.responsiveSmallSpacing),

                  // Professional Details
                  _buildSummaryCard(
                    context: context,
                    title: 'Professional',
                    icon: Icons.person,
                    children: [
                      if (selectedProfessional != null) ...[
                        _buildDetailRow(
                          context,
                          'Professional',
                          selectedProfessional!["name"],
                        ),
                        if (selectedProfessional!["rating"] != null)
                          _buildDetailRow(
                            context,
                            'Rating',
                            '${selectedProfessional!["rating"]} ⭐',
                          ),
                        if (selectedProfessional!["experience"] != null)
                          _buildDetailRow(
                            context,
                            'Experience',
                            selectedProfessional!["experience"],
                          ),
                      ] else
                        _buildDetailRow(
                          context,
                          'Professional',
                          'Not selected',
                        ),
                    ],
                  ),

                  SizedBox(height: context.responsiveSmallSpacing),

                  // Date & Time Details
                  _buildSummaryCard(
                    context: context,
                    title: 'Date & Time',
                    icon: Icons.schedule,
                    children: [
                      if (selectedDate != null && selectedTime != null) ...[
                        _buildDetailRow(
                          context,
                          'Date',
                          selectedDate!.formatted,
                        ),
                        _buildDetailRow(context, 'Time', selectedTime!),
                        _buildDetailRow(context, 'Day', selectedDate!.dayName),
                      ] else ...[
                        _buildDetailRow(context, 'Date', 'Not selected'),
                        _buildDetailRow(context, 'Time', 'Not selected'),
                      ],
                    ],
                  ),

                  SizedBox(height: context.responsiveSmallSpacing),

                  // Location Details
                  _buildSummaryCard(
                    context: context,
                    title: 'Location',
                    icon: bookingType == 'home' ? Icons.home : Icons.store,
                    children: [
                      _buildDetailRow(
                        context,
                        'Type',
                        bookingType == 'home' ? 'Home Service' : 'Salon Visit',
                      ),
                      if (bookingType == 'home' && address != null)
                        _buildDetailRow(context, 'Address', address!)
                      else if (bookingType == 'salon')
                        _buildDetailRow(
                          context,
                          'Address',
                          'Aura Beauty Salon\n123 Beauty Street, Downtown\nNew York, NY 10001',
                        ),
                    ],
                  ),

                  SizedBox(height: context.responsiveSmallSpacing),

                  // Price Breakdown
                  _buildSummaryCard(
                    context: context,
                    title: 'Price Breakdown',
                    icon: Icons.receipt,
                    children: [
                      _buildDetailRow(
                        context,
                        'Service Fee',
                        '\$${servicePrice.toStringAsFixed(2)}',
                      ),
                      if (travelFee > 0)
                        _buildDetailRow(
                          context,
                          'Travel Fee',
                          '\$${travelFee.toStringAsFixed(2)}',
                        ),
                      Divider(color: context.dividerColor, thickness: 1),
                      _buildDetailRow(
                        context,
                        'Total',
                        '\$${totalPrice.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),

                  SizedBox(height: context.responsiveLargeSpacing),

                  // Important Notes
                  Container(
                    padding: context.responsiveCardPadding,
                    decoration: BoxDecoration(
                      color: context.primaryColor.withOpacity(0.05),
                      borderRadius: context.responsiveBorderRadius,
                      border: Border.all(
                        color: context.primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: context.primaryColor,
                              size: 20,
                            ),
                            SizedBox(width: 2.w(context)),
                            Text(
                              'Important Notes',
                              style: context.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.componentSpacing),
                        _buildNoteItem(
                          context,
                          'Cancellation allowed up to 24 hours before appointment',
                        ),
                        _buildNoteItem(
                          context,
                          'Please arrive 10 minutes early for salon visits',
                        ),
                        if (bookingType == 'home')
                          _buildNoteItem(
                            context,
                            'Professional will call upon arrival for home services',
                          ),
                        _buildNoteItem(
                          context,
                          'Payment will be processed after service completion',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: context.responsiveSmallSpacing),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isBookingComplete() ? onConfirmBooking : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: context.responsiveBorderRadius,
                ),
              ),
              child: Text(
                'Confirm Booking',
                style: context.titleMedium.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: context.responsiveCardPadding,
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w(context)),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: context.primaryColor, size: 20),
              ),
              SizedBox(width: 3.w(context)),
              Text(
                title,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textHighEmphasisColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.componentSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w(context),
            child: Text(
              label,
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.bodyMedium.copyWith(
                color: context.textHighEmphasisColor,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(BuildContext context, String note) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.8.h(context)),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: context.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w(context)),
          Expanded(
            child: Text(
              note,
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isBookingComplete() {
    return selectedService != null &&
        selectedProfessional != null &&
        selectedDate != null &&
        selectedTime != null &&
        bookingType != null &&
        (bookingType != 'home' || address != null);
  }
}
