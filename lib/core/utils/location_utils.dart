import 'dart:math';

import '../constants/app_constants.dart';

class LocationUtils {
  LocationUtils._();

  // Calculate distance between two points using Haversine formula
  static double calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Check if location is within explore radius
  static bool isWithinRadius(
      double userLat,
      double userLon,
      double targetLat,
      double targetLon,
      double radiusKm,
      ) {
    final distance = calculateDistance(userLat, userLon, targetLat, targetLon);
    return distance <= radiusKm;
  }

  // Get locations within radius
  static List<T> getLocationsWithinRadius<T>(
      double userLat,
      double userLon,
      List<T> locations,
      double Function(T) getLatitude,
      double Function(T) getLongitude,
      double radiusKm,
      ) {
    return locations.where((location) {
      return isWithinRadius(
        userLat,
        userLon,
        getLatitude(location),
        getLongitude(location),
        radiusKm,
      );
    }).toList();
  }

  // Sort locations by distance from user
  static List<T> sortByDistance<T>(
      double userLat,
      double userLon,
      List<T> locations,
      double Function(T) getLatitude,
      double Function(T) getLongitude,
      ) {
    locations.sort((a, b) {
      final distanceA = calculateDistance(
        userLat,
        userLon,
        getLatitude(a),
        getLongitude(a),
      );

      final distanceB = calculateDistance(
        userLat,
        userLon,
        getLatitude(b),
        getLongitude(b),
      );

      return distanceA.compareTo(distanceB);
    });

    return locations;
  }

