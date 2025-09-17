import 'package:flutter/services.dart';

class Formatters {
  Formatters._();

  // Phone number formatter - Indian format
  static final phoneFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9]'),
  );

  // Name formatter - only letters and spaces
  static final nameFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\s]'),
  );

  // Price formatter - numbers and decimal point
  static final priceFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9.]'),
  );

  // Alphabets only formatter
  static final alphabetsOnlyFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z]'),
  );

  // Numbers only formatter
  static final numbersOnlyFormatter = FilteringTextInputFormatter.digitsOnly;

  // Email formatter - allows email characters
  static final emailFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._-]'),
  );

  // Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) return phoneNumber;

    // Format: +91 98765 43210
    return '+91 ${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}';
  }

  // Format phone number for storage (remove formatting)
  static String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Format name - capitalize first letter of each word
  static String formatName(String name) {
    if (name.isEmpty) return name;

    return name.split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : word)
        .join(' ')
        .trim();
  }

  // Format service name
  static String formatServiceName(String serviceName) {
    return formatName(serviceName);
  }

  // Format salon name
  static String formatSalonName(String salonName) {
    return formatName(salonName);
  }

  // Format address
  static String formatAddress(String address) {
    if (address.isEmpty) return address;

    // Capitalize first letter and clean up spacing
    return address[0].toUpperCase() +
        address.substring(1).toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Format review text
  static String formatReviewText(String reviewText) {
    if (reviewText.isEmpty) return reviewText;

    // Capitalize first letter and ensure proper sentence structure
    String formatted = reviewText.trim();
    if (formatted.isNotEmpty) {
      formatted = formatted[0].toUpperCase() + formatted.substring(1);

      // Add period at the end if missing
      if (!formatted.endsWith('.') && !formatted.endsWith('!') && !formatted.endsWith('?')) {
        formatted += '.';
      }
    }

    return formatted;
  }

  // Format duration text
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;

      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${remainingMinutes}min';
      }
    }
  }

  // Format percentage
  static String formatPercentage(double percentage, {int decimalPlaces = 0}) {
    return '${percentage.toStringAsFixed(decimalPlaces)}%';
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  // Format distance
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()}m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Extract initials from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
  }

  // Mask email for privacy
  static String maskEmail(String email) {
    if (!email.contains('@')) return email;

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    } else {
      return '${username[0]}***${username[username.length - 1]}@$domain';
    }
  }

  // Mask phone number for privacy
  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) return phoneNumber;

    return '${phoneNumber.substring(0, 2)}******${phoneNumber.substring(8)}';
  }

  // Format coupon code
  static String formatCouponCode(String code) {
    return code.toUpperCase().replaceAll(' ', '');
  }

  // Format booking reference
  static String formatBookingReference(String reference) {
    return reference.toUpperCase();
  }

  // Clean and format explore query
  static String formatSearchQuery(String query) {
    return query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Format tags (remove duplicates, clean, sort)
  static List<String> formatTags(List<String> tags) {
    return tags
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  // Custom text input formatter for specific use cases
  static TextInputFormatter customFormatter({
    required String allowedChars,
    int? maxLength,
  }) {
    return FilteringTextInputFormatter.allow(RegExp(allowedChars));
  }

  // Decimal formatter with specific decimal places
  static TextInputFormatter decimalFormatter({int decimalPlaces = 2}) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) return newValue;

      final regex = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$');
      if (regex.hasMatch(newValue.text)) {
        return newValue;
      }

      return oldValue;
    });
  }

  // OTP formatter
  static final otpFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9]'),
  );

  // Pincode formatter (Indian)
  static final pincodeFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9]'),
  );

  // Format social handles
  static String formatSocialHandle(String handle, String platform) {
    String cleaned = handle.replaceAll('@', '').trim();

    switch (platform.toLowerCase()) {
      case 'instagram':
      case 'twitter':
      case 'facebook':
        return '@$cleaned';
      default:
        return cleaned;
    }
  }

  // Format URL
  static String formatUrl(String url) {
    if (url.isEmpty) return url;

    String formatted = url.trim().toLowerCase();

    if (!formatted.startsWith('http://') && !formatted.startsWith('https://')) {
      formatted = 'https://$formatted';
    }

    return formatted;
  }

  // Remove HTML tags from text
  static String stripHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  // Format list to readable string
  static String formatListToString(List<String> items, {int maxItems = 3}) {
    if (items.isEmpty) return '';

    if (items.length <= maxItems) {
      if (items.length == 1) return items[0];
      if (items.length == 2) return '${items[0]} and ${items[1]}';
      return '${items.sublist(0, items.length - 1).join(', ')}, and ${items.last}';
    } else {
      return '${items.sublist(0, maxItems).join(', ')} and ${items.length - maxItems} more';
    }
  }
}