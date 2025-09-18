import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/salon_model.dart';
import '../../../providers/salon_provider.dart';

class BookingTypeWidget extends ConsumerStatefulWidget {
  final Function(String, String?, SalonModel?) onBookingTypeSelected;
  final String? selectedType;
  final String? selectedAddress;
  final SalonModel? selectedSalon;

  const BookingTypeWidget({
    super.key,
    required this.onBookingTypeSelected,
    this.selectedType,
    this.selectedAddress,
    this.selectedSalon,
  });

  @override
  ConsumerState<BookingTypeWidget> createState() => _BookingTypeWidgetState();
}

class _BookingTypeWidgetState extends ConsumerState<BookingTypeWidget> {
  String selectedBookingType = 'salon';
  final TextEditingController _addressController = TextEditingController();
  String? selectedAddress;
  SalonModel? selectedSalon;

  @override
  void initState() {
    super.initState();
    selectedBookingType = widget.selectedType ?? 'salon';
    selectedAddress = widget.selectedAddress;
    selectedSalon = widget.selectedSalon;
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
      child: SingleChildScrollView(
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

            // Salon Selection
            if (selectedBookingType == 'salon') ...[
              Text(
                'Select Salon',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textHighEmphasisColor,
                ),
              ),
              SizedBox(height: context.responsiveSmallSpacing),
              Text(
                'Choose a salon location for your appointment',
                style: context.bodyMedium.copyWith(
                  color: context.textMediumEmphasisColor,
                ),
              ),
              SizedBox(height: context.responsiveSpacing),
              _buildSalonsList(),
              SizedBox(height: context.responsiveSpacing),

              // Selected Salon Information
              if (selectedSalon != null) ...[
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
                          Expanded(
                            child: Text(
                              selectedSalon!.displayName,
                              style: context.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                          if (selectedSalon!.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, color: Colors.blue, size: 12),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: context.componentSpacing),
                      Text(
                        selectedSalon!.fullAddress,
                        style: context.bodyMedium.copyWith(
                          color: context.textHighEmphasisColor,
                          height: 1.4,
                        ),
                      ),
                      if (selectedSalon!.phoneNumber.isNotEmpty) ...[
                        SizedBox(height: context.responsiveSmallSpacing),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: context.textMediumEmphasisColor,
                              size: 16,
                            ),
                            SizedBox(width: 1.w(context)),
                            Text(
                              selectedSalon!.phoneNumber,
                              style: context.bodySmall.copyWith(
                                color: context.textMediumEmphasisColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: context.responsiveSmallSpacing),
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
                    selectedSalon,
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
                    _buildInfoRow('Additional travel fee: ₹15'),
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
          } else {
            selectedSalon = null;
          }
        });
        widget.onBookingTypeSelected(type, selectedAddress, selectedSalon);
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

  Widget _buildSalonsList() {
    final salonState = ref.watch(salonProvider);
    final activeSalons = salonState.salons.where((salon) => salon.isActive).toList();

    if (activeSalons.isEmpty) {
      return Container(
        padding: context.responsiveCardPadding,
        decoration: context.cardDecoration,
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: context.textMediumEmphasisColor,
              size: 20,
            ),
            SizedBox(width: 2.w(context)),
            Text(
              'No salons available at the moment',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: context.responsiveBorderRadius,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: activeSalons.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: context.dividerColor,
        ),
        itemBuilder: (context, index) {
          final salon = activeSalons[index];
          final isSelected = selectedSalon?.id == salon.id;

          return InkWell(
            onTap: () {
              setState(() {
                selectedSalon = salon;
              });
              widget.onBookingTypeSelected(
                selectedBookingType,
                selectedAddress,
                selectedSalon,
              );
            },
            child: Container(
              padding: context.responsiveCardPadding,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: index == 0
                    ? BorderRadius.vertical(top: context.responsiveBorderRadius.topLeft)
                    : index == activeSalons.length - 1
                    ? BorderRadius.vertical(bottom: context.responsiveBorderRadius.bottomLeft)
                    : null,
              ),
              child: Row(
                children: [
                  // Salon image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: context.primaryColor.withOpacity(0.1),
                      child: salon.images.isNotEmpty
                          ? Image.network(
                              salon.primaryImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.store,
                                    color: context.primaryColor,
                                    size: 24,
                                  ),
                            )
                          : Icon(
                              Icons.store,
                              color: context.primaryColor,
                              size: 24,
                            ),
                    ),
                  ),
                  SizedBox(width: 3.w(context)),

                  // Salon details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                salon.displayName,
                                style: context.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.textHighEmphasisColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (salon.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified, color: Colors.blue, size: 10),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h(context)),

                        // Rating and status
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 14,
                            ),
                            SizedBox(width: 1.w(context)),
                            Text(
                              salon.ratingText,
                              style: context.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2.w(context)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: salon.isOpen
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                salon.isOpen ? 'Open' : 'Closed',
                                style: TextStyle(
                                  color: salon.isOpen ? Colors.green : Colors.red,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h(context)),

                        // Address
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: context.textMediumEmphasisColor,
                              size: 12,
                            ),
                            SizedBox(width: 1.w(context)),
                            Expanded(
                              child: Text(
                                salon.shortAddress,
                                style: context.bodySmall.copyWith(
                                  color: context.textMediumEmphasisColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(1.w(context)),
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
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
