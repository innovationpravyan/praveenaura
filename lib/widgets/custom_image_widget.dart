import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Widget? placeholder;
  final String? semanticLabel;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.placeholder,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackImageUrl =
        'https://images.unsplash.com/photo-1584824486509-112e4181ff6b?q=80&w=2940&auto=format&fit=crop';

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? fallbackImageUrl,
        width: width,
        height: height,
        fit: fit,

        // Custom placeholder with responsive design
        placeholder: (context, url) =>
            placeholder ??
            Container(
              width: width,
              height: height,
              color: AppColors.getSurfaceColor(isDark: context.isDarkMode),
              child: Center(
                child: SizedBox(
                  width: context.responsiveIconSize,
                  height: context.responsiveIconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: context.primaryColor,
                    backgroundColor: context.primaryColor.withOpacity(0.2),
                  ),
                ),
              ),
            ),

        // Custom error widget with professional design
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(isDark: context.isDarkMode),
                border: Border.all(
                  color: AppColors.getDividerColor(isDark: context.isDarkMode),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_rounded,
                    size: context.responsiveIconSize,
                    color: AppColors.getTextMediumEmphasisColor(
                      isDark: context.isDarkMode,
                    ),
                  ),
                  context.responsiveSmallVerticalSpacing,
                  Text(
                    'Image not available',
                    style: TextStyle(
                      fontSize: context.getResponsiveFontSize(12),
                      color: AppColors.getTextMediumEmphasisColor(
                        isDark: context.isDarkMode,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

        // Performance optimizations
        memCacheWidth: width?.toInt(),
        memCacheHeight: height?.toInt(),
        maxWidthDiskCache: (width ?? 400).toInt(),
        maxHeightDiskCache: (height ?? 400).toInt(),
      ),
    );
  }
}
