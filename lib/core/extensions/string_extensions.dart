extension StringExtensions on String {
  // Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  // Capitalize each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.capitalize())
        .join(' ');
  }

  // Check if string is valid email
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  // Check if string is valid phone number (Indian)
  bool get isValidPhoneNumber {
    final cleaned = replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.length == 10 && RegExp(r'^[6-9]').hasMatch(cleaned);
  }

  // Check if string is valid name
  bool get isValidName {
    return isNotEmpty &&
        length >= 2 &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }

  // Remove extra whitespaces
  String removeExtraSpaces() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Check if string contains only digits
  bool get isNumeric {
    return RegExp(r'^\d+$').hasMatch(this);
  }

  // Check if string is alphanumeric
  bool get isAlphaNumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  // Extract numbers from string
  String extractNumbers() {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Extract letters from string
  String extractLetters() {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  // Convert to snake_case
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
    ).toLowerCase();
  }

  // Convert to camelCase
  String toCamelCase() {
    final words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words.skip(1).map((word) => word.capitalize()).join();
  }

  // Convert to PascalCase
  String toPascalCase() {
    return split(RegExp(r'[\s_-]+'))
        .map((word) => word.capitalize())
        .join();
  }

  // Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  // Mask string for privacy (email, phone)
  String mask({int visibleStart = 1, int visibleEnd = 1, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final maskLength = length - visibleStart - visibleEnd;
    final masked = maskChar * maskLength;

    return '$start$masked$end';
  }

  // Check if string is URL
  bool get isUrl {
    return RegExp(r'^https?://').hasMatch(this);
  }

  // Add protocol to URL if missing
  String ensureHttps() {
    if (isEmpty) return this;
    if (startsWith('https://') || startsWith('http://')) return this;
    return 'https://$this';
  }

  // Remove HTML tags
  String removeHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Get initials from name
  String getInitials({int maxInitials = 2}) {
    final words = trim().split(RegExp(r'\s+'));
    final initials = words
        .take(maxInitials)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .where((initial) => initial.isNotEmpty)
        .join();

    return initials;
  }

  // Check if string is palindrome
  bool get isPalindrome {
    final cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join();
  }

  // Count words
  int get wordCount {
    return trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  // Reverse string
  String get reversed {
    return split('').reversed.join();
  }

  // Check if string is strong password
  bool get isStrongPassword {
    if (length < 8) return false;

    final hasUpper = RegExp(r'[A-Z]').hasMatch(this);
    final hasLower = RegExp(r'[a-z]').hasMatch(this);
    final hasDigit = RegExp(r'[0-9]').hasMatch(this);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  // Convert to title case
  String toTitleCase() {
    return split(' ')
        .map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    })
        .join(' ');
  }

  // Check if string contains only whitespace
  bool get isBlank {
    return trim().isEmpty;
  }

  // Replace multiple spaces with single space
  String collapseWhitespace() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Convert string to int safely
  int? toIntOrNull() {
    return int.tryParse(this);
  }

  // Convert string to double safely
  double? toDoubleOrNull() {
    return double.tryParse(this);
  }

  // Check if string is valid UUID
  bool get isValidUuid {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    ).hasMatch(this);
  }

  // Generate slug from string
  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  // Check if string contains substring (case insensitive)
  bool containsIgnoreCase(String substring) {
    return toLowerCase().contains(substring.toLowerCase());
  }

  // Wrap text to specified width
  String wrapText(int width) {
    if (width <= 0 || isEmpty) return this;

    final words = split(' ');
    final lines = <String>[];
    String currentLine = '';

    for (final word in words) {
      if (currentLine.isEmpty) {
        currentLine = word;
      } else if ('$currentLine $word'.length <= width) {
        currentLine += ' $word';
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.join('\n');
  }

  // Format as currency (Indian Rupee)
  String formatAsINR() {
    final number = double.tryParse(this);
    if (number == null) return this;

    if (number >= 10000000) {
      return '₹${(number / 10000000).toStringAsFixed(2)}Cr';
    } else if (number >= 100000) {
      return '₹${(number / 100000).toStringAsFixed(2)}L';
    } else if (number >= 1000) {
      return '₹${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return '₹${number.toStringAsFixed(0)}';
    }
  }

  // Check if string is valid JSON
  bool get isValidJson {
    try {
      // This is a simple check - in real app you'd use json.decode
      return (startsWith('{') && endsWith('}')) ||
          (startsWith('[') && endsWith(']'));
    } catch (e) {
      return false;
    }
  }

  // Convert string to boolean
  bool? toBoolOrNull() {
    final lower = toLowerCase();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
    return null;
  }

  // Format as phone number (Indian format)
  String formatAsPhoneNumber() {
    final digits = extractNumbers();
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    }
    return this;
  }

  // Check if string has mixed case
  bool get hasMixedCase {
    return this != toLowerCase() && this != toUpperCase();
  }

  // Count occurrences of substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;

    int count = 0;
    int index = 0;

    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }

    return count;
  }

  // Generate abbreviation
  String generateAbbreviation({int maxLength = 3}) {
    final words = split(RegExp(r'\s+'));
    if (words.length == 1) {
      return substring(0, maxLength.clamp(0, length)).toUpperCase();
    }

    return words
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .take(maxLength)
        .join();
  }
}