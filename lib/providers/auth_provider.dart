import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/exceptions/app_exceptions.dart';
import '../core/services/database_service.dart';
import '../core/services/firebase_service.dart';
import '../models/user_model.dart';

// Auth State with guest mode support
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isGuest = false,
    this.isInitialized = false,
  });

  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isGuest;
  final bool isInitialized; // New field to track initialization

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isGuest,
    bool? isInitialized,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isGuest: isGuest ?? this.isGuest,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  // User is authenticated (either logged in or guest)
  bool get isAuthenticated => user != null || isGuest;

  // User is fully authenticated (logged in with account)
  bool get isFullyAuthenticated => user != null && !isGuest;

  // User needs to login for premium features
  bool get requiresLogin => isGuest || user == null;

  @override
  String toString() {
    return 'AuthState(user: ${user?.displayName}, isLoading: $isLoading, '
        'error: $error, isGuest: $isGuest, isInitialized: $isInitialized, '
        'isAuthenticated: $isAuthenticated, isFullyAuthenticated: $isFullyAuthenticated)';
  }
}

// Auth Notifier with improved state management
class AuthNotifier extends Notifier<AuthState> {
  FirebaseService? _firebaseService;
  DatabaseService? _databaseService;
  StreamSubscription<User?>? _authSubscription;

  @override
  AuthState build() {
    _firebaseService = ref.read(firebaseServiceProvider);
    _databaseService = ref.read(databaseServiceProvider);
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
          // User is signed in
          final userModel = await _databaseService!.getUserById(user.uid);
          if (userModel != null) {
            state = state.copyWith(
              user: userModel,
              isLoading: false,
              isGuest: false,
              isInitialized: true,
              clearError: true,
            );
          } else {
            // User exists but no document, clear auth
            await _firebaseService!.signOut();
            state = state.copyWith(
              clearUser: true,
              isLoading: false,
              isGuest: false,
              isInitialized: true,
              error: 'User data not found. Please contact support.',
            );
          }
        } else {
          // User signed out or not signed in
          if (state.isGuest) {
            // If we were in guest mode, maintain it
            state = state.copyWith(
              clearUser: true,
              isLoading: false,
              isGuest: true,
              isInitialized: true,
              clearError: true,
            );
          } else {
            // Normal sign out
            state = state.copyWith(
              clearUser: true,
              isLoading: false,
              isGuest: false,
              isInitialized: true,
              clearError: true,
            );
          }
        }
      } catch (e) {
        state = state.copyWith(
          error: 'Failed to load user data: ${e.toString()}',
          isLoading: false,
          isInitialized: true,
        );
      }
    });
  }

  // Continue as guest (limited access)
  void continueAsGuest() {
    print('AuthNotifier: Continuing as guest');
    state = state.copyWith(
      isGuest: true,
      isLoading: false,
      isInitialized: true,
      clearError: true,
    );
  }

  // Exit guest mode (forces user to login)
  void exitGuestMode() {
    print('AuthNotifier: Exiting guest mode');
    state = state.copyWith(isGuest: false, isLoading: false, clearError: true);
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
      print('AuthNotifier: Starting sign in for $email');
      state = state.copyWith(isLoading: true, clearError: true);

      final userCredential = await _firebaseService!.signInWithEmailAndPassword(
        email.trim(),
        password,
      );

      if (userCredential.user != null) {
        await _firebaseService!.updateLastLoginTime(userCredential.user!.uid);
        print('AuthNotifier: Sign in successful');
        // State will be updated by the auth state listener
      }
    } on FirebaseAuthException catch (e) {
      print(
        'AuthNotifier: Sign in failed with FirebaseAuthException: ${e.code}',
      );
      state = state.copyWith(
        isLoading: false,
        error: _getAuthErrorMessage(e.code),
      );
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      print('AuthNotifier: Sign in failed with unexpected error: $e');
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
      print('AuthNotifier: Starting sign up for $email');
      state = state.copyWith(isLoading: true, clearError: true);

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

        await _databaseService!.createUser(userModel);

        print('AuthNotifier: Sign up successful, signing out user');

        // Sign out the user after successful registration
        await _firebaseService!.signOut();

        // Update state to reflect successful registration but not authenticated
        state = state.copyWith(
          isLoading: false,
          isGuest: false,
          isInitialized: true,
          clearUser: true,
          clearError: true,
        );

        print('AuthNotifier: User signed out after registration');
      }
    } on FirebaseAuthException catch (e) {
      print(
        'AuthNotifier: Sign up failed with FirebaseAuthException: ${e.code}',
      );
      state = state.copyWith(
        isLoading: false,
        error: _getAuthErrorMessage(e.code),
      );
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      print('AuthNotifier: Sign up failed with unexpected error: $e');
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
      print('AuthNotifier: Starting sign out');
      state = state.copyWith(isLoading: true, clearError: true);

      await _firebaseService!.signOut();

      print('AuthNotifier: Sign out completed');

      // Reset to initial state (not guest mode)
      state = state.copyWith(
        clearUser: true,
        isLoading: false,
        isGuest: false,
        isInitialized: true,
        clearError: true,
      );
    } catch (e) {
      print('AuthNotifier: Sign out failed: $e');
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
      print('AuthNotifier: Sending password reset email to $email');
      state = state.copyWith(isLoading: true, clearError: true);

      await _firebaseService!.sendPasswordResetEmail(email.trim());

      state = state.copyWith(isLoading: false);
      print('AuthNotifier: Password reset email sent');
    } on FirebaseAuthException catch (e) {
      print('AuthNotifier: Password reset failed: ${e.code}');
      state = state.copyWith(
        isLoading: false,
        error: _getAuthErrorMessage(e.code),
      );
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      print('AuthNotifier: Password reset failed with unexpected error: $e');
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

        await _databaseService!.updateUser(updatedUser);

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
    state = state.copyWith(clearError: true);
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
      case 'invalid-credential':
        return 'The provided credentials are invalid';
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

final isInitializedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isInitialized));
});
