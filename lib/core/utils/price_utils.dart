import 'package:intl/intl.dart';

class PriceUtils {
  PriceUtils._();

  static const String _defaultCurrency = '₹';
  static const String _currencyCode = 'INR';

  // Format price with currency symbol
  static String formatPrice(
      double price, {
        String currency = _defaultCurrency,
        int decimalPlaces = 0,
      }) {
    if (price == 0) return 'Free';

    final formatter = NumberFormat.currency(
      symbol: currency,
      decimalDigits: decimalPlaces,
      locale: 'en_IN',
    );

    return formatter.format(price);
  }

  // Format price range
  static String formatPriceRange(
      double minPrice,
      double maxPrice, {
        String currency = _defaultCurrency,
      }) {
    if (minPrice == maxPrice) {
      return formatPrice(minPrice, currency: currency);
    }

    return '${formatPrice(minPrice, currency: currency)} - ${formatPrice(maxPrice, currency: currency)}';
  }

  // Calculate discount percentage
  static int calculateDiscountPercentage(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0) return 0;

    final discount = ((originalPrice - discountedPrice) / originalPrice) * 100;
    return discount.round();
  }

  // Calculate discount amount
  static double calculateDiscountAmount(double originalPrice, double discountedPrice) {
    return originalPrice - discountedPrice;
  }

  // Apply discount percentage
  static double applyDiscountPercentage(double price, double discountPercentage) {
    final discountAmount = (price * discountPercentage) / 100;
    return price - discountAmount;
  }

  // Calculate tax amount
  static double calculateTax(double amount, double taxPercentage) {
    return (amount * taxPercentage) / 100;
  }

  // Calculate total with tax
  static double calculateTotalWithTax(double amount, double taxPercentage) {
    final taxAmount = calculateTax(amount, taxPercentage);
    return amount + taxAmount;
  }

  // Format discount text
  static String formatDiscountText(double originalPrice, double discountedPrice) {
    final discountPercentage = calculateDiscountPercentage(originalPrice, discountedPrice);
    final discountAmount = calculateDiscountAmount(originalPrice, discountedPrice);

    return 'Save ${formatPrice(discountAmount)} (${discountPercentage}% off)';
  }

  // Format price with strikethrough for original price
  static String formatPriceWithDiscount(double originalPrice, double discountedPrice) {
    return '${formatPrice(discountedPrice)} ${formatPrice(originalPrice)}';
  }

  // Calculate service charge
  static double calculateServiceCharge(double amount, double serviceChargePercentage) {
    return (amount * serviceChargePercentage) / 100;
  }

  // Calculate convenience fee
  static double calculateConvenienceFee(double amount) {
    // Flat convenience fee for home services
    const double convenienceFeePercentage = 3.0; // 3%
    const double maxConvenienceFee = 50.0; // Max ₹50

    final calculatedFee = (amount * convenienceFeePercentage) / 100;
    return calculatedFee > maxConvenienceFee ? maxConvenienceFee : calculatedFee;
  }

  // Calculate final amount for booking
  static Map<String, double> calculateBookingAmount({
    required double serviceAmount,
    double discountAmount = 0,
    double taxPercentage = 18.0, // GST
    bool isHomeService = false,
    double serviceChargePercentage = 0,
  }) {
    // Apply discount
    final discountedAmount = serviceAmount - discountAmount;

    // Calculate service charge
    final serviceCharge = calculateServiceCharge(discountedAmount, serviceChargePercentage);

    // Calculate convenience fee for home services
    final convenienceFee = isHomeService ? calculateConvenienceFee(discountedAmount) : 0.0;

    // Calculate subtotal
    final subtotal = discountedAmount + serviceCharge + convenienceFee;

    // Calculate tax
    final taxAmount = calculateTax(subtotal, taxPercentage);

    // Calculate total
    final totalAmount = subtotal + taxAmount;

    return {
      'serviceAmount': serviceAmount,
      'discountAmount': discountAmount,
      'discountedAmount': discountedAmount,
      'serviceCharge': serviceCharge,
      'convenienceFee': convenienceFee,
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
    };
  }

  // Format amount breakdown for display
  static List<Map<String, dynamic>> formatAmountBreakdown(Map<String, double> amounts) {
    return [
      {
        'label': 'Service Amount',
        'amount': amounts['serviceAmount']!,
        'isTotal': false,
      },
      if (amounts['discountAmount']! > 0)
        {
          'label': 'Discount',
          'amount': -amounts['discountAmount']!,
          'isDiscount': true,
          'isTotal': false,
        },
      if (amounts['serviceCharge']! > 0)
        {
          'label': 'Service Charge',
          'amount': amounts['serviceCharge']!,
          'isTotal': false,
        },
      if (amounts['convenienceFee']! > 0)
        {
          'label': 'Convenience Fee',
          'amount': amounts['convenienceFee']!,
          'isTotal': false,
        },
      {
        'label': 'Tax (18% GST)',
        'amount': amounts['taxAmount']!,
        'isTotal': false,
      },
      {
        'label': 'Total Amount',
        'amount': amounts['totalAmount']!,
        'isTotal': true,
      },
    ];
  }

  // Check if price is in range
  static bool isPriceInRange(double price, double minPrice, double maxPrice) {
    return price >= minPrice && price <= maxPrice;
  }

  // Get price category
  static String getPriceCategory(double price) {
    if (price <= 500) return 'Budget Friendly';
    if (price <= 1500) return 'Mid Range';
    if (price <= 3000) return 'Premium';
    return 'Luxury';
  }

  // Format compact price (1K, 2.5K, etc.)
  static String formatCompactPrice(double price, {String currency = _defaultCurrency}) {
    if (price >= 100000) {
      return '$currency${(price / 100000).toStringAsFixed(price % 100000 == 0 ? 0 : 1)}L';
    } else if (price >= 1000) {
      return '$currency${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    } else {
      return formatPrice(price, currency: currency);
    }
  }

  // Validate price input
  static bool isValidPrice(String priceString) {
    final price = double.tryParse(priceString);
    return price != null && price >= 0;
  }

  // Parse price from string
  static double parsePrice(String priceString) {
    // Remove currency symbols and spaces
    final cleanPrice = priceString.replaceAll(RegExp(r'[₹$£€¥,\s]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}