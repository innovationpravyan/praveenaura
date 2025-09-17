import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_image_widget.dart';

class ProfessionalSelectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onProfessionalSelected;
  final Map<String, dynamic>? selectedProfessional;

  const ProfessionalSelectionWidget({
    super.key,
    required this.onProfessionalSelected,
    this.selectedProfessional,
  });

  @override
  State<ProfessionalSelectionWidget> createState() =>
      _ProfessionalSelectionWidgetState();
}

class _ProfessionalSelectionWidgetState
    extends State<ProfessionalSelectionWidget> {
  Map<String, dynamic>? selectedProfessional;

  final List<Map<String, dynamic>> professionals = [
    {
      "id": "any",
      "name": "Any Available Professional",
      "type": "any",
      "description": "Book with the next available professional",
      "rating": null,
      "experience": null,
      "image": null,
      "specialties": <String>[],
    },
    {
      "id": "sarah",
      "name": "Sarah Johnson",
      "type": "specific",
      "description": "Senior Hair Stylist & Color Specialist",
      "rating": 4.9,
      "experience": "8 years",
      "image":
          "https://images.pexels.com/photos/3992656/pexels-photo-3992656.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specialties": ["Hair Coloring", "Styling", "Treatments"],
    },
    {
      "id": "maria",
      "name": "Maria Rodriguez",
      "type": "specific",
      "description": "Master Nail Technician & Nail Artist",
      "rating": 4.8,
      "experience": "6 years",
      "image":
          "https://images.pexels.com/photos/3785077/pexels-photo-3785077.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specialties": ["Nail Art", "Gel Nails", "Pedicures"],
    },
    {
      "id": "emily",
      "name": "Emily Chen",
      "type": "specific",
      "description": "Licensed Esthetician & Skincare Expert",
      "rating": 4.9,
      "experience": "10 years",
      "image":
          "https://images.pexels.com/photos/3762800/pexels-photo-3762800.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specialties": ["Facials", "Anti-Aging", "Acne Treatment"],
    },
    {
      "id": "jessica",
      "name": "Jessica Williams",
      "type": "specific",
      "description": "Certified Massage Therapist",
      "rating": 4.7,
      "experience": "5 years",
      "image":
          "https://images.pexels.com/photos/3823488/pexels-photo-3823488.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specialties": ["Deep Tissue", "Relaxation", "Aromatherapy"],
    },
  ];

  final List<Map<String, dynamic>> genderPreferences = [
    {
      "id": "female",
      "name": "Female Professional",
      "type": "gender",
      "description": "Request a female professional for your service",
      "icon": Icons.woman,
    },
    {
      "id": "male",
      "name": "Male Professional",
      "type": "gender",
      "description": "Request a male professional for your service",
      "icon": Icons.man,
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedProfessional = widget.selectedProfessional;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Professional',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textHighEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Select your preferred professional or let us assign the best available',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveLargeSpacing),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Any Available Option
                  _buildProfessionalCard(professionals[0]),
                  SizedBox(height: context.responsiveSmallSpacing),

                  // Gender Preferences
                  Text(
                    'Gender Preference',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.textHighEmphasisColor,
                    ),
                  ),
                  SizedBox(height: context.componentSpacing),
                  Row(
                    children: genderPreferences.map((preference) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: preference == genderPreferences.last
                                ? 0
                                : 2.w(context),
                          ),
                          child: _buildGenderPreferenceCard(preference),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: context.responsiveLargeSpacing),

                  // Specific Professionals
                  Text(
                    'Specific Professionals',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.textHighEmphasisColor,
                    ),
                  ),
                  SizedBox(height: context.componentSpacing),
                  ...professionals.skip(1).map((professional) {
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: context.responsiveSmallSpacing,
                      ),
                      child: _buildProfessionalCard(professional),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> professional) {
    final isSelected = selectedProfessional?["id"] == professional["id"];

    return InkWell(
      onTap: () {
        setState(() {
          selectedProfessional = professional;
        });
        widget.onProfessionalSelected(professional);
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
        child: Row(
          children: [
            // Profile Image or Icon
            Container(
              width: 15.w(context),
              height: 15.w(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: professional["image"] == null
                    ? context.primaryColor.withOpacity(0.1)
                    : null,
              ),
              child: professional["image"] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15.w(context) / 2),
                      child: CustomImageWidget(
                        imageUrl: professional["image"],
                        width: 15.w(context),
                        height: 15.w(context),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      professional["type"] == "any"
                          ? Icons.people
                          : Icons.person,
                      color: context.primaryColor,
                      size: 24,
                    ),
            ),
            SizedBox(width: 3.w(context)),

            // Professional Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional["name"],
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.textHighEmphasisColor,
                    ),
                  ),
                  SizedBox(height: 0.5.h(context)),
                  Text(
                    professional["description"],
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                  if (professional["rating"] != null) ...[
                    SizedBox(height: context.componentSpacing),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 1.w(context)),
                        Text(
                          professional["rating"].toString(),
                          style: context.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context.textHighEmphasisColor,
                          ),
                        ),
                        SizedBox(width: 2.w(context)),
                        Text(
                          '• ${professional["experience"]}',
                          style: context.bodySmall.copyWith(
                            color: context.textMediumEmphasisColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if ((professional["specialties"] as List).isNotEmpty) ...[
                    SizedBox(height: context.componentSpacing),
                    Wrap(
                      spacing: 1.w(context),
                      runSpacing: 0.5.h(context),
                      children: (professional["specialties"] as List)
                          .take(3)
                          .map((specialty) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w(context),
                                vertical: 0.5.h(context),
                              ),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                specialty,
                                style: context.labelSmall.copyWith(
                                  color: context.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Selection Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.primaryColor
                      : context.dividerColor,
                  width: 2,
                ),
                color: isSelected ? context.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: context.colorScheme.onPrimary,
                      size: 12,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderPreferenceCard(Map<String, dynamic> preference) {
    final isSelected = selectedProfessional?["id"] == preference["id"];

    return InkWell(
      onTap: () {
        setState(() {
          selectedProfessional = preference;
        });
        widget.onProfessionalSelected(preference);
      },
      borderRadius: context.responsiveBorderRadius,
      child: Container(
        padding: EdgeInsets.all(3.w(context)),
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
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2.w(context)),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.primaryColor.withOpacity(0.1)
                    : context.dividerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                preference["icon"] as IconData,
                color: isSelected
                    ? context.primaryColor
                    : context.textMediumEmphasisColor,
                size: 24,
              ),
            ),
            SizedBox(height: context.componentSpacing),
            Text(
              preference["name"],
              textAlign: TextAlign.center,
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: context.textHighEmphasisColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
