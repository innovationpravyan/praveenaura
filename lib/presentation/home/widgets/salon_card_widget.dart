// salon_card_widget.dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class SalonCardWidget extends StatelessWidget {
  final Map<String, dynamic> salon;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onShare;
  final VoidCallback onGetDirections;

  const SalonCardWidget({
    super.key,
    required this.salon,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onShare,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = salon['isFavorite'] as bool? ?? false;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsiveSize(4),
          vertical: context.responsiveSize(1),
        ),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(context.responsiveSize(4)),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context, isFavorite),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, bool isFavorite) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.responsiveSize(4)),
            topRight: Radius.circular(context.responsiveSize(4)),
          ),
          child: Container(
            width: double.infinity,
            height: context.responsiveSize(20),
            color: context.primaryColor.withOpacity(0.1),
            child: salon['image'] != null
                ? Image.network(
                    salon['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage(context);
                    },
                  )
                : _buildPlaceholderImage(context),
          ),
        ),

        // Favorite button
        Positioned(
          top: context.responsiveSize(2),
          right: context.responsiveSize(2),
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(context.responsiveSize(2)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? context.errorColor
                    : context.textMediumEmphasisColor,
                size: 20,
              ),
            ),
          ),
        ),

        // Discount badge
        if (salon['discount'] != null)
          Positioned(
            top: context.responsiveSize(2),
            left: context.responsiveSize(2),
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
                salon['discount'] as String,
                style: context.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Distance badge
        Positioned(
          bottom: context.responsiveSize(2),
          right: context.responsiveSize(2),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsiveSize(2),
              vertical: context.responsiveSize(1),
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 12),
                SizedBox(width: context.responsiveSize(1)),
                Text(
                  salon['distance'] as String,
                  style: context.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      color: context.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(Icons.store, size: 40, color: context.primaryColor),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.responsiveSize(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salon name
          Text(
            salon['name'] as String,
            style: context.titleSmall.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: context.responsiveSize(1)),

          // Rating row
          Row(
            children: [
              _buildRatingStars(context),
              SizedBox(width: context.responsiveSize(2)),
              Flexible(
                child: Text(
                  '${salon['rating']} (${salon['reviewCount']})',
                  style: context.bodySmall.copyWith(
                    color: context.textMediumEmphasisColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveSize(1)),

          // Price and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Starting from ${salon['startingPrice']}',
                  style: context.bodySmall.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(BuildContext context) {
    final rating = salon['rating'] as double? ?? 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: const Color(0xFFFFB800),
          size: 16,
        );
      }),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isOpen = salon['isOpen'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveSize(2),
        vertical: context.responsiveSize(0.5),
      ),
      decoration: BoxDecoration(
        color: isOpen
            ? const Color(0xFF4CAF50).withOpacity(0.1)
            : context.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: context.labelSmall.copyWith(
          color: isOpen ? const Color(0xFF4CAF50) : context.errorColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: context.responsiveSize(10),
                height: context.responsiveSize(0.5),
                margin: EdgeInsets.only(top: context.responsiveSize(2)),
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: context.responsiveSize(3)),

              // Title
              Text(
                salon['name'] as String,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.responsiveSize(3)),

              // Action items
              _buildQuickActionItem(
                context,
                'Add to Favorites',
                Icons.favorite_border,
                onFavoriteToggle,
              ),
              _buildQuickActionItem(context, 'Share', Icons.share, onShare),
              _buildQuickActionItem(
                context,
                'Get Directions',
                Icons.directions,
                onGetDirections,
              ),

              SizedBox(height: context.responsiveSize(2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: context.primaryColor, size: 24),
      title: Text(
        title,
        style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
