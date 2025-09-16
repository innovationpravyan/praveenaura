// search_bar_widget.dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String hintText;
  final bool isReadOnly;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = 'Search salons, services...',
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsiveSize(4)),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(context.responsiveSize(3)),
        border: Border.all(
          color: context.dividerColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: isReadOnly,
        style: context.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.bodyMedium.copyWith(
            color: context.textMediumEmphasisColor,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(context.responsiveSize(3)),
            child: Icon(
              Icons.search,
              color: context.textMediumEmphasisColor,
              size: 20,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(context.responsiveSize(3)),
                    child: Icon(
                      Icons.clear,
                      color: context.textMediumEmphasisColor,
                      size: 18,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.responsiveSize(4),
            vertical: context.responsiveSize(2),
          ),
        ),
      ),
    );
  }
}
