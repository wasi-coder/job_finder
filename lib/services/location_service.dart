import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.locality}, ${place.administrativeArea}, ${place.country}';
      }

      return 'Unknown Location';
    } catch (e) {
      print('Error getting address: $e');
      return 'Unknown Location';
    }
  }

  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  static Future<List<Map<String, dynamic>>> filterJobsByDistance(
    List<Map<String, dynamic>> jobs,
    double userLat,
    double userLng,
    double maxDistanceKm,
  ) async {
    return jobs.where((job) {
      if (job['latitude'] == null || job['longitude'] == null) {
        return false;
      }

      final distance = calculateDistance(
        userLat,
        userLng,
        job['latitude'],
        job['longitude'],
      );

      return (distance / 1000) <= maxDistanceKm; // Convert to km
    }).toList();
  }

  static LatLngBounds getBoundsFromRadius(LatLng center, double radiusKm) {
    const double earthRadius = 6371; // Earth's radius in km

    double latDelta = (radiusKm / earthRadius) * (180 / 3.14159);
    double lngDelta = latDelta / cos(center.latitude * 3.14159 / 180);

    return LatLngBounds(
      southwest: LatLng(center.latitude - latDelta, center.longitude - lngDelta),
      northeast: LatLng(center.latitude + latDelta, center.longitude + lngDelta),
    );
  }

  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }
}