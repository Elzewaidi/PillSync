import 'dart:math';
import 'package:pillsync/model/pharmacy_model.dart';

class OpeningInfo {
  final bool isOpen;
  final String statusText;

  OpeningInfo({required this.isOpen, required this.statusText});
}

class OsmParser {
  /// Parses JSON elements from Overpass API into a sorted list of PharmacyModel.
  static List<PharmacyModel> parseOsmResponse(
    List elements,
    double userLat,
    double userLon,
  ) {
    List<PharmacyModel> pharmacies = [];

    for (var element in elements) {
      final tags = element['tags'] ?? {};

      final double? targetLat = element['lat'] ?? element['center']?['lat'];
      final double? targetLon = element['lon'] ?? element['center']?['lon'];

      if (targetLat == null || targetLon == null) continue;

      double distanceInMeters = calculateDistance(
        userLat,
        userLon,
        targetLat,
        targetLon,
      );

      final openingInfo = _parseOpeningHours(tags['opening_hours']);

      pharmacies.add(PharmacyModel(
        name: _parseName(tags),
        rating: 4.0 + ((tags.hashCode.abs() % 10) / 10), // Pseudo-random rating 4.0+
        distanceInMeters: distanceInMeters,
        address: _parseAddress(tags),
        phone: _parsePhone(tags),
        isOpen: openingInfo.isOpen,
        rawOpeningHours: openingInfo.statusText,
        latitude: targetLat,
        longitude: targetLon,
      ));
    }

    // Sort structurally closest first based on raw double
    pharmacies.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

    return pharmacies;
  }

  static String _parseName(Map tags) {
    String name = tags['name:ar'] ?? tags['name'] ?? tags['name:en'] ?? tags['brand'] ?? "";
    if (name.isEmpty) return "صيدلية (Pharmacy)";
    return name;
  }

  static String _parseAddress(Map tags) {
    String addr = tags['addr:full'] ?? tags['addr:street'] ?? tags['addr:city'] ?? "";
    if (addr.isEmpty) return "تتوفر الإحداثيات على الخريطة";
    return addr;
  }

  static String _parsePhone(Map tags) {
    String? rawPhone = tags['phone'] ?? tags['contact:phone'] ?? tags['contact:mobile'];
    
    if (rawPhone == null || rawPhone.isEmpty) {
      return "غير متوفر";
    }

    // Remove any non-digit character except the leading +
    rawPhone = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

    // Common normalization for local Egyptian numbers starting with '01'
    // Converts 01012345678 to +201012345678
    if (rawPhone.startsWith('01') && rawPhone.length == 11) {
      rawPhone = '+2$rawPhone';
    }

    // If it lacks +, we still present it purely as numbers
    if (rawPhone.isEmpty) return "غير متوفر";
    
    return rawPhone;
  }

  static OpeningInfo _parseOpeningHours(String? hours) {
    // If no data is available on OSM, we assume it's open for user convenience, indicating unverified.
    if (hours == null || hours.trim().isEmpty) {
      return OpeningInfo(isOpen: true, statusText: "مفتوح (أوقات العمل غير مؤكدة)");
    }

    final lowerHours = hours.toLowerCase();

    // The most common standard OSM tag for constant opening
    if (lowerHours.contains("24/7")) {
      return OpeningInfo(isOpen: true, statusText: "مفتوح 24/7");
    }
    
    if (lowerHours == "off" || lowerHours == "closed") {
       return OpeningInfo(isOpen: false, statusText: "مغلق الآن");
    }

    // Parsing complex OSM 'opening_hours' format (Mo-Fr 08:00-20:00) natively is heavy.
    // Instead, we pass it safely to the UI. We'll default to open to avoid locking the UI action.
    return OpeningInfo(isOpen: true, statusText: "ساعات العمل: $hours");
  }

  /// Calculates distance in meters using Haversine formula (Pure Dart, no packages)
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742000 * asin(sqrt(a)); // 2 * R * asin... where R=6371 km
  }
}