  // Format distance for display
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    } else if (distanceKm < 10) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceKm.round()} km';
    }
  }

  // Get distance category
  static String getDistanceCategory(double distanceKm) {
    if (distanceKm <= 1) return 'Very Close';
    if (distanceKm <= 3) return 'Nearby';
    if (distanceKm <= 5) return 'Close';
    if (distanceKm <= 10) return 'Within City';
    return 'Far';
  }

  // Check if coordinates are valid
  static bool areValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  // Get center point of multiple locations
  static Map<String, double> getCenterPoint(List<Map<String, double>> locations) {
    if (locations.isEmpty) {
      return {
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
      };
    }

    double sumLat = 0;
    double sumLon = 0;

    for (final location in locations) {
      sumLat += location['latitude']!;
      sumLon += location['longitude']!;
    }

    return {
      'latitude': sumLat / locations.length,
      'longitude': sumLon / locations.length,
    };
  }

  // Get bounding box for multiple locations
  static Map<String, double> getBoundingBox(List<Map<String, double>> locations) {
    if (locations.isEmpty) {
      return {
        'minLatitude': AppConstants.defaultLatitude - 0.01,
        'maxLatitude': AppConstants.defaultLatitude + 0.01,
        'minLongitude': AppConstants.defaultLongitude - 0.01,
        'maxLongitude': AppConstants.defaultLongitude + 0.01,
      };
    }

    double minLat = locations.first['latitude']!;
    double maxLat = locations.first['latitude']!;
    double minLon = locations.first['longitude']!;
    double maxLon = locations.first['longitude']!;

    for (final location in locations) {
      final lat = location['latitude']!;
      final lon = location['longitude']!;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lon < minLon) minLon = lon;
      if (lon > maxLon) maxLon = lon;
    }

    return {
      'minLatitude': minLat,
      'maxLatitude': maxLat,
      'minLongitude': minLon,
      'maxLongitude': maxLon,
    };
  }

  // Calculate bearing between two points
  static double calculateBearing(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double y = sin(dLon) * cos(_degreesToRadians(lat2));
    final double x = cos(_degreesToRadians(lat1)) * sin(_degreesToRadians(lat2)) -
        sin(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * cos(dLon);

    double bearing = atan2(y, x);
    bearing = bearing * (180 / pi);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  // Get direction text from bearing
  static String getDirectionText(double bearing) {
    if (bearing >= 337.5 || bearing < 22.5) return 'North';
    if (bearing >= 22.5 && bearing < 67.5) return 'Northeast';
    if (bearing >= 67.5 && bearing < 112.5) return 'East';
    if (bearing >= 112.5 && bearing < 157.5) return 'Southeast';
    if (bearing >= 157.5 && bearing < 202.5) return 'South';
    if (bearing >= 202.5 && bearing < 247.5) return 'Southwest';
    if (bearing >= 247.5 && bearing < 292.5) return 'West';
    if (bearing >= 292.5 && bearing < 337.5) return 'Northwest';
    return 'Unknown';
  }

  // Generate Google Maps URL
  static String generateGoogleMapsUrl(
      double latitude,
      double longitude, {
        String? label,
        int zoom = 15,
      }) {
    final labelParam = label != null ? '($label)' : '';
    return 'https://www.google.com/maps/explore/?api=1&query=$latitude,$longitude$labelParam&zoom=$zoom';
  }

  // Generate directions URL
  static String generateDirectionsUrl(
      double fromLat,
      double fromLon,
      double toLat,
      double toLon, {
        String mode = 'driving', // driving, walking, transit
      }) {
    return 'https://www.google.com/maps/dir/?api=1&origin=$fromLat,$fromLon&destination=$toLat,$toLon&travelmode=$mode';
  }

  // Check if location is in India (approximate bounds)
  static bool isLocationInIndia(double latitude, double longitude) {
    // Approximate bounding box for India
    const double minLat = 6.0;
    const double maxLat = 37.6;
    const double minLon = 68.0;
    const double maxLon = 97.4;

    return latitude >= minLat &&
        latitude <= maxLat &&
        longitude >= minLon &&
        longitude <= maxLon;
  }

  // Get estimated travel time (rough calculation)
  static Duration getEstimatedTravelTime(
      double distanceKm,
      String mode, // walking, driving, transit
      ) {
    double speedKmh;

    switch (mode.toLowerCase()) {
      case 'walking':
        speedKmh = 5.0; // 5 km/h average walking speed
        break;
      case 'driving':
        speedKmh = 25.0; // 25 km/h average city driving speed
        break;
      case 'transit':
        speedKmh = 20.0; // 20 km/h average transit speed
        break;
      default:
        speedKmh = 25.0;
    }

    final hours = distanceKm / speedKmh;
    final minutes = (hours * 60).round();

    return Duration(minutes: minutes);
  }

  // Format travel time
  static String formatTravelTime(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
    }
  }

  // Get nearby areas/localities (mock data - would normally come from API)
  static List<String> getNearbyAreas(double latitude, double longitude) {
    // This would typically call a geocoding API
    // For now, returning mock data based on Varanasi coordinates
    if (isLocationInIndia(latitude, longitude)) {
      return [
        'Cantonment',
        'Lanka',
        'Sigra',
        'Bhelupur',
        'Mahmoorganj',
        'Nadesar',
        'Shivpur',
        'Ramnagar',
      ];
    }

    return [];
  }

  // Parse coordinates from string
  static Map<String, double>? parseCoordinatesFromString(String coordString) {
    try {
      final parts = coordString.split(',');
      if (parts.length == 2) {
        final lat = double.parse(parts[0].trim());
        final lon = double.parse(parts[1].trim());

        if (areValidCoordinates(lat, lon)) {
          return {'latitude': lat, 'longitude': lon};
        }
      }
    } catch (e) {
      // Invalid format
    }

    return null;
  }

  // Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  // Get zoom level based on radius
  static double getZoomForRadius(double radiusKm) {
    if (radiusKm <= 1) return 16.0;
    if (radiusKm <= 2) return 15.0;
    if (radiusKm <= 5) return 14.0;
    if (radiusKm <= 10) return 13.0;
    if (radiusKm <= 20) return 12.0;
    return 11.0;
  }

  // Check if user is likely at home (based on time and frequent location)
  static bool isLikelyAtHome(DateTime currentTime) {
    final hour = currentTime.hour;
    // Assume home between 10 PM and 8 AM
    return hour >= 22 || hour <= 8;
  }

  // Get service availability based on location and time
  static bool isServiceAvailableAtLocation(
      double latitude,
      double longitude,
      String serviceType,
      DateTime requestTime,
      ) {
    // Check if location is in service area (within India for this app)
    if (!isLocationInIndia(latitude, longitude)) {
      return false;
    }

    // Check business hours (9 AM to 9 PM)
    final hour = requestTime.hour;
    if (hour < 9 || hour >= 21) {
      return false;
    }

    // Home services have different availability
    if (serviceType == AppConstants.homeService) {
      // Home services available 10 AM to 8 PM
      return hour >= 10 && hour < 20;
    }

    return true;
  }
}