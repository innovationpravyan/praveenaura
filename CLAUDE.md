# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Aurame** is a Flutter beauty salon booking application with Firebase backend integration. It features a gender-based theming system, guest/authenticated user modes, and comprehensive booking functionality.

## Development Commands

### Core Development
```bash
# Run the application
flutter run

# Build for release
flutter build apk --release
flutter build ios --release

# Run tests
flutter test

# Analyze code for issues
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get

# Clean build files
flutter clean
```

### Platform-Specific Development
```bash
# Run on specific device
flutter run -d <device_id>

# Build for specific platform
flutter build apk --target-platform android-arm64
flutter build ipa
```

## Architecture

### State Management
- **Riverpod** for state management with providers
- **AuthProvider** (`lib/providers/auth_provider.dart`) manages authentication state with guest mode support
- Three authentication states: unauthenticated, guest mode, fully authenticated

### Navigation Architecture
- **Go Router** based navigation with security checks in `lib/config/app_router.dart`
- Route-based authentication with different access levels:
  - Public routes (no auth required)
  - Guest access routes (requires guest mode or full auth)
  - Premium routes (requires full authentication)
- Custom animations and transitions per route type

### Core Services
- **FirebaseService** (`lib/core/services/firebase_service.dart`) - Firebase operations
- **NotificationService** - Firebase messaging and local notifications
- **RazorpayService** - Payment processing integration
- **MapService** - Google Maps integration for salon locations

### Theme System
- Gender-based theming with separate male/female themes
- Dynamic theme switching based on user profile
- Both light and dark mode support
- Themes defined in `lib/core/theme/`

### Project Structure
```
lib/
├── config/           # App router and configuration
├── core/            # Core utilities, services, constants
│   ├── constants/   # App constants and strings
│   ├── exceptions/  # Custom exception classes
│   ├── extensions/  # Dart extensions
│   ├── helpers/     # Helper utilities
│   ├── services/    # Core services (Firebase, payment, etc.)
│   ├── theme/       # Theming system
│   └── utils/       # Utility functions
├── models/          # Data models (User, Salon, Service, Booking)
├── presentation/    # UI screens organized by feature
│   ├── auth/        # Authentication screens
│   ├── booking/     # Booking-related screens
│   ├── home/        # Home screen and widgets
│   ├── profile/     # User profile management
│   └── ...          # Other feature screens
├── providers/       # Riverpod providers for state management
└── widgets/         # Reusable UI components
```

### Firebase Integration
- **Authentication** - Email/password with guest mode support
- **Firestore** - User profiles, salon data, bookings, services
- **Storage** - Image uploads for profiles and salons
- **Messaging** - Push notifications

### Key Dependencies
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase services
- `google_maps_flutter`, `geolocator` - Location services
- `razorpay_flutter` - Payment processing
- `cached_network_image` - Image caching
- `flutter_local_notifications` - Local notifications

## Development Guidelines

### Authentication Flow
- Users can continue as guests with limited access
- Premium features require full authentication
- Guest users are prompted to login when accessing restricted features
- Auth state is managed globally through AuthProvider

### Navigation Patterns
- Use `AppRouter.pushNamed()` instead of direct Navigator calls
- Routes automatically handle authentication checks
- Different animations for different route types (auth, main, modal)

### Theming
- Always use theme colors through `Theme.of(context)`
- Gender-based themes are applied at app level based on user profile
- Support both light and dark modes

### Error Handling
- Custom exception classes in `lib/core/exceptions/`
- User-friendly error messages for authentication failures
- Network error handling with retry mechanisms

### Testing
- Unit tests should be added for utility functions and business logic
- Widget tests for custom components
- Integration tests for critical user flows