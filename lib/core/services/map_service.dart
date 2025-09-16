import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart' as flutter_services;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/location_utils.dart';

class MapsService {
  MapsService._();

  static final MapsService _instance = MapsService._();
  factory MapsService() => _instance;

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      developer.log('Error checking location service: $e');
      return false;
    }
  }

  // Check location permission
  Future<LocationPermission> checkLocationPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      developer.log('Error checking location permission: $e');
      return LocationPermission.denied;
    }
  }

  // Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    try {
      developer.log('Requesting location permission');

      // First check if location service is enabled
      if (!await isLocationServiceEnabled()) {
        throw LocationException.serviceDisabled();
      }

      LocationPermission permission = await checkLocationPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          throw LocationException.permissionDenied();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException.permissionDenied();
      }

      developer.log('Location permission granted: $permission');
      return permission;
    } catch (e) {
      developer.log('Error requesting location permission: $e');
      if (e is LocationException) rethrow;
      throw LocationException.unknown(e.toString());
    }
  }

  // Get current location
  Future<Position> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      developer.log('Getting current location');

      // Check permission first
      final permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw LocationException.permissionDenied();
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );

      developer.log('Current location: ${position.latitude}, ${position.longitude}');
      return position;
    } on LocationException {
      rethrow;
    } on TimeoutException {
      developer.log('Location request timed out');
      throw LocationException.timeout();
    } catch (e) {
      developer.log('Error getting current location: $e');
      throw LocationException.unknown(e.toString());
    }
  }

  // Get last known location
  Future<Position?> getLastKnownLocation() async {
    try {
      developer.log('Getting last known location');

      final permission = await checkLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getLastKnownPosition();

      if (position != null) {
        developer.log('Last known location: ${position.latitude}, ${position.longitude}');
      }

      return position;
    } catch (e) {
      developer.log('Error getting last known location: $e');
      return null;
    }
  }

  // Get address from coordinates (reverse geocoding)
  Future<String> getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    try {
      developer.log('Getting address for: $latitude, $longitude');

      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        final address = [
          placemark.name,
          placemark.subLocality,
          placemark.locality,
          placemark.subAdministrativeArea,
          placemark.administrativeArea,
          placemark.postalCode,
        ].where((element) => element != null && element.isNotEmpty).join(', ');

        developer.log('Address found: $address');
        return address.isNotEmpty ? address : 'Address not found';
      }

      return 'Address not found';
    } catch (e) {
      developer.log('Error getting address: $e');
      return 'Unable to get address';
    }
  }

  // Get coordinates from address (geocoding)
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      developer.log('Getting coordinates for address: $address');

      final locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;
        developer.log('Coordinates found: ${location.latitude}, ${location.longitude}');

        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }

      return null;
    } catch (e) {
      developer.log('Error getting coordinates: $e');
      return null;
    }
  }

  // Get location stream for real-time tracking
  Stream<Position> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int intervalMillis = 10000, // 10 seconds
    double distanceFilter = 10, // 10 meters
  }) {
    try {
      developer.log('Starting location stream');

      final locationSettings = LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter.toInt(),
      );

      return Geolocator.getPositionStream(locationSettings: locationSettings);
    } catch (e) {
      developer.log('Error starting location stream: $e');
      throw LocationException.unknown(e.toString());
    }
  }

  // Calculate distance between two points
  double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return LocationUtils.calculateDistance(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if location is within service area
  bool isLocationInServiceArea(double latitude, double longitude) {
    return LocationUtils.isLocationInIndia(latitude, longitude);
  }

  // Get nearby locations within radius
  List<T> getNearbyLocations<T>(
      double userLatitude,
      double userLongitude,
      List<T> locations,
      double Function(T) getLatitude,
      double Function(T) getLongitude,
      double radiusKm,
      ) {
    return LocationUtils.getLocationsWithinRadius(
      userLatitude,
      userLongitude,
      locations,
      getLatitude,
      getLongitude,
      radiusKm,
    );
  }

  // Sort locations by distance
  List<T> sortLocationsByDistance<T>(
      double userLatitude,
      double userLongitude,
      List<T> locations,
      double Function(T) getLatitude,
      double Function(T) getLongitude,
      ) {
    return LocationUtils.sortByDistance(
      userLatitude,
      userLongitude,
      locations,
      getLatitude,
      getLongitude,
    );
  }

  // Open location in maps app
  Future<void> openLocationInMaps(
      double latitude,
      double longitude, {
        String? label,
      }) async {
    try {
      final url = LocationUtils.generateGoogleMapsUrl(
        latitude,
        longitude,
        label: label,
      );

      developer.log('Opening location in maps: $url');

      // In a real app, you would use url_launcher package
      // await launchUrl(Uri.parse(url));
    } catch (e) {
      developer.log('Error opening maps: $e');
      throw flutter_services.PlatformException(
        code: 'MAPS_ERROR',
        message: 'Unable to open maps application',
      );
    }
  }

  // Open navigation/directions
  Future<void> openDirections(
      double fromLatitude,
      double fromLongitude,
      double toLatitude,
      double toLongitude, {
        String mode = 'driving',
      }) async {
    try {
      final url = LocationUtils.generateDirectionsUrl(
        fromLatitude,
        fromLongitude,
        toLatitude,
        toLongitude,
        mode: mode,
      );

      developer.log('Opening directions: $url');

      // In a real app, you would use url_launcher package
      // await launchUrl(Uri.parse(url));
    } catch (e) {
      developer.log('Error opening directions: $e');
      throw flutter_services.PlatformException(
        code: 'DIRECTIONS_ERROR',
        message: 'Unable to open directions',
      );
    }
  }

  // Get device location settings
  Future<Map<String, dynamic>> getLocationSettings() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      final permission = await checkLocationPermission();

      return {
        'serviceEnabled': serviceEnabled,
        'permission': permission.toString(),
        'hasPermission': permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse,
      };
    } catch (e) {
      developer.log('Error getting location settings: $e');
      return {
        'serviceEnabled': false,
        'permission': 'denied',
        'hasPermission': false,
      };
    }
  }

  // Open app settings for location permission
  Future<bool> openAppSettings() async {
    try {
      developer.log('Opening app settings');
      return await Geolocator.openAppSettings();
    } catch (e) {
      developer.log('Error opening app settings: $e');
      return false;
    }
  }

  // Open location settings
  Future<bool> openLocationSettings() async {
    try {
      developer.log('Opening location settings');
      return await Geolocator.openLocationSettings();
    } catch (e) {
      developer.log('Error opening location settings: $e');
      return false;
    }
  }

  // Get formatted address components
  Future<Map<String, String?>> getAddressComponents(
      double latitude,
      double longitude,
      ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        return {
          'name': placemark.name,
          'street': placemark.street,
          'subLocality': placemark.subLocality,
          'locality': placemark.locality,
          'subAdministrativeArea': placemark.subAdministrativeArea,
          'administrativeArea': placemark.administrativeArea,
          'postalCode': placemark.postalCode,
          'country': placemark.country,
          'isoCountryCode': placemark.isoCountryCode,
        };
      }

      return {};
    } catch (e) {
      developer.log('Error getting address components: $e');
      return {};
    }
  }

  // Validate coordinates
  bool areValidCoordinates(double latitude, double longitude) {
    return LocationUtils.areValidCoordinates(latitude, longitude);
  }

  // Get current location with error handling
  Future<Map<String, dynamic>> getCurrentLocationSafe() async {
    try {
      final position = await getCurrentLocation();

      return {
        'success': true,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'timestamp': position.timestamp,
      };
    } catch (e) {
      developer.log('Safe location fetch failed: $e');

      // Try to get last known location as fallback
      try {
        final lastKnown = await getLastKnownLocation();
        if (lastKnown != null) {
          return {
            'success': true,
            'latitude': lastKnown.latitude,
            'longitude': lastKnown.longitude,
            'accuracy': lastKnown.accuracy,
            'timestamp': lastKnown.timestamp,
            'isLastKnown': true,
          };
        }
      } catch (e2) {
        developer.log('Last known location also failed: $e2');
      }

      // Return default location (Varanasi) if all fails
      return {
        'success': false,
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
        'accuracy': 0.0,
        'timestamp': DateTime.now(),
        'isDefault': true,
        'error': e is LocationException ? e.message : 'Unable to get location',
      };
    }
  }

  // Estimate travel time
  Duration estimateTravelTime(
      double fromLat,
      double fromLon,
      double toLat,
      double toLon, {
        String mode = 'driving',
      }) {
    final distance = calculateDistance(fromLat, fromLon, toLat, toLon);
    return LocationUtils.getEstimatedTravelTime(distance, mode);
  }
}

// Provider
final mapsServiceProvider = Provider<MapsService>((ref) {
  return MapsService();
});