// promotional_banner_widget.dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class PromotionalBannerWidget extends StatefulWidget {
  final List<Map<String, dynamic>> banners;

  const PromotionalBannerWidget({super.key, required this.banners});

  @override
  State<PromotionalBannerWidget> createState() =>
      _PromotionalBannerWidgetState();
}

class _PromotionalBannerWidgetState extends State<PromotionalBannerWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && widget.banners.isNotEmpty) {
        final nextIndex = (_currentIndex + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: context.responsiveSize(20),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                final banner = widget.banners[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: context.responsiveSize(4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: context.shadowColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image with fallback
                        if (banner['image'] != null)
                          Image.network(
                            banner['image'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: context.primaryColor.withOpacity(0.1),
                                child: Icon(
                                  Icons.image,
                                  size: 64,
                                  color: context.primaryColor,
                                ),
                              );
                            },
                          )
                        else
                          Container(
                            color: context.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.image,
                              size: 64,
                              color: context.primaryColor,
                            ),
                          ),

                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: context.responsiveSize(3),
                          left: context.responsiveSize(4),
                          right: context.responsiveSize(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner['title'] as String,
                                style: context.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.getResponsiveFontSize(14),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (banner['subtitle'] != null) ...[
                                SizedBox(height: context.responsiveSize(0.5)),
                                Text(
                                  banner['subtitle'] as String,
                                  style: context.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: context.getResponsiveFontSize(11),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        if (banner['discount'] != null)
                          Positioned(
                            top: context.responsiveSize(2),
                            right: context.responsiveSize(3),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.responsiveSize(2),
                                vertical: context.responsiveSize(1),
                              ),
                              decoration: BoxDecoration(
                                color: context.errorColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                banner['discount'] as String,
                                style: context.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.getResponsiveFontSize(10),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: context.responsiveSize(1)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(
                  horizontal: context.responsiveSize(1),
                ),
                width: index == _currentIndex
                    ? context.responsiveSize(6)
                    : context.responsiveSize(2),
                height: context.responsiveSize(1),
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? context.primaryColor
                      : context.dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
