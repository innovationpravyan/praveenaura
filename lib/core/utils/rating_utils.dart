import '../constants/app_constants.dart';

class RatingUtils {
  RatingUtils._();

  // Format rating for display
  static String formatRating(double rating, {int decimalPlaces = 1}) {
    return rating.toStringAsFixed(decimalPlaces);
  }

  // Get rating category
  static String getRatingCategory(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    if (rating >= 3.0) return 'Average';
    if (rating >= 2.0) return 'Below Average';
    return 'Poor';
  }

  // Get rating color
  static String getRatingColor(double rating) {
    if (rating >= 4.5) return '#4CAF50'; // Green
    if (rating >= 4.0) return '#8BC34A'; // Light Green
    if (rating >= 3.5) return '#CDDC39'; // Lime
    if (rating >= 3.0) return '#FFEB3B'; // Yellow
    if (rating >= 2.0) return '#FF9800'; // Orange
    return '#F44336'; // Red
  }

  // Get rating icon
  static String getRatingIcon(double rating) {
    if (rating >= 4.5) return 'star';
    if (rating >= 4.0) return 'star';
    if (rating >= 3.5) return 'star_half';
    if (rating >= 3.0) return 'star_half';
    if (rating >= 2.0) return 'star_border';
    return 'star_border';
  }

  // Calculate average rating
  static double calculateAverageRating(List<double> ratings) {
    if (ratings.isEmpty) return 0.0;

    final sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  // Calculate weighted average rating
  static double calculateWeightedAverageRating(
      Map<int, int> ratingCounts, // rating -> count
      ) {
    if (ratingCounts.isEmpty) return 0.0;

    double totalWeightedScore = 0.0;
    int totalCount = 0;

    ratingCounts.forEach((rating, count) {
      totalWeightedScore += rating * count;
      totalCount += count;
    });

    return totalCount > 0 ? totalWeightedScore / totalCount : 0.0;
  }

  // Get rating distribution
  static Map<int, double> getRatingDistribution(List<int> ratings) {
    if (ratings.isEmpty) {
      return {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0};
    }

    final Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (final rating in ratings) {
      if (rating >= 1 && rating <= 5) {
        counts[rating] = (counts[rating] ?? 0) + 1;
      }
    }

    final total = ratings.length;
    final Map<int, double> distribution = {};

    counts.forEach((rating, count) {
      distribution[rating] = (count / total) * 100;
    });

    return distribution;
  }

  // Get star display list
  static List<bool> getStarDisplayList(double rating) {
    final List<bool> stars = [];
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars && i < 5; i++) {
      stars.add(true);
    }

    // Add half star if needed
    if (hasHalfStar && stars.length < 5) {
      stars.add(false); // Half star (implement in UI)
    }

    // Add empty stars
    while (stars.length < 5) {
      stars.add(false);
    }

    return stars;
  }

  // Validate rating
  static bool isValidRating(double rating) {
    return rating >= AppConstants.minRating && rating <= AppConstants.maxRating;
  }

  // Get rating percentage
  static double getRatingPercentage(double rating) {
    return (rating / AppConstants.maxRating) * 100;
  }

  // Format rating with total reviews
  static String formatRatingWithReviews(double rating, int totalReviews) {
    if (totalReviews == 0) return 'No reviews yet';

    final ratingText = formatRating(rating);
    final reviewText = totalReviews == 1 ? 'review' : 'reviews';

    return '$ratingText ($totalReviews $reviewText)';
  }

  // Get review quality based on rating
  static String getReviewQuality(double rating) {
    if (rating >= 4.5) return 'Outstanding';
    if (rating >= 4.0) return 'Excellent';
    if (rating >= 3.5) return 'Great';
    if (rating >= 3.0) return 'Good';
    if (rating >= 2.5) return 'Fair';
    if (rating >= 2.0) return 'Needs Improvement';
    return 'Poor';
  }

  // Calculate rating trends
  static Map<String, dynamic> calculateRatingTrends(
      List<Map<String, dynamic>> reviews, // {rating: double, date: DateTime}
      ) {
    if (reviews.isEmpty) {
      return {
        'currentRating': 0.0,
        'previousRating': 0.0,
        'trend': 'stable',
        'change': 0.0,
      };
    }

    // Sort by date
    reviews.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(Duration(days: 30));
    final sixtyDaysAgo = now.subtract(Duration(days: 60));

    // Get recent reviews (last 30 days)
    final recentReviews = reviews
        .where((review) => (review['date'] as DateTime).isAfter(thirtyDaysAgo))
        .toList();

    // Get previous reviews (30-60 days ago)
    final previousReviews = reviews
        .where((review) {
      final date = review['date'] as DateTime;
      return date.isAfter(sixtyDaysAgo) && date.isBefore(thirtyDaysAgo);
    })
        .toList();

    final currentRating = recentReviews.isNotEmpty
        ? calculateAverageRating(
        recentReviews.map((r) => (r['rating'] as num).toDouble()).toList())
        : 0.0;

    final previousRating = previousReviews.isNotEmpty
        ? calculateAverageRating(
        previousReviews.map((r) => (r['rating'] as num).toDouble()).toList())
        : currentRating;

    final change = currentRating - previousRating;
    String trend;

    if (change > 0.1) {
      trend = 'improving';
    } else if (change < -0.1) {
      trend = 'declining';
    } else {
      trend = 'stable';
    }

    return {
      'currentRating': currentRating,
      'previousRating': previousRating,
      'trend': trend,
      'change': change,
    };
  }

  // Get rating summary
  static Map<String, dynamic> getRatingSummary(List<int> ratings) {
    if (ratings.isEmpty) {
      return {
        'averageRating': 0.0,
        'totalReviews': 0,
        'distribution': {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0},
        'category': 'No ratings',
      };
    }

    final averageRating = calculateAverageRating(
        ratings.map((r) => r.toDouble()).toList()
    );
    final distribution = getRatingDistribution(ratings);
    final category = getRatingCategory(averageRating);

    return {
      'averageRating': averageRating,
      'totalReviews': ratings.length,
      'distribution': distribution,
      'category': category,
    };
  }

  // Check if rating is above threshold
  static bool isRatingAboveThreshold(double rating, double threshold) {
    return rating >= threshold;
  }

  // Get minimum rating for featured status
  static double get featuredRatingThreshold => 4.0;

  // Get minimum rating for premium listing
  static double get premiumRatingThreshold => 4.5;

  // Check if salon/service qualifies for featured status
  static bool qualifiesForFeatured(double rating, int reviewCount) {
    return rating >= featuredRatingThreshold && reviewCount >= 10;
  }

  // Check if salon/service qualifies for premium listing
  static bool qualifiesForPremium(double rating, int reviewCount) {
    return rating >= premiumRatingThreshold && reviewCount >= 25;
  }
}