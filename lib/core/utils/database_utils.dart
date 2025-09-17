import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../services/database_service.dart';

/// Utility class for database operations and data seeding
class DatabaseUtils {
  static final DatabaseService _databaseService = DatabaseService.instance;

  /// Upload sample salon and service data to Firestore
  /// This will add the 5 salons and 12 services defined in database_service.dart
  static Future<void> uploadSampleData() async {
    if (kDebugMode) {
      developer.log('🔥 Starting manual upload of sample data to Firestore...');
    }

    try {
      await _databaseService.uploadSampleDataToFirestore();

      if (kDebugMode) {
        developer.log('✅ Sample data uploaded successfully!');
        developer.log('📊 Uploaded: 5 salons + 12 services');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('❌ Error uploading sample data: $e');
      }
      rethrow;
    }
  }

  /// Reset Firestore and upload fresh sample data
  /// This will delete all existing data and upload fresh sample data
  static Future<void> resetAndUploadData() async {
    if (kDebugMode) {
      developer.log('🔄 Resetting Firestore and uploading fresh data...');
    }

    try {
      await _databaseService.resetAndUploadData();

      if (kDebugMode) {
        developer.log('✅ Data reset and upload completed!');
        developer.log('📊 Fresh data: 5 salons + 12 services');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('❌ Error during reset and upload: $e');
      }
      rethrow;
    }
  }

  /// Check if Firestore has any salon data
  static Future<bool> hasExistingData() async {
    try {
      final salons = await _databaseService.getAllSalons();
      return salons.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error checking existing data: $e');
      }
      return false;
    }
  }

  /// Get current data count from Firestore
  static Future<Map<String, int>> getDataCount() async {
    try {
      final salons = await _databaseService.getAllSalons();
      final services = await _databaseService.getAllServices();

      return {
        'salons': salons.length,
        'services': services.length,
      };
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error getting data count: $e');
      }
      return {'salons': 0, 'services': 0};
    }
  }
}