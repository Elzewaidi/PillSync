import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationDetails {
  final double latitude;
  final double longitude;
  final String localityName;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.localityName,
  });
}

abstract class LocationService {
  Future<void> checkPermissions();
  Future<LocationDetails> getCurrentLocationDetails();
  Stream<LocationDetails> getLocationStream({int distanceFilter = 100});
}

class LocationServiceImpl implements LocationService {
  @override
  Future<void> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("خدمات الموقع معطلة. يرجى تفعيل الـ GPS.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("تم رفض صلاحية الموقع. لا يمكننا المتابعة بدونها.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("تم رفض الصلاحية نهائياً من إعدادات النظام.");
    }
  }

  @override
  Future<LocationDetails> getCurrentLocationDetails() async {
    await checkPermissions();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final localityName = await _getLocalityName(position);
    
    return LocationDetails(
      latitude: position.latitude,
      longitude: position.longitude,
      localityName: localityName,
    );
  }

  @override
  Stream<LocationDetails> getLocationStream({int distanceFilter = 100}) {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .asyncMap((position) async {
      final localityName = await _getLocalityName(position);
      return LocationDetails(
        latitude: position.latitude,
        longitude: position.longitude,
        localityName: localityName,
      );
    });
  }

  Future<String> _getLocalityName(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        String area = place.subAdministrativeArea ??
            place.locality ??
            place.administrativeArea ??
            "موقعك الحالي";
        if (area.trim().isEmpty) return "موقعك الحالي";
        return area;
      }
    } catch (_) {}
    return "موقع غير معروف";
  }
}
