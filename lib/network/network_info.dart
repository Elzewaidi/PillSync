import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      if (kIsWeb) {
        // On web, CORS blocks cross-origin requests like HEAD to google.com.
        // Return true and let the actual API call handle connectivity errors.
        debugPrint("🌐 NetworkInfo: Web platform — skipping connectivity check");
        return true;
      } else {
        // On native platforms, use a lightweight HTTP HEAD request.
        final response = await http
            .head(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        return response.statusCode >= 200 && response.statusCode < 400;
      }
    } catch (e) {
      debugPrint("🔴 NetworkInfo: Connectivity check failed — $e");
      return false;
    }
  }
}
