import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'end_points.dart';

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => message;
}

class ApiManager {
  static const String _token =
      'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFsend5ZHlzeWQzQGdtYWlsLmNvbSIsIm5hbWVpZCI6IjdiYzRhYWZhLTY0OWYtNDBiNi05NWM5LWM2NzkzMDUyOGIxNSIsIm5iZiI6MTc3NTczMDc1NywiZXhwIjoxNzc4MzIyNzU3LCJpYXQiOjE3NzU3MzA3NTd9.nJHe9992daZWoSmBGw8bzl3upNIaG7Ocg77kwQrbM3gdo9bX3HPnm7sylXt13r0T8HA9TFJQi1ASKA6l87q7DA';

  Future<http.Response> getRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('${EndPoints.baseUrl}$endpoint');
      return await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
          ...?headers,
        },
      );
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
      final uri = Uri.parse('${EndPoints.baseUrl}$endpoint');
      return await http.post(
        uri,
        headers: const {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(body),
      );
    } on SocketException {
      throw const NetworkException(
        'No internet connection. Please check your network.',
      );
    }
  }

  Future<http.Response> putRequest({required String endpoint}) async {
    try {
      final uri = Uri.parse('${EndPoints.baseUrl}$endpoint');
      return await http.put(
        uri,
        headers: const {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
    } on SocketException {
      throw const NetworkException(
        'No internet connection. Please check your network.',
      );
    }
  }
}
