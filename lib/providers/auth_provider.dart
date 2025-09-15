import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/exceptions/app_exceptions.dart';
import '../core/services/firebase_service.dart';
import '../models/user_model.dart';

// Auth State with guest mode support
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isGuest = false,
  });

  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isGuest; // New field for guest mode

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isGuest,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  // User is authenticated (either logged in or guest)
  bool get isAuthenticated => user != null || isGuest;

  // User is fully authenticated (logged in with account)
  bool get isFullyAuthenticated => user != null && !isGuest;

  // User needs to login for premium features
  bool get requiresLogin => isGuest || user == null;
}

// Auth Notifier with guest mode support
class AuthNotifier extends Notifier<AuthState> {
  FirebaseService? _firebaseService;
  StreamSubscription<User?>? _authSubscription;

  @override
  AuthState build() {
    _firebaseService = ref.read(firebaseServiceProvider);
    _init();

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    return const AuthState();
  }

  void _init() {
    _authSubscription?.cancel();

    _authSubscription = _firebaseService!.authStateChanges.listen((
      User? user,
    ) async {
      try {
        if (user != null) {
          final userModel = await _firebaseService!.getUserData(user.uid);
          state = state.copyWith(
            user: userModel,
            error: null,
            isLoading: false,
            isGuest: false, // Clear guest mode when user logs in
          );
        } else {
          // Check if we were in guest mode
          if (!state.isGuest) {
            // User signed out, reset to initial state
            state = const AuthState(
              user: null,
              error: null,
              isLoading: false,
              isGuest: false,
            );
          }
        }
      } catch (e) {
        state = state.copyWith(
          error: 'Failed to load user data: ${e.toString()}',
          isLoading: false,
        );
      }
    });
  }

  // Continue as guest (limited access)
  void continueAsGuest() {
    state = state.copyWith(isGuest: true, isLoading: false, error: null);
  }

  // Exit guest mode (forces user to login)
  void exitGuestMode() {
    state = state.copyWith(isGuest: false, isLoading: false, error: null);
  }

  // Check if feature requires authentication
  bool requiresAuthentication(String feature) {
    // Define features that require full authentication
    const premiumFeatures = [
      'booking',
      'profile',
      'wishlist',
      'booking_history',
      'notifications',
      'payment',
      'consultation',
      'tracking',
      'settings',
    ];

    return premiumFeatures.contains(feature);
  }

  // Email/Password Sign In
  Future<void> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final userCredential = await _firebaseService!.signInWithEmailAndPassword(
        email.trim(),
        password,
      );

      if (userCredential.user != null) {
        await _firebaseService!.updateLastLoginTime(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getAuthErrorMessage(e.code),
      );
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      throw AuthException.unknown(e.toString());
    }
  }

  // Email/Password Sign Up
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
    required String gender,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final userCredential = await _firebaseService!
          .createUserWithEmailAndPassword(email.trim(), password);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        await user.updateDisplayName(displayName);

        final userModel = UserModel(
          uid: user.uid,
          email: email.trim(),
          displayName: displayName.trim(),
          phoneNumber: phoneNumber.trim(),
          gender: gender,
          isEmailVerified: user.emailVerified,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firebaseService!.createUserDocument(userModel);
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getAuthErrorMessage(e.code),
      );
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      throw AuthException.unknown(e.toString());
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firebaseService!.signOut();

      // Reset to initial state (not guest mode)
      state = const AuthState(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sign out failed: ${e.toString()}',
      );
      throw AuthException.unknown('Sign out failed: ${e.toString()}');
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firebaseService!.sendPasswordResetEmail(email.trim());

      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getAuthErrorMessage(e.code),
      );
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send reset email',
      );
      throw AuthException.unknown(e.toString());
    }
  }

  // Update User Profile (requires full authentication)
  Future<void> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    String? address,
    String? city,
    String? userState,
    String? pincode,
    DateTime? dateOfBirth,
    UserPreferences? preferences,
  }) async {
    if (state.isGuest) {
      throw AuthException(
        'Please login to update your profile',
        'guest-mode-restriction',
      );
    }

    if (state.user != null) {
      try {
        state = state.copyWith(isLoading: true);

        final updatedUser = state.user!.copyWith(
          displayName: displayName ?? state.user!.displayName,
          phoneNumber: phoneNumber ?? state.user!.phoneNumber,
          photoURL: photoURL ?? state.user!.photoURL,
          address: address ?? state.user!.address,
          city: city ?? state.user!.city,
          state: userState ?? state.user!.state,
          pincode: pincode ?? state.user!.pincode,
          dateOfBirth: dateOfBirth ?? state.user!.dateOfBirth,
          preferences: preferences ?? state.user!.preferences,
          updatedAt: DateTime.now(),
        );

        await _firebaseService!.updateUserDocument(updatedUser);

        state = state.copyWith(isLoading: false, user: updatedUser);
      } catch (e) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to update profile',
        );
        throw BusinessException(
          'Failed to update profile',
          'profile-update-failed',
        );
      }
    }
  }

  // Clear Error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Helper method to get user-friendly error messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password provided';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support';
      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'guest-mode-restriction':
        return 'Please login to access this feature';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

// Providers
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// Convenience providers
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider.select((state) => state.user));
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isAuthenticated));
});

final isFullyAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isFullyAuthenticated));
});

final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isGuest));
});

final requiresLoginProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.requiresLogin));
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isLoading));
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider.select((state) => state.error));
});
