import 'dart:io';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection _internetConnection;

  NetworkInfoImpl(this._internetConnection);

  @override
  Future<bool> get isConnected async {
    try {
      final hasAccess = await _internetConnection.hasInternetAccess;
      if (hasAccess) return true;

      // Fallback: standard DNS lookup which is more robust on some emulators
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      // Fallback to true to let the actual network requests try and fail gracefully
      return true;
    }
  }
}
