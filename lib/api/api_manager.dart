import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pillsync/injection_container.dart' as di;
import 'package:pillsync/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pillsync/core/errors/exceptions.dart';

import 'end_points.dart';

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => message;
}

class ApiManager {
  Future<String> _getToken() async {
    try {
      final token = await di.sl<AuthLocalDataSource>().getCachedToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
      return "";
    } catch (_) {
      return "";
    }
  }

  Future<http.Response> getRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${EndPoints.baseUrl}$endpoint');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          ...?headers,
        },
      );
      if (response.statusCode == 401) {
        throw UnauthorizedException(message: 'Unauthorized access. Please login again.');
      }
      return response;
    } on SocketException {
      throw const NetworkException(
        'No internet connection. Please check your network.',
      );
    }
  }

  Future<http.Response> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${EndPoints.baseUrl}$endpoint');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 401) {
        throw UnauthorizedException(message: 'Unauthorized access. Please login again.');
      }
      return response;
    } on SocketException {
      throw const NetworkException(
        'No internet connection. Please check your network.',
      );
    }
  }

  Future<http.Response> putRequest({required String endpoint}) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${EndPoints.baseUrl}$endpoint');
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 401) {
        throw UnauthorizedException(message: 'Unauthorized access. Please login again.');
      }
      return response;
    } on SocketException {
      throw const NetworkException(
        'No internet connection. Please check your network.',
      );
    }
  }
}
