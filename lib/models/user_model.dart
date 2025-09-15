import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.preferences,
    this.loyaltyPoints = 0,
    this.totalBookings = 0,
    this.totalSpent = 0.0,
    this.averageRating = 0.0,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final String? gender; // 'male' or 'female'
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final UserPreferences? preferences;
  final int loyaltyPoints;
  final int totalBookings;
  final double totalSpent;
  final double averageRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    phoneNumber,
    photoURL,
    gender,
    dateOfBirth,
    address,
    city,
    state,
    pincode,
    isEmailVerified,
    isPhoneVerified,

    preferences,
    loyaltyPoints,
    totalBookings,
    totalSpent,
    averageRating,
    createdAt,
    updatedAt,
    lastLoginAt,
  ];

  // Computed properties
  String get firstName {
    if (displayName == null || displayName!.isEmpty) return '';
    return displayName!.split(' ').first;
  }

  String get lastName {
    if (displayName == null || displayName!.isEmpty) return '';
    final parts = displayName!.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    final parts = displayName!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName![0].toUpperCase();
  }

  bool get isProfileComplete {
    return displayName != null &&
        displayName!.isNotEmpty &&
        phoneNumber != null &&
        phoneNumber!.isNotEmpty &&
        gender != null &&
        address != null &&
        city != null;
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  String get membershipLevel {
    if (totalSpent < 1000) return 'Bronze';
    if (totalSpent < 5000) return 'Silver';
    if (totalSpent < 10000) return 'Gold';
    return 'Platinum';
  }

  // Factory constructors
  factory UserModel.empty() {
    return UserModel(uid: '', email: '', createdAt: DateTime.now());
  }

  factory UserModel.fromFirebase(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      phoneNumber: data['phoneNumber'],
      photoURL: data['photoURL'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth'])
          : null,
      address: data['address'],
      city: data['city'],
      state: data['state'],
      pincode: data['pincode'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      isPhoneVerified: data['isPhoneVerified'] ?? false,
      preferences: data['preferences'] != null
          ? UserPreferences.fromMap(data['preferences'])
          : null,
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      totalBookings: data['totalBookings'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0.0).toDouble(),
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : null,
      lastLoginAt: data['lastLoginAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastLoginAt'])
          : null,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'preferences': preferences?.toMap(),
      'loyaltyPoints': loyaltyPoints,
      'totalBookings': totalBookings,
      'totalSpent': totalSpent,
      'averageRating': averageRating,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
    };
  }

  // Copy with method
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    String? gender,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? state,
    String? pincode,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    UserPreferences? preferences,
    int? loyaltyPoints,
    int? totalBookings,
    double? totalSpent,
    double? averageRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      preferences: preferences ?? this.preferences,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      totalBookings: totalBookings ?? this.totalBookings,
      totalSpent: totalSpent ?? this.totalSpent,
      averageRating: averageRating ?? this.averageRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName)';
  }
}

class UserPreferences extends Equatable {
  const UserPreferences({
    this.selectedGender,
    this.notificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = true,
    this.pushNotificationsEnabled = true,
    this.marketingNotificationsEnabled = false,
    this.bookingRemindersEnabled = true,
    this.promotionalOffersEnabled = true,
    this.theme = 'system', // 'light', 'dark', 'system'
    this.language = 'en',
    this.currency = 'INR',
    this.preferredServiceCategories = const [],
    this.autoLocationEnabled = true,
    this.biometricLoginEnabled = false,
    this.dataUsageOptimized = false,
    this.accessibilityEnabled = false,
  });

  final String? selectedGender; // For service provider preference
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool marketingNotificationsEnabled;
  final bool bookingRemindersEnabled;
  final bool promotionalOffersEnabled;
  final String theme;
  final String language;
  final String currency;
  final List<String> preferredServiceCategories;
  final bool autoLocationEnabled;
  final bool biometricLoginEnabled;
  final bool dataUsageOptimized;
  final bool accessibilityEnabled;

