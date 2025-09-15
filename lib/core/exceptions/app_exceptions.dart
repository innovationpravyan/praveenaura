import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException(this.message, this.code);

  final String message;
  final String code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

// Auth Exceptions
class AuthException extends AppException {
  const AuthException(super.message, super.code);

  factory AuthException.userNotFound() => const AuthException(
    'No user found with this email address',
    'user-not-found',
  );

  factory AuthException.wrongPassword() =>
      const AuthException('Incorrect password provided', 'wrong-password');

  factory AuthException.emailAlreadyInUse() => const AuthException(
    'An account already exists with this email address',
    'email-already-in-use',
  );

  factory AuthException.weakPassword() => const AuthException(
    'Password is too weak. Please choose a stronger password',
    'weak-password',
  );

  factory AuthException.invalidEmail() => const AuthException(
    'Please enter a valid email address',
    'invalid-email',
  );

  factory AuthException.userDisabled() => const AuthException(
    'This account has been disabled. Please contact support',
    'user-disabled',
  );

  factory AuthException.tooManyRequests() => const AuthException(
    'Too many unsuccessful attempts. Please try again later',
    'too-many-requests',
  );

  factory AuthException.networkError() => const AuthException(
    'Network error. Please check your internet connection',
    'network-request-failed',
  );

  factory AuthException.operationNotAllowed() => const AuthException(
    'This sign-in method is not enabled',
    'operation-not-allowed',
  );

  factory AuthException.unknown(String message) =>
      AuthException('Authentication failed: $message', 'unknown-error');
}

// Network Exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, super.code);

  factory NetworkException.noInternetConnection() => const NetworkException(
    'No internet connection. Please check your network settings',
    'no-internet',
  );

  factory NetworkException.requestTimeout() =>
      const NetworkException('Request timed out. Please try again', 'timeout');

  factory NetworkException.serverError() => const NetworkException(
    'Server error. Please try again later',
    'server-error',
  );

  factory NetworkException.badRequest() => const NetworkException(
    'Invalid request. Please check your input',
    'bad-request',
  );

  factory NetworkException.unauthorized() => const NetworkException(
    'Unauthorized access. Please login again',
    'unauthorized',
  );

  factory NetworkException.forbidden() => const NetworkException(
    'Access forbidden. You don\'t have permission',
    'forbidden',
  );

  factory NetworkException.notFound() =>
      const NetworkException('Resource not found', 'not-found');

  factory NetworkException.unknown(String message) =>
      NetworkException('Network error: $message', 'unknown-network-error');
}

// Storage Exceptions
class StorageException extends AppException {
  const StorageException(super.message, super.code);

  factory StorageException.unauthorized() => const StorageException(
    'Unauthorized access to storage',
    'storage-unauthorized',
  );

  factory StorageException.objectNotFound() =>
      const StorageException('File not found in storage', 'object-not-found');

  factory StorageException.quotaExceeded() =>
      const StorageException('Storage quota exceeded', 'quota-exceeded');

  factory StorageException.unknown(String message) =>
      StorageException('Storage error: $message', 'unknown-storage-error');
}

// Firestore Exceptions
class FirestoreException extends AppException {
  const FirestoreException(super.message, super.code);

  factory FirestoreException.permissionDenied() => const FirestoreException(
    'Permission denied. Please login again',
    'permission-denied',
  );

  factory FirestoreException.notFound() =>
      const FirestoreException('Document not found', 'not-found');

  factory FirestoreException.aborted() => const FirestoreException(
    'Operation aborted. Please try again',
    'aborted',
  );

  factory FirestoreException.alreadyExists() =>
      const FirestoreException('Document already exists', 'already-exists');

  factory FirestoreException.unavailable() => const FirestoreException(
    'Service temporarily unavailable',
    'unavailable',
  );

  factory FirestoreException.unknown(String message) =>
      FirestoreException('Database error: $message', 'unknown-firestore-error');
}

// Payment Exceptions
class PaymentException extends AppException {
  const PaymentException(super.message, super.code);

  factory PaymentException.paymentFailed() => const PaymentException(
    'Payment failed. Please try again',
    'payment-failed',
  );

  factory PaymentException.paymentCancelled() => const PaymentException(
    'Payment was cancelled by user',
    'payment-cancelled',
  );

