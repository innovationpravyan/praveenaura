import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BookingTypeWidget extends StatefulWidget {
  final Function(String, String?) onBookingTypeSelected;
  final String? selectedType;
  final String? selectedAddress;

  const BookingTypeWidget({
    super.key,
    required this.onBookingTypeSelected,
    this.selectedType,
    this.selectedAddress,
  });

  @override
  State<BookingTypeWidget> createState() => _BookingTypeWidgetState();
}

class _BookingTypeWidgetState extends State<BookingTypeWidget> {
  String selectedBookingType = 'salon';
  final TextEditingController _addressController = TextEditingController();
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedBookingType = widget.selectedType ?? 'salon';
    selectedAddress = widget.selectedAddress;
    if (selectedAddress != null) {
      _addressController.text = selectedAddress!;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Type',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textHighEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Choose where you\'d like to receive your service',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveLargeSpacing),

          // Booking Type Selection
          Row(
            children: [
              Expanded(
                child: _buildBookingTypeCard(
                  type: 'salon',
                  title: 'Salon Visit',
                  subtitle: 'Visit our salon location',
                  icon: Icons.store,
                ),
              ),
              SizedBox(width: 3.w(context)),
              Expanded(
                child: _buildBookingTypeCard(
                  type: 'home',
                  title: 'Home Service',
                  subtitle: 'Professional comes to you',
                  icon: Icons.home,
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveLargeSpacing),

          // Salon Information
          if (selectedBookingType == 'salon') ...[
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
                        Icons.location_on,
                        color: context.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 2.w(context)),
                      Text(
                        'Salon Location',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.componentSpacing),
                  Text(
                    'Aura Beauty Salon\n123 Beauty Street, Downtown\nNew York, NY 10001',
                    style: context.bodyMedium.copyWith(
                      color: context.textHighEmphasisColor,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: context.componentSpacing),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: context.textMediumEmphasisColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w(context)),
                      Text(
                        'Please arrive 10 minutes early',
                        style: context.bodySmall.copyWith(
                          color: context.textMediumEmphasisColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Home Service Address Input
          if (selectedBookingType == 'home') ...[
            Text(
              'Service Address',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textHighEmphasisColor,
              ),
            ),
            SizedBox(height: context.componentSpacing),

            TextFormField(
              controller: _addressController,
              decoration: context.getInputDecoration(
                hintText: 'Enter your complete address',
                labelText: 'Home Address',
                prefixIcon: const Icon(Icons.home),
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  selectedAddress = value.isNotEmpty ? value : null;
                });
                widget.onBookingTypeSelected(
                  selectedBookingType,
                  selectedAddress,
                );
              },
            ),

            SizedBox(height: context.responsiveSmallSpacing),

            // Home Service Info
            Container(
              padding: context.responsiveCardPadding,
              decoration: context.cardDecoration,
              child: Column(
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
                        'Home Service Information',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.textHighEmphasisColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.componentSpacing),
                  _buildInfoRow('Additional travel fee: \$15'),
                  _buildInfoRow('Estimated travel time: 15-30 minutes'),
                  _buildInfoRow('Professional will call upon arrival'),
                  _buildInfoRow('Please ensure adequate lighting and space'),
                ],
              ),
            ),
          ],

          SizedBox(height: context.responsiveLargeSpacing),

          // Service Area Notice for Home Service
          if (selectedBookingType == 'home') ...[
            Container(
              padding: EdgeInsets.all(3.w(context)),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  SizedBox(width: 2.w(context)),
                  Expanded(
                    child: Text(
                      'Home services available within 25 miles of salon location',
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
    );
  }

  Widget _buildBookingTypeCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedBookingType == type;

    return InkWell(
      onTap: () {
        setState(() {
          selectedBookingType = type;
          if (type == 'salon') {
            selectedAddress = null;
            _addressController.clear();
          }
        });
        widget.onBookingTypeSelected(type, selectedAddress);
      },
      borderRadius: context.responsiveBorderRadius,
      child: Container(
        padding: context.responsiveCardPadding,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: context.responsiveBorderRadius,
          border: Border.all(
            color: isSelected ? context.primaryColor : context.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w(context)),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.primaryColor.withOpacity(0.1)
                    : context.dividerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? context.primaryColor
                    : context.textMediumEmphasisColor,
                size: 32,
              ),
            ),
            SizedBox(height: context.responsiveSmallSpacing),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textHighEmphasisColor,
              ),
            ),
            SizedBox(height: 0.5.h(context)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h(context)),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: context.textMediumEmphasisColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w(context)),
          Expanded(
            child: Text(
              text,
              style: context.bodySmall.copyWith(
                color: context.textMediumEmphasisColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
