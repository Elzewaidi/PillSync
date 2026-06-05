import 'package:pillsync/model/pharmacy_model.dart';
import 'osm_parser.dart'; 

class GooglePlacesParser {
  static List<PharmacyModel> parseGoogleResponse(
    Map<String, dynamic> response,
    double userLat,
    double userLon,
  ) {
    List<PharmacyModel> pharmacies = [];
    final results = response['results'] as List<dynamic>? ?? [];

    for (var place in results) {
       final location = place['geometry']?['location'];
       if (location == null) continue;

       final double targetLat = (location['lat'] as num).toDouble();
       final double targetLon = (location['lng'] as num).toDouble();

       double distanceInMeters = OsmParser.calculateDistance(
          userLat, userLon, targetLat, targetLon
       );

       final bool isOpen = place['opening_hours']?['open_now'] ?? true;
       final double rating = (place['rating'] as num?)?.toDouble() ?? 4.0;
       
       pharmacies.add(PharmacyModel(
         name: place['name'] ?? "صيدلية",
         rating: rating,
         distanceInMeters: distanceInMeters,
         address: place['vicinity'] ?? "تتوفر الإحداثيات على الخريطة",
         phone: "تفاصيل الرقم غير مدعومة هنا", // NearbySearch API does not return phone num, requires Place Details API
         isOpen: isOpen,
         rawOpeningHours: isOpen ? "مفتوح الآن" : "مغلق الآن",
         latitude: targetLat,
         longitude: targetLon,
       ));
    }

    pharmacies.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));
    return pharmacies;
  }
}
