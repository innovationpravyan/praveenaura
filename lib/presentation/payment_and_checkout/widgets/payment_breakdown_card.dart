import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class PaymentBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const PaymentBreakdownCard({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.componentSpacing,
      ),
      padding: EdgeInsets.all(context.responsiveSpacing),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: context.responsiveBorderRadius,
        border: Border.all(color: context.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textHighEmphasisColor,
            ),
          ),
          SizedBox(height: context.sectionSpacing),
          _buildBreakdownRow(
            context,
            'Service Cost',
            paymentData["serviceCost"] as String,
            false,
          ),
          _buildBreakdownRow(
            context,
            'Platform Fee',
            paymentData["platformFee"] as String,
            false,
          ),
          _buildBreakdownRow(
            context,
            'Taxes & Fees',
            paymentData["taxes"] as String,
            false,
          ),
          if ((paymentData["discount"] as String) != "₹0.00")
            _buildBreakdownRow(
              context,
              'Discount',
              '- ${paymentData["discount"]}',
              false,
              isDiscount: true,
            ),
          if ((paymentData["tip"] as String) != "₹0.00")
            _buildBreakdownRow(
              context,
              'Tip',
              paymentData["tip"] as String,
              false,
            ),
          SizedBox(height: context.componentSpacing),
          Container(height: 1, color: context.dividerColor.withOpacity(0.2)),
          SizedBox(height: context.componentSpacing),
          _buildBreakdownRow(
            context,
            'Total Amount',
            paymentData["total"] as String,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    BuildContext context,
    String label,
    String amount,
    bool isTotal, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTotal ? 0 : context.componentSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textHighEmphasisColor,
                  )
                : context.bodyMedium.copyWith(
                    color: context.textMediumEmphasisColor,
                  ),
          ),
          Text(
            amount,
            style: isTotal
                ? context.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                  )
                : context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDiscount
                        ? context.colorScheme.tertiary
                        : context.textHighEmphasisColor,
                  ),
          ),
        ],
      ),
    );
  }
}
