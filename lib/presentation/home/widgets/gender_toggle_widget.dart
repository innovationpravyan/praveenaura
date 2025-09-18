// GenderToggleWidget with Theme Integration
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_theme.dart';

class GenderToggleWidget extends ConsumerWidget {
  final bool isMaleSelected;
  final ValueChanged<bool> onGenderChanged;

  const GenderToggleWidget({
    super.key,
    required this.isMaleSelected,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleWidth = context.responsive<double>(
      mobile: 110,
      tablet: 140,
      desktop: 160,
      smallMobile: 100,
    );

    final toggleHeight = context.responsive<double>(
      mobile: 30,
      tablet: 40,
      desktop: 44,
      smallMobile: 32,
    );

    return Container(
      width: toggleWidth,
      height: toggleHeight,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(toggleHeight / 2),
        border: Border.all(
          color: context.dividerColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: isMaleSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: toggleWidth / 2 - 2,
              height: toggleHeight - 4,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isMaleSelected
                    ? context.getPrimaryColorForGender('male')
                    : context.getPrimaryColorForGender('female'),
                borderRadius: BorderRadius.circular((toggleHeight - 4) / 2),
                boxShadow: [
                  BoxShadow(
                    color: (isMaleSelected
                        ? context.getPrimaryColorForGender('male')
                        : context.getPrimaryColorForGender('female'))
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onGenderChanged(true);
                    _updateTheme(ref, true, context);
                  },
                  child: Container(
                    height: toggleHeight,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: context.labelMedium.copyWith(
                          color: isMaleSelected
                              ? Colors.white
                              : context.textMediumEmphasisColor,
                          fontWeight: isMaleSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: context.getResponsiveFontSize(11),
                        ),
                        child: const Text('Male'),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onGenderChanged(false);
                    _updateTheme(ref, false, context);
                  },
                  child: Container(
                    height: toggleHeight,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: context.labelMedium.copyWith(
                          color: !isMaleSelected
                              ? Colors.white
                              : context.textMediumEmphasisColor,
                          fontWeight: !isMaleSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: context.getResponsiveFontSize(11),
                        ),
                        child: const Text('Female'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateTheme(WidgetRef ref, bool isMale, BuildContext context) {
    // This would typically update your theme provider
    // You'd need to create a theme provider to handle this
    final gender = isMale ? 'male' : 'female';
    final isDark = context.isDarkMode;

    // Example of how you might update theme
    // ref.read(themeProvider.notifier).updateTheme(gender, isDark);
  }
}


