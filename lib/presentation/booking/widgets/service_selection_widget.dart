import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ServiceSelectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onServiceSelected;
  final Map<String, dynamic>? selectedService;

  const ServiceSelectionWidget({
    super.key,
    required this.onServiceSelected,
    this.selectedService,
  });

  @override
  State<ServiceSelectionWidget> createState() => _ServiceSelectionWidgetState();
}

class _ServiceSelectionWidgetState extends State<ServiceSelectionWidget> {
  String? expandedCategory;
  Map<String, dynamic>? selectedService;

  final List<Map<String, dynamic>> serviceCategories = [
    {
      "id": "hair",
      "name": "Hair Services",
      "icon": "content_cut",
      "services": [
        {
          "id": "haircut",
          "name": "Haircut & Styling",
          "duration": "45 min",
          "price": "₹35",
          "description": "Professional haircut with styling and finishing",
        },
        {
          "id": "coloring",
          "name": "Hair Coloring",
          "duration": "120 min",
          "price": "₹85",
          "description": "Full hair coloring with premium products",
        },
        {
          "id": "highlights",
          "name": "Highlights",
          "duration": "90 min",
          "price": "₹65",
          "description": "Professional highlights with expert color matching",
        },
        {
          "id": "treatment",
          "name": "Hair Treatment",
          "duration": "60 min",
          "price": "₹45",
          "description": "Deep conditioning and nourishing hair treatment",
        },
      ],
    },
    {
      "id": "nails",
      "name": "Nail Services",
      "icon": "colorize",
      "services": [
        {
          "id": "manicure",
          "name": "Classic Manicure",
          "duration": "30 min",
          "price": "₹25",
          "description": "Classic nail care with polish application",
        },
        {
          "id": "pedicure",
          "name": "Deluxe Pedicure",
          "duration": "45 min",
          "price": "₹35",
          "description": "Relaxing pedicure with foot massage and polish",
        },
        {
          "id": "gel_nails",
          "name": "Gel Nails",
          "duration": "60 min",
          "price": "₹40",
          "description": "Long-lasting gel nail application with design",
        },
      ],
    },
    {
      "id": "facial",
      "name": "Facial & Skincare",
      "icon": "face",
      "services": [
        {
          "id": "classic_facial",
          "name": "Classic Facial",
          "duration": "60 min",
          "price": "₹55",
          "description": "Deep cleansing facial with moisturizing treatment",
        },
        {
          "id": "anti_aging",
          "name": "Anti-Aging Facial",
          "duration": "75 min",
          "price": "₹75",
          "description": "Advanced anti-aging treatment with premium serums",
        },
        {
          "id": "acne_treatment",
          "name": "Acne Treatment",
          "duration": "50 min",
          "price": "₹60",
          "description": "Specialized treatment for acne-prone skin",
        },
      ],
    },
    {
      "id": "massage",
      "name": "Massage Therapy",
      "icon": "spa",
      "services": [
        {
          "id": "relaxation",
          "name": "Relaxation Massage",
          "duration": "60 min",
          "price": "₹70",
          "description": "Full body relaxation massage with aromatherapy",
        },
        {
          "id": "deep_tissue",
          "name": "Deep Tissue Massage",
          "duration": "75 min",
          "price": "₹85",
          "description": "Therapeutic deep tissue massage for muscle tension",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedService = widget.selectedService;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Service',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textHighEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Choose from our professional beauty services',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveLargeSpacing),
          Expanded(
            child: ListView.builder(
              itemCount: serviceCategories.length,
              itemBuilder: (context, index) {
                final category = serviceCategories[index];
                final isExpanded = expandedCategory == category["id"];

                return Container(
                  margin: EdgeInsets.only(
                    bottom: context.responsiveSmallSpacing,
                  ),
                  decoration: context.cardDecoration,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            expandedCategory = isExpanded
                                ? null
                                : category["id"];
                          });
                        },
                        borderRadius: context.responsiveBorderRadius,
                        child: Container(
                          padding: context.responsiveCardPadding,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  context.widthPercent(2),
                                ),
                                decoration: BoxDecoration(
                                  color: context.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getIconData(category["icon"]),
                                  color: context.primaryColor,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: context.widthPercent(3)),
                              Expanded(
                                child: Text(
                                  category["name"],
                                  style: context.titleMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: context.textHighEmphasisColor,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: context.textMediumEmphasisColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Divider(height: 1, color: context.dividerColor),
                        ...(category["services"] as List).map((service) {
                          final isSelected =
                              selectedService?["id"] == service["id"];

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedService = service;
                              });
                              widget.onServiceSelected(service);
                            },
                            child: Container(
                              padding: context.responsiveCardPadding,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.primaryColor.withOpacity(0.05)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
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
                                      color: isSelected
                                          ? context.primaryColor
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            color:
                                                context.colorScheme.onPrimary,
                                            size: 12,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: context.widthPercent(3)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                service["name"],
                                                style: context.titleSmall
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: context
                                                          .textHighEmphasisColor,
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              service["price"],
                                              style: context.titleSmall
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: context.primaryColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: context.heightPercent(0.5),
                                        ),
                                        Text(
                                          service["description"],
                                          style: context.bodySmall.copyWith(
                                            color:
                                                context.textMediumEmphasisColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: context.heightPercent(0.5),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.schedule,
                                              color: context
                                                  .textMediumEmphasisColor,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: context.widthPercent(1),
                                            ),
                                            Text(
                                              service["duration"],
                                              style: context.bodySmall.copyWith(
                                                color: context
                                                    .textMediumEmphasisColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'content_cut':
        return Icons.content_cut;
      case 'colorize':
        return Icons.colorize;
      case 'face':
        return Icons.face;
      case 'spa':
        return Icons.spa;
      default:
        return Icons.miscellaneous_services;
    }
  }
}