  factory PaymentException.invalidAmount() =>
      const PaymentException('Invalid payment amount', 'invalid-amount');

  factory PaymentException.insufficientFunds() => const PaymentException(
    'Insufficient funds in your account',
    'insufficient-funds',
  );

  factory PaymentException.cardDeclined() => const PaymentException(
    'Your card was declined. Please try another payment method',
    'card-declined',
  );

  factory PaymentException.expiredCard() => const PaymentException(
    'Your card has expired. Please update your payment method',
    'expired-card',
  );

  factory PaymentException.unknown(String message) =>
      PaymentException('Payment error: $message', 'unknown-payment-error');
}

// Location Exceptions
class LocationException extends AppException {
  const LocationException(super.message, super.code);

  factory LocationException.permissionDenied() => const LocationException(
    'Location permission denied. Please enable location access',
    'location-permission-denied',
  );

  factory LocationException.serviceDisabled() => const LocationException(
    'Location services are disabled. Please enable them',
    'location-service-disabled',
  );

  factory LocationException.timeout() => const LocationException(
    'Unable to get location. Request timed out',
    'location-timeout',
  );

  factory LocationException.unknown(String message) =>
      LocationException('Location error: $message', 'unknown-location-error');
}

// Validation Exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, super.code);

  factory ValidationException.invalidEmail() => const ValidationException(
    'Please enter a valid email address',
    'invalid-email',
  );

  factory ValidationException.invalidPhone() => const ValidationException(
    'Please enter a valid phone number',
    'invalid-phone',
  );

  factory ValidationException.passwordTooShort() => const ValidationException(
    'Password must be at least 6 characters long',
    'password-too-short',
  );

  factory ValidationException.passwordsDoNotMatch() =>
      const ValidationException('Passwords do not match', 'passwords-mismatch');

  factory ValidationException.nameRequired() =>
      const ValidationException('Please enter your name', 'name-required');

  factory ValidationException.fieldRequired(String fieldName) =>
      ValidationException('$fieldName is required', 'field-required');

  factory ValidationException.invalidFormat(String fieldName) =>
      ValidationException('Invalid $fieldName format', 'invalid-format');
}

// Business Logic Exceptions
class BusinessException extends AppException {
  const BusinessException(super.message, super.code);

  factory BusinessException.bookingNotAvailable() => const BusinessException(
    'This time slot is no longer available',
    'booking-not-available',
  );

  factory BusinessException.salonClosed() =>
      const BusinessException('Salon is currently closed', 'salon-closed');

  factory BusinessException.serviceUnavailable() => const BusinessException(
    'This service is currently unavailable',
    'service-unavailable',
  );

  factory BusinessException.invalidCoupon() => const BusinessException(
    'Invalid or expired coupon code',
    'invalid-coupon',
  );

  factory BusinessException.minimumBookingAmount() => const BusinessException(
    'Minimum booking amount not met',
    'minimum-amount-required',
  );

  factory BusinessException.maxBookingsExceeded() => const BusinessException(
    'You have reached the maximum number of bookings for today',
    'max-bookings-exceeded',
  );

  factory BusinessException.cancellationNotAllowed() => const BusinessException(
    'Cancellation is not allowed at this time',
    'cancellation-not-allowed',
  );
}

// Cache Exceptions
class CacheException extends AppException {
  const CacheException(super.message, super.code);

  factory CacheException.notFound() =>
      const CacheException('Data not found in cache', 'cache-not-found');

  factory CacheException.expired() =>
      const CacheException('Cached data has expired', 'cache-expired');

  factory CacheException.corruptedData() =>
      const CacheException('Cached data is corrupted', 'cache-corrupted');
}

// Platform Exceptions
class PlatformException extends AppException {
  const PlatformException(super.message, super.code);

  factory PlatformException.cameraNotAvailable() => const PlatformException(
    'Camera is not available on this device',
    'camera-unavailable',
  );

  factory PlatformException.galleryNotAvailable() => const PlatformException(
    'Gallery is not available on this device',
    'gallery-unavailable',
  );

  factory PlatformException.permissionDenied(String permission) =>
      PlatformException('$permission permission denied', 'permission-denied');

  factory PlatformException.unsupportedPlatform() => const PlatformException(
    'This feature is not supported on your device',
    'unsupported-platform',
  );
}
