import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/custom_icon_widget.dart';

class TipSelectionWidget extends StatefulWidget {
  final double serviceAmount;
  final Function(double) onTipChanged;

  const TipSelectionWidget({
    super.key,
    required this.serviceAmount,
    required this.onTipChanged,
  });

  @override
  State<TipSelectionWidget> createState() => _TipSelectionWidgetState();
}

class _TipSelectionWidgetState extends State<TipSelectionWidget> {
  int? selectedTipPercentage;
  double customTipAmount = 0.0;
  bool isCustomTipSelected = false;
  final TextEditingController _customTipController = TextEditingController();

  final List<int> tipPercentages = [15, 18, 20, 25];

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

  void _selectTipPercentage(int percentage) {
    setState(() {
      selectedTipPercentage = percentage;
      isCustomTipSelected = false;
      customTipAmount = 0.0;
      _customTipController.clear();
    });

    final tipAmount = (widget.serviceAmount * percentage) / 100;
    widget.onTipChanged(tipAmount);
  }

  void _selectCustomTip() {
    setState(() {
      selectedTipPercentage = null;
      isCustomTipSelected = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCustomTipBottomSheet(),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                size: 20,
                color: context.primaryColor,
              ),
              SizedBox(width: context.componentSpacing),
              Text(
                'Add Tip',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textHighEmphasisColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.componentSpacing),
          Text(
            'Show your appreciation for great service',
            style: context.bodySmall.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.sectionSpacing),
          Wrap(
            spacing: context.componentSpacing,
            runSpacing: context.componentSpacing,
            children: [
              ...tipPercentages
                  .map(
                    (percentage) => _buildTipButton(
                      context,
                      '$percentage%',
                      '\${((widget.serviceAmount * percentage) / 100).toStringAsFixed(2)}',
                      selectedTipPercentage == percentage,
                      () => _selectTipPercentage(percentage),
                    ),
                  )
                  .toList(),
              _buildTipButton(
                context,
                'Custom',
                isCustomTipSelected && customTipAmount > 0
                    ? '\${customTipAmount.toStringAsFixed(2)}'
                    : '',
                isCustomTipSelected,
                _selectCustomTip,
              ),
            ],
          ),
          if (selectedTipPercentage != null ||
              (isCustomTipSelected && customTipAmount > 0)) ...[
            SizedBox(height: context.sectionSpacing),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.responsiveSmallSpacing),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.05),
                borderRadius: context.responsiveSmallBorderRadius,
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    size: 20,
                    color: context.primaryColor,
                  ),
                  SizedBox(width: context.componentSpacing),
                  Expanded(
                    child: Text(
                      selectedTipPercentage != null
                          ? 'Tip: ${selectedTipPercentage}% (\${((widget.serviceAmount * selectedTipPercentage!) / 100).toStringAsFixed(2)})'
                          : 'Custom tip: \${customTipAmount.toStringAsFixed(2)}',
                      style: context.bodyMedium.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w500,
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

  Widget _buildTipButton(
    BuildContext context,
    String label,
    String amount,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsiveSpacing,
          vertical: context.sectionSpacing,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : context.surfaceColor,
          borderRadius: context.responsiveSmallBorderRadius,
          border: Border.all(
            color: isSelected
                ? context.primaryColor
                : context.dividerColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.textHighEmphasisColor,
              ),
            ),
            if (amount.isNotEmpty) ...[
              SizedBox(height: context.elementSpacing),
              Text(
                amount,
                style: context.bodySmall.copyWith(
                  color: isSelected
                      ? context.colorScheme.onPrimary.withOpacity(0.8)
                      : context.textMediumEmphasisColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTipBottomSheet() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(context.responsiveLargeSpacing),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: context.responsiveProfileImageSize * 0.6,
                height: context.elementSpacing,
                decoration: BoxDecoration(
                  color: context.dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: context.sectionSpacing),
            Text(
              'Enter Custom Tip Amount',
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textHighEmphasisColor,
              ),
            ),
            SizedBox(height: context.componentSpacing),
            Text(
              'Enter the amount you\'d like to tip',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
            ),
            SizedBox(height: context.sectionSpacing),
            TextField(
              controller: _customTipController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Tip Amount',
                hintText: '0.00',
                prefixText: '\$ ',
                prefixStyle: context.bodyLarge.copyWith(
                  color: context.textHighEmphasisColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: context.bodyLarge.copyWith(fontWeight: FontWeight.w500),
              autofocus: true,
            ),
            SizedBox(height: context.responsiveExtraLargeSpacing),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isCustomTipSelected = false;
                        customTipAmount = 0.0;
                      });
                      widget.onTipChanged(0.0);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: context.responsiveSmallSpacing),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final tipAmount =
                          double.tryParse(_customTipController.text) ?? 0.0;
                      setState(() {
                        customTipAmount = tipAmount;
                        isCustomTipSelected = true;
                      });
                      widget.onTipChanged(tipAmount);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.sectionSpacing),
          ],
        ),
      ),
    );
  }
}