  @override
  List<Object?> get props => [
    selectedGender,
    notificationsEnabled,
    emailNotificationsEnabled,
    smsNotificationsEnabled,
    pushNotificationsEnabled,
    marketingNotificationsEnabled,
    bookingRemindersEnabled,
    promotionalOffersEnabled,
    theme,
    language,
    currency,
    preferredServiceCategories,
    autoLocationEnabled,
    biometricLoginEnabled,
    dataUsageOptimized,
    accessibilityEnabled,
  ];

  // Factory constructor from map
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      selectedGender: map['selectedGender'],
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      emailNotificationsEnabled: map['emailNotificationsEnabled'] ?? true,
      smsNotificationsEnabled: map['smsNotificationsEnabled'] ?? true,
      pushNotificationsEnabled: map['pushNotificationsEnabled'] ?? true,
      marketingNotificationsEnabled:
          map['marketingNotificationsEnabled'] ?? false,
      bookingRemindersEnabled: map['bookingRemindersEnabled'] ?? true,
      promotionalOffersEnabled: map['promotionalOffersEnabled'] ?? true,
      theme: map['theme'] ?? 'system',
      language: map['language'] ?? 'en',
      currency: map['currency'] ?? 'INR',
      preferredServiceCategories: List<String>.from(
        map['preferredServiceCategories'] ?? [],
      ),
      autoLocationEnabled: map['autoLocationEnabled'] ?? true,
      biometricLoginEnabled: map['biometricLoginEnabled'] ?? false,
      dataUsageOptimized: map['dataUsageOptimized'] ?? false,
      accessibilityEnabled: map['accessibilityEnabled'] ?? false,
    );
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'selectedGender': selectedGender,
      'notificationsEnabled': notificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'marketingNotificationsEnabled': marketingNotificationsEnabled,
      'bookingRemindersEnabled': bookingRemindersEnabled,
      'promotionalOffersEnabled': promotionalOffersEnabled,
      'theme': theme,
      'language': language,
      'currency': currency,
      'preferredServiceCategories': preferredServiceCategories,
      'autoLocationEnabled': autoLocationEnabled,
      'biometricLoginEnabled': biometricLoginEnabled,
      'dataUsageOptimized': dataUsageOptimized,
      'accessibilityEnabled': accessibilityEnabled,
    };
  }

  // Copy with method
  UserPreferences copyWith({
    String? selectedGender,
    bool? notificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    bool? pushNotificationsEnabled,
    bool? marketingNotificationsEnabled,
    bool? bookingRemindersEnabled,
    bool? promotionalOffersEnabled,
    String? theme,
    String? language,
    String? currency,
    List<String>? preferredServiceCategories,
    bool? autoLocationEnabled,
    bool? biometricLoginEnabled,
    bool? dataUsageOptimized,
    bool? accessibilityEnabled,
  }) {
    return UserPreferences(
      selectedGender: selectedGender ?? this.selectedGender,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled:
          smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      marketingNotificationsEnabled:
          marketingNotificationsEnabled ?? this.marketingNotificationsEnabled,
      bookingRemindersEnabled:
          bookingRemindersEnabled ?? this.bookingRemindersEnabled,
      promotionalOffersEnabled:
          promotionalOffersEnabled ?? this.promotionalOffersEnabled,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      preferredServiceCategories:
          preferredServiceCategories ?? this.preferredServiceCategories,
      autoLocationEnabled: autoLocationEnabled ?? this.autoLocationEnabled,
      biometricLoginEnabled:
          biometricLoginEnabled ?? this.biometricLoginEnabled,
      dataUsageOptimized: dataUsageOptimized ?? this.dataUsageOptimized,
      accessibilityEnabled: accessibilityEnabled ?? this.accessibilityEnabled,
    );
  }

  @override
  String toString() {
    return 'UserPreferences(theme: $theme, language: $language, notificationsEnabled: $notificationsEnabled)';
  }
}
