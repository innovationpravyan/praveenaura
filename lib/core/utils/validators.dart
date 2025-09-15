import '../constants/app_constants.dart';

class Validators {
  Validators._();

  // Email Validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password Validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Simple Password Validator (for less strict requirements)
  static String? simplePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  // Confirm Password Validator
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Name Validator
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }

    if (trimmedValue.length > AppConstants.maxNameLength) {
      return 'Name must not exceed ${AppConstants.maxNameLength} characters';
    }

    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmedValue)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // Phone Number Validator
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length != AppConstants.phoneNumberLength) {
      return 'Phone number must be exactly ${AppConstants.phoneNumberLength} digits';
    }

    // Check if it starts with valid digits (Indian phone numbers)
    if (!RegExp(r'^[6-9]').hasMatch(digitsOnly)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Required Field Validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Minimum Length Validator
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty values
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }

    return null;
  }

  // Maximum Length Validator
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty values
    }

    if (value.length > maxLength) {
      return '${fieldName ?? 'Field'} must not exceed $maxLength characters';
    }

    return null;
  }

  // Numeric Validator
  static String? numeric(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty values
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Field'} must be a valid number';
    }

    return null;
  }

  // Positive Number Validator
  static String? positiveNumber(String? value, [String? fieldName]) {
    final numericError = numeric(value, fieldName);
    if (numericError != null) return numericError;

    if (value != null && value.isNotEmpty) {
      final number = double.parse(value);
      if (number <= 0) {
        return '${fieldName ?? 'Field'} must be greater than zero';
      }
    }

    return null;
  }

  // Age Validator
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final ageValue = int.tryParse(value);
    if (ageValue == null) {
      return 'Please enter a valid age';
    }

    if (ageValue < 13) {
      return 'You must be at least 13 years old';
    }

    if (ageValue > 120) {
      return 'Please enter a valid age';
    }

    return null;
  }

  // URL Validator
  static String? url(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty values
    }

    final urlRegex = RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value)) {
      return '${fieldName ?? 'Field'} must be a valid URL';
    }

    return null;
  }

  // Rating Validator
  static String? rating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rating is required';
    }

    final ratingValue = double.tryParse(value);
    if (ratingValue == null) {
      return 'Please enter a valid rating';
    }

    if (ratingValue < AppConstants.minRating ||
        ratingValue > AppConstants.maxRating) {
      return 'Rating must be between ${AppConstants.minRating} and ${AppConstants.maxRating}';
    }

    return null;
  }

  // Pin code Validator (Indian)
  static String? pincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }

    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
      return 'Please enter a valid 6-digit pincode';
    }

    return null;
  }

  // OTP Validator
  static String? otp(String? value, [int length = 6]) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != length) {
      return 'OTP must be $length digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP can only contain numbers';
    }

    return null;
  }

  // Credit Card Validator
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
      return 'Card number can only contain digits';
    }

    // Check length (13-19 digits for most cards)
    if (cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Please enter a valid card number';
    }

    if (!_isValidCreditCard(cleanValue)) {
      return 'Please enter a valid card number';
    }

    return null;
  }

  // CVV Validator
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  // Expiry Date Validator (MM/YY format)
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    // Check if the value matches the MM/YY format
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Please enter date in MM/YY format';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]) + 2000; // Convert YY to YYYY

    final now = DateTime.now();
    final expiry = DateTime(year, month + 1, 0); // Last day of expiry month

    if (expiry.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  // Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  // Conditional validator
  static String? conditional(
    String? value,
    bool condition,
    String? Function(String?) validator,
  ) {
    if (condition) {
      return validator(value);
    }
    return null;
  }

  // Private helper method for credit card validation using Luhn algorithm
  static bool _isValidCreditCard(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);

      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }

      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // Gender Validator
  static String? gender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }

    if (value != AppConstants.male && value != AppConstants.female) {
      return 'Please select a valid gender';
    }

    return null;
  }

  // Service Type Validator
  static String? serviceType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select service type';
    }

    if (value != AppConstants.salonService &&
        value != AppConstants.homeService) {
      return 'Please select a valid service type';
    }

    return null;
  }

  // Date Validator (for future dates)
  static String? futureDate(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Please enter a valid date';
    }

    final today = DateTime.now();
    if (date.isBefore(DateTime(today.year, today.month, today.day))) {
      return '${fieldName ?? 'Date'} must be today or later';
    }

    return null;
  }

  // Time Validator (HH:MM format)
  static String? time(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Time'} is required';
    }

    // Check if the value matches the HH:MM format
    if (!RegExp(r'^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$').hasMatch(value)) {
      return 'Please enter time in HH:MM format';
    }

    return null;
  }
}
