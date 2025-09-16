import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../exceptions/app_exceptions.dart';
import '../helpers/env_helper.dart';

class RazorpayService {
  RazorpayService._();

  static final RazorpayService _instance = RazorpayService._();
  factory RazorpayService() => _instance;

  late Razorpay _razorpay;
  bool _isInitialized = false;

  // Callbacks
  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onError;
  Function(ExternalWalletResponse)? _onExternalWallet;

  // Initialize Razorpay
  void initialize() {
    if (_isInitialized) return;

    try {
      _razorpay = Razorpay();

      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      _isInitialized = true;
      developer.log('Razorpay initialized successfully');
    } catch (e) {
      developer.log('Failed to initialize Razorpay: $e');
      throw PaymentException.unknown('Failed to initialize payment system');
    }
  }

  // Dispose Razorpay
  void dispose() {
    if (!_isInitialized) return;

    try {
      _razorpay.clear();
      _isInitialized = false;
      developer.log('Razorpay disposed successfully');
    } catch (e) {
      developer.log('Error disposing Razorpay: $e');
    }
  }

  // Open payment gateway
  Future<void> openCheckout({
    required String orderId,
    required double amount, // Amount in rupees
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? description,
    Map<String, dynamic>? metadata,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) async {
    if (!_isInitialized) {
      throw PaymentException.unknown('Payment system not initialized');
    }

    try {
      // Set callbacks
      _onSuccess = onSuccess;
      _onError = onError;
      _onExternalWallet = onExternalWallet;

      // Convert amount to paise (smallest currency unit)
      final amountInPaise = (amount * 100).toInt();

      final options = {
        'key': EnvHelper.razorpayKeyId,
        'order_id': orderId,
        'amount': amountInPaise,
        'currency': 'INR',
        'name': 'Aura Beauty Connect',
        'description': description ?? 'Beauty Service Payment',
        'timeout': 300, // 5 minutes timeout
        'prefill': {
          'contact': customerPhone,
          'email': customerEmail,
          'name': customerName,
        },
        'theme': {
          'color': '#8B5A3C', // App's primary color
          'backdrop_color': '#FFFFFF',
        },
        'modal': {
          'ondismiss': () {
            developer.log('Payment modal dismissed by user');
          },
        },
        'notes': metadata ?? {},
        'config': {
          'display': {
            'blocks': {
              'banks': {
                'name': 'Pay via Bank Account',
                'instruments': [
                  {'method': 'netbanking'},
                  {'method': 'upi'},
                ],
              },
              'other': {
                'name': 'Other Payment Modes',
                'instruments': [
                  {'method': 'card'},
                  {'method': 'wallet'},
                  {'method': 'paylater'},
                ],
              },
            },
            'sequence': ['block.banks', 'block.other'],
            'preferences': {
              'show_default_blocks': true,
            },
          },
        },
      };

      developer.log('Opening Razorpay checkout with options: ${options.toString()}');
      _razorpay.open(options);
    } catch (e) {
      developer.log('Error opening Razorpay checkout: $e');
      _onError?.call(PaymentFailureResponse(
        0, // code
        'Failed to open payment gateway',
        {'order_id': orderId},
      ));
    }
  }

  // Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    developer.log('Payment successful: ${response.toString()}');
    _onSuccess?.call(response);
    _clearCallbacks();
  }

  // Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    developer.log('Payment failed: ${response.toString()}');
    _onError?.call(response);
    _clearCallbacks();
  }

  // Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    developer.log('External wallet selected: ${response.toString()}');
    _onExternalWallet?.call(response);
    _clearCallbacks();
  }

  // Clear callbacks after payment completion
  void _clearCallbacks() {
    _onSuccess = null;
    _onError = null;
    _onExternalWallet = null;
  }

  // Create payment order (this would typically be done on backend)
  // This is a mock implementation - in real app, call your backend API
  Future<Map<String, dynamic>> createOrder({
    required double amount,
    required String currency,
    String? receipt,
    Map<String, dynamic>? notes,
  }) async {
    try {
      developer.log('Creating payment order for amount: $amount');

      // In a real app, you would call your backend API here
      // which would then call Razorpay's Order API

      // Mock order creation
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';

      return {
        'id': orderId,
        'amount': (amount * 100).toInt(), // Convert to paise
        'currency': currency,
        'status': 'created',
        'receipt': receipt,
        'notes': notes,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      };
    } catch (e) {
      developer.log('Error creating payment order: $e');
      throw PaymentException.unknown('Failed to create payment order');
    }
  }

  // Verify payment signature (should be done on backend)
  bool verifyPaymentSignature({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) {
    try {
      // In a real app, this verification should be done on your backend
      // using Razorpay's webhook or by calling their API

      developer.log('Payment signature verification (mock): $razorpaySignature');

      // Mock verification - always returns true
      // In production, implement proper signature verification
      return true;
    } catch (e) {
      developer.log('Error verifying payment signature: $e');
      return false;
    }
  }

  // Get payment details
  Future<Map<String, dynamic>?> getPaymentDetails(String paymentId) async {
    try {
      // In a real app, call your backend API which fetches payment details
      // from Razorpay using their Payment API

      developer.log('Fetching payment details for: $paymentId');

      // Mock payment details
      return {
        'id': paymentId,
        'status': 'captured',
        'amount': 100000, // Amount in paise
        'currency': 'INR',
        'method': 'card',
        'captured': true,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      };
    } catch (e) {
      developer.log('Error fetching payment details: $e');
      return null;
    }
  }

  // Refund payment
  Future<Map<String, dynamic>?> refundPayment({
    required String paymentId,
    required double amount,
    String? notes,
  }) async {
    try {
      developer.log('Processing refund for payment: $paymentId, amount: $amount');

      // In a real app, call your backend API which processes refund
      // using Razorpay's Refund API

      final refundId = 'rfnd_${DateTime.now().millisecondsSinceEpoch}';

      return {
        'id': refundId,
        'payment_id': paymentId,
        'amount': (amount * 100).toInt(),
        'currency': 'INR',
        'status': 'processed',
        'notes': notes,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      };
    } catch (e) {
      developer.log('Error processing refund: $e');
      throw PaymentException.unknown('Failed to process refund');
    }
  }

  // Check if payment method is available
  bool isPaymentMethodAvailable(String method) {
    const availableMethods = [
      'card',
      'netbanking',
      'upi',
      'wallet',
      'paylater',
    ];

    return availableMethods.contains(method.toLowerCase());
  }

  // Get supported payment methods
  List<Map<String, dynamic>> getSupportedPaymentMethods() {
    return [
      {
        'method': 'card',
        'name': 'Credit/Debit Card',
        'icon': 'credit_card',
        'description': 'Pay using your credit or debit card',
      },
      {
        'method': 'upi',
        'name': 'UPI',
        'icon': 'account_balance',
        'description': 'Pay using UPI apps like GPay, PhonePe',
      },
      {
        'method': 'netbanking',
        'name': 'Net Banking',
        'icon': 'account_balance',
        'description': 'Pay directly from your bank account',
      },
      {
        'method': 'wallet',
        'name': 'Digital Wallet',
        'icon': 'account_balance_wallet',
        'description': 'Pay using Paytm, Amazon Pay, etc.',
      },
      {
        'method': 'paylater',
        'name': 'Pay Later',
        'icon': 'schedule',
        'description': 'Buy now, pay later options',
      },
    ];
  }

  // Validate payment amount
  bool isValidPaymentAmount(double amount) {
    // Minimum amount: ₹1
    // Maximum amount: ₹5,00,000 (Razorpay limit)
    return amount >= 1 && amount <= 500000;
  }

  // Get payment error message
  String getPaymentErrorMessage(int errorCode, String? errorDescription) {
    switch (errorCode) {
      case 0:
        return 'Payment cancelled by user';
      case 1:
        return 'Payment failed due to network error';
      case 2:
        return 'Payment failed due to invalid details';
      case 3:
        return 'Payment failed due to authentication error';
      case 4:
        return 'Payment failed due to gateway error';
      default:
        return errorDescription ?? 'Payment failed. Please try again.';
    }
  }

  // Format amount for display
  String formatAmountForDisplay(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(2)}K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  // Calculate convenience fee (if applicable)
  double calculateConvenienceFee(double amount, String paymentMethod) {
    // Different fees for different payment methods
    switch (paymentMethod.toLowerCase()) {
      case 'card':
        return amount * 0.02; // 2% for cards
      case 'upi':
        return 0; // No fee for UPI
      case 'netbanking':
        return amount * 0.01; // 1% for net banking
      case 'wallet':
        return amount * 0.015; // 1.5% for wallets
      default:
        return 0;
    }
  }
}

// Payment models for better type safety
class PaymentOrder {
  final String id;
  final double amount;
  final String currency;
  final String status;
  final String? receipt;
  final Map<String, dynamic>? notes;
  final DateTime createdAt;

  PaymentOrder({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.receipt,
    this.notes,
    required this.createdAt,
  });

  factory PaymentOrder.fromMap(Map<String, dynamic> map) {
    return PaymentOrder(
      id: map['id'],
      amount: (map['amount'] as int) / 100.0, // Convert from paise to rupees
      currency: map['currency'],
      status: map['status'],
      receipt: map['receipt'],
      notes: map['notes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as int) * 1000,
      ),
    );
  }
}

class PaymentResult {
  final String paymentId;
  final String orderId;
  final String signature;
  final bool isSuccess;
  final String? errorMessage;

  PaymentResult({
    required this.paymentId,
    required this.orderId,
    required this.signature,
    required this.isSuccess,
    this.errorMessage,
  });

  factory PaymentResult.success(PaymentSuccessResponse response) {
    return PaymentResult(
      paymentId: response.paymentId ?? '',
      orderId: response.orderId ?? '',
      signature: response.signature ?? '',
      isSuccess: true,
    );
  }

  factory PaymentResult.failure(PaymentFailureResponse response) {
    return PaymentResult(
      paymentId: '',
      orderId: response.error?['order_id'] ?? '',
      signature: '',
      isSuccess: false,
      errorMessage: response.message,
    );
  }
}

// Provider
final razorpayServiceProvider = Provider<RazorpayService>((ref) {
  final service = RazorpayService();
  service.initialize();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});