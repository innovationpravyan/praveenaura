import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class ServiceSummaryCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const ServiceSummaryCard({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.sectionSpacing,
      ),
      padding: EdgeInsets.all(context.responsiveSpacing),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: context.responsiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: context.responsiveSmallBorderRadius,
                child: CustomImageWidget(
                  imageUrl:
                      (bookingData["salon"] as Map<String, dynamic>)["image"]
                          as String,
                  width: context.responsiveProfileImageSize * 0.75,
                  height: context.responsiveProfileImageSize * 0.75,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: context.responsiveSmallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (bookingData["salon"] as Map<String, dynamic>)["name"]
                          as String,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.textHighEmphasisColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.elementSpacing),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          size: 14,
                          color: context.textMediumEmphasisColor,
                        ),
                        SizedBox(width: context.elementSpacing),
                        Expanded(
                          child: Text(
                            (bookingData["salon"]
                                    as Map<String, dynamic>)["address"]
                                as String,
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
            ],
          ),
          SizedBox(height: context.sectionSpacing),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.responsiveSmallSpacing),
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(0.05),
              borderRadius: context.responsiveSmallBorderRadius,
              border: Border.all(color: context.primaryColor.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Details',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(height: context.sectionSpacing),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: context.beautyImageHeight,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: (bookingData["services"] as List).map((
                        service,
                      ) {
                        final serviceMap = service as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: context.componentSpacing,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  serviceMap["name"] as String,
                                  style: context.bodyMedium.copyWith(
                                    color: context.textHighEmphasisColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                serviceMap["price"] as String,
                                style: context.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.textHighEmphasisColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: context.componentSpacing),
                Container(
                  height: 1,
                  color: context.dividerColor.withOpacity(0.2),
                ),
                SizedBox(height: context.componentSpacing),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      size: 16,
                      color: context.primaryColor,
                    ),
                    SizedBox(width: context.componentSpacing),
                    Text(
                      '${bookingData["date"]} at ${bookingData["time"]}',
                      style: context.bodyMedium.copyWith(
                        color: context.textHighEmphasisColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
