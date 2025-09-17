import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/custom_icon_widget.dart';

class NewPaymentForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onPaymentDataChanged;

  const NewPaymentForm({super.key, required this.onPaymentDataChanged});

  @override
  State<NewPaymentForm> createState() => _NewPaymentFormState();
}

class _NewPaymentFormState extends State<NewPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  String _cardType = 'unknown';
  bool _saveCard = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onCardNumberChanged);
    _expiryController.addListener(_onFormChanged);
    _cvvController.addListener(_onFormChanged);
    _nameController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      _cardType = _detectCardType(cardNumber);
    });
    _onFormChanged();
  }

  void _onFormChanged() {
    final paymentData = {
      'cardNumber': _cardNumberController.text.replaceAll(' ', ''),
      'expiry': _expiryController.text,
      'cvv': _cvvController.text,
      'holderName': _nameController.text,
      'cardType': _cardType,
      'saveCard': _saveCard,
      'isValid': _formKey.currentState?.validate() ?? false,
    };
    widget.onPaymentDataChanged(paymentData);
  }

  String _detectCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'visa';
    if (cardNumber.startsWith('5') || cardNumber.startsWith('2'))
      return 'mastercard';
    if (cardNumber.startsWith('3')) return 'amex';
    return 'unknown';
  }

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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Payment Method',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textHighEmphasisColor,
              ),
            ),
            SizedBox(height: context.sectionSpacing),
            _buildCardNumberField(context),
            SizedBox(height: context.sectionSpacing),
            Row(
              children: [
                Expanded(child: _buildExpiryField(context)),
                SizedBox(width: context.responsiveSmallSpacing),
                Expanded(child: _buildCvvField(context)),
              ],
            ),
            SizedBox(height: context.sectionSpacing),
            _buildNameField(context),
            SizedBox(height: context.sectionSpacing),
            _buildSaveCardCheckbox(context),
            SizedBox(height: context.sectionSpacing),
            _buildSecurityInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumberField(BuildContext context) {
    return TextFormField(
      controller: _cardNumberController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'Card Number',
        hintText: '1234 5678 9012 3456',
        prefixIcon: Padding(
          padding: EdgeInsets.all(context.responsiveSmallSpacing),
          child: CustomIconWidget(
            iconName: 'credit_card',
            size: 20,
            color: context.textMediumEmphasisColor,
          ),
        ),
        suffixIcon: _cardType != 'unknown'
            ? Padding(
                padding: EdgeInsets.all(context.responsiveSmallSpacing),
                child: Container(
                  width: context.responsiveProfileImageSize * 0.4,
                  height: context.responsiveListTileHeight * 0.6,
                  decoration: BoxDecoration(
                    color: _getCardColor(_cardType),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _getCardLabel(_cardType),
                      style: context.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: context.getResponsiveFontSize(8),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter card number';
        }
        final cardNumber = value.replaceAll(' ', '');
        if (cardNumber.length < 13 || cardNumber.length > 19) {
          return 'Invalid card number';
        }
        return null;
      },
    );
  }

  Widget _buildExpiryField(BuildContext context) {
    return TextFormField(
      controller: _expiryController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _ExpiryDateInputFormatter(),
      ],
      decoration: const InputDecoration(
        labelText: 'Expiry Date',
        hintText: 'MM/YY',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (value.length != 5) {
          return 'Invalid';
        }
        return null;
      },
    );
  }

  Widget _buildCvvField(BuildContext context) {
    return TextFormField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      decoration: const InputDecoration(labelText: 'CVV', hintText: '123'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (value.length < 3) {
          return 'Invalid';
        }
        return null;
      },
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Cardholder Name',
        hintText: 'John Doe',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter cardholder name';
        }
        return null;
      },
    );
  }

  Widget _buildSaveCardCheckbox(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _saveCard,
          onChanged: (value) {
            setState(() {
              _saveCard = value ?? false;
            });
            _onFormChanged();
          },
        ),
        Expanded(
          child: Text(
            'Save this card for future payments',
            style: context.bodyMedium.copyWith(
              color: context.textHighEmphasisColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsiveSmallSpacing),
      decoration: BoxDecoration(
        color: context.colorScheme.tertiary.withOpacity(0.1),
        borderRadius: context.responsiveSmallBorderRadius,
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'security',
            size: 20,
            color: context.colorScheme.tertiary,
          ),
          SizedBox(width: context.componentSpacing),
          Expanded(
            child: Text(
              'Your payment information is encrypted and secure',
              style: context.bodySmall.copyWith(
                color: context.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

  String _getCardLabel(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'VISA';
      case 'mastercard':
        return 'MC';
      case 'amex':
        return 'AMEX';
      default:
        return 'CARD';
    }
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '$text/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
