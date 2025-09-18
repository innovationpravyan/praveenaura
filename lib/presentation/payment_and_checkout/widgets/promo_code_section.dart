import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/custom_icon_widget.dart';

class PromoCodeSection extends StatefulWidget {
  final Function(double) onDiscountApplied;

  const PromoCodeSection({super.key, required this.onDiscountApplied});

  @override
  State<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isApplying = false;
  String? _appliedPromoCode;
  double _discountAmount = 0.0;
  String? _errorMessage;

  final TextEditingController _promoController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  final List<Map<String, dynamic>> _validPromoCodes = [
    {
      "code": "FIRST20",
      "discount": 20.0,
      "type": "percentage",
      "description": "20% off your first booking",
    },
    {
      "code": "SAVE10",
      "discount": 10.0,
      "type": "fixed",
      "description": "₹10 off any service",
    },
    {
      "code": "BEAUTY15",
      "discount": 15.0,
      "type": "percentage",
      "description": "15% off beauty services",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: context.responsiveAnimationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _applyPromoCode() async {
    final code = _promoController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a promo code';
      });
      return;
    }

    setState(() {
      _isApplying = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final validCode = _validPromoCodes.firstWhere(
      (promo) => (promo["code"] as String) == code,
      orElse: () => {},
    );

    if (validCode.isNotEmpty) {
      final discount = validCode["discount"] as double;
      final type = validCode["type"] as String;

      setState(() {
        _appliedPromoCode = code;
        _discountAmount = type == "percentage" ? discount : discount;
        _isApplying = false;
        _errorMessage = null;
      });

      widget.onDiscountApplied(_discountAmount);
    } else {
      setState(() {
        _isApplying = false;
        _errorMessage = 'Invalid promo code. Please try again.';
      });
    }
  }

  void _removePromoCode() {
    setState(() {
      _appliedPromoCode = null;
      _discountAmount = 0.0;
      _errorMessage = null;
      _promoController.clear();
    });
    widget.onDiscountApplied(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing,
        vertical: context.componentSpacing,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: context.responsiveBorderRadius,
        border: Border.all(color: context.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.responsiveSpacing),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_offer',
                    size: 20,
                    color: _appliedPromoCode != null
                        ? context.colorScheme.tertiary
                        : context.primaryColor,
                  ),
                  SizedBox(width: context.responsiveSmallSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _appliedPromoCode != null
                              ? 'Promo Code Applied'
                              : 'Have a Promo Code?',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _appliedPromoCode != null
                                ? context.colorScheme.tertiary
                                : context.textHighEmphasisColor,
                          ),
                        ),
                        if (_appliedPromoCode != null) ...[
                          SizedBox(height: context.elementSpacing),
                          Text(
                            'Code: $_appliedPromoCode',
                            style: context.bodySmall.copyWith(
                              color: context.colorScheme.tertiary.withOpacity(
                                0.8,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: context.elementSpacing),
                          Text(
                            'Tap to enter your promo code',
                            style: context.bodySmall.copyWith(
                              color: context.textMediumEmphasisColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_appliedPromoCode != null)
                    GestureDetector(
                      onTap: _removePromoCode,
                      child: Container(
                        padding: EdgeInsets.all(context.elementSpacing),
                        decoration: BoxDecoration(
                          color: context.errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          size: 16,
                          color: context.errorColor,
                        ),
                      ),
                    )
                  else
                    CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      size: 20,
                      color: context.textMediumEmphasisColor,
                    ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                context.responsiveSpacing,
                0,
                context.responsiveSpacing,
                context.responsiveSpacing,
              ),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: context.dividerColor.withOpacity(0.1),
                  ),
                  SizedBox(height: context.sectionSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Enter promo code',
                            errorText: _errorMessage,
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(
                                context.responsiveSmallSpacing,
                              ),
                              child: CustomIconWidget(
                                iconName: 'confirmation_number',
                                size: 20,
                                color: context.textMediumEmphasisColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.responsiveSmallSpacing),
                      ElevatedButton(
                        onPressed: _isApplying ? null : _applyPromoCode,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsiveLargeSpacing,
                            vertical: context.sectionSpacing,
                          ),
                        ),
                        child: _isApplying
                            ? SizedBox(
                                width: context.responsiveSmallIconSize,
                                height: context.responsiveSmallIconSize,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'Apply',
                                style: context.labelLarge.copyWith(
                                  color: context.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                  if (_errorMessage == null &&
                      _promoController.text.isEmpty) ...[
                    SizedBox(height: context.sectionSpacing),
                    _buildAvailablePromoCodes(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePromoCodes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Offers',
          style: context.labelLarge.copyWith(
            color: context.textMediumEmphasisColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.componentSpacing),
        ..._validPromoCodes.map((promo) {
          return GestureDetector(
            onTap: () {
              _promoController.text = promo["code"] as String;
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: context.componentSpacing),
              padding: EdgeInsets.all(context.responsiveSmallSpacing),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.05),
                borderRadius: context.responsiveSmallBorderRadius,
                border: Border.all(
                  color: context.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.componentSpacing,
                      vertical: context.elementSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      promo["code"] as String,
                      style: context.labelSmall.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: context.responsiveSmallSpacing),
                  Expanded(
                    child: Text(
                      promo["description"] as String,
                      style: context.bodySmall.copyWith(
                        color: context.textMediumEmphasisColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
