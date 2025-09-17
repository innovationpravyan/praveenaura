import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/custom_icon_widget.dart';

class SavedPaymentMethods extends StatefulWidget {
  final Function(Map<String, dynamic>?) onPaymentMethodSelected;

  const SavedPaymentMethods({super.key, required this.onPaymentMethodSelected});

  @override
  State<SavedPaymentMethods> createState() => _SavedPaymentMethodsState();
}

class _SavedPaymentMethodsState extends State<SavedPaymentMethods> {
  int? selectedMethodIndex;

  final List<Map<String, dynamic>> savedMethods = [
    {
      "id": "card_1",
      "type": "visa",
      "lastFour": "4242",
      "expiryMonth": "12",
      "expiryYear": "26",
      "holderName": "John Doe",
      "isDefault": true,
    },
    {
      "id": "card_2",
      "type": "mastercard",
      "lastFour": "8888",
      "expiryMonth": "08",
      "expiryYear": "25",
      "holderName": "John Doe",
      "isDefault": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.componentSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.componentSpacing),
            child: Text(
              'Payment Methods',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textHighEmphasisColor,
              ),
            ),
          ),
          SizedBox(height: context.sectionSpacing),
          ...savedMethods.asMap().entries.map((entry) {
            final index = entry.key;
            final method = entry.value;
            return _buildPaymentMethodCard(context, method, index);
          }).toList(),
          SizedBox(height: context.componentSpacing),
          _buildAddNewCardButton(context),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    Map<String, dynamic> method,
    int index,
  ) {
    final isSelected = selectedMethodIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethodIndex = index;
        });
        widget.onPaymentMethodSelected(method);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: context.sectionSpacing),
        padding: EdgeInsets.all(context.responsiveSpacing),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: context.responsiveBorderRadius,
          border: Border.all(
            color: isSelected
                ? context.primaryColor
                : context.dividerColor.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: context.responsiveProfileImageSize * 0.6,
              height: context.responsiveListTileHeight * 1.0,
              decoration: BoxDecoration(
                color: _getCardColor(method["type"] as String),
                borderRadius: context.responsiveSmallBorderRadius,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getCardIcon(method["type"] as String),
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: context.responsiveSmallSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '•••• •••• •••• ${method["lastFour"]}',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.textHighEmphasisColor,
                        ),
                      ),
                      if (method["isDefault"] as bool) ...[
                        SizedBox(width: context.componentSpacing),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.componentSpacing,
                            vertical: context.elementSpacing,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Default',
                            style: context.labelSmall.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: context.elementSpacing),
                  Text(
                    '${method["holderName"]} • Expires ${method["expiryMonth"]}/${method["expiryYear"]}',
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: context.responsiveSmallIconSize * 1.2,
                height: context.responsiveSmallIconSize * 1.2,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  size: 16,
                  color: context.colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethodIndex = null;
        });
        widget.onPaymentMethodSelected(null);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.responsiveSpacing),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: context.responsiveBorderRadius,
          border: Border.all(
            color: context.dividerColor.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: context.responsiveProfileImageSize * 0.6,
              height: context.responsiveListTileHeight * 1.0,
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: context.responsiveSmallBorderRadius,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'add',
                  size: 24,
                  color: context.primaryColor,
                ),
              ),
            ),
            SizedBox(width: context.responsiveSmallSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Payment Method',
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor,
                    ),
                  ),
                  SizedBox(height: context.elementSpacing),
                  Text(
                    'Credit card, debit card, or digital wallet',
                    style: context.bodySmall.copyWith(
                      color: context.textMediumEmphasisColor,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              size: 16,
              color: context.textDisabledColor,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF006FCF);
      default:
        return const Color(0xFF6B6B6B);
    }
  }

  String _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
      case 'mastercard':
      case 'amex':
        return 'credit_card';
      default:
        return 'payment';
    }
  }
}
