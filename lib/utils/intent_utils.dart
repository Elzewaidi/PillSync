import 'package:url_launcher/url_launcher.dart';

class IntentUtils {
  /// Launches the device dialer with the target phone number.
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  /// Opens Google Maps for directions to the target coordinates or address.
  static Future<void> openGoogleMapsDirection(double? lat, double? lon, String address) async {
    String googleMapsUrl;
    if (lat != null && lon != null) {
      googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    } else {
      googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";
    }
    final Uri url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
