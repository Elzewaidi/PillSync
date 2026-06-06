class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server Error', this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache Error'});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'No Internet Connection'});
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({this.message = 'Unauthorized'});
}

class OTPException implements Exception {
  final String message;

  OTPException({this.message = 'OTP Verification Failed'});
}

