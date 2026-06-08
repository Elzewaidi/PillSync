import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class ApiManager {
  late final Dio _dio;

  ApiManager() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: ApiConstants.apiTimeOutInSeconds),
        receiveTimeout: const Duration(seconds: ApiConstants.apiTimeOutInSeconds),
        responseType: ResponseType.json,
      ),
    );
    
    // Interceptors for global logging, tokens, and monitoring requests easily
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint("🟢 API Request: [${options.method}] ${options.uri}");
        if (ApiConstants.authToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${ApiConstants.authToken}';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("🔵 API Response: ${response.statusCode}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint("🔴 API Error: ${e.message}");
        return handler.next(e);
      },
    ));
  }

  /// Generic POST Request Executor using Dio
  Future<dynamic> postData(String url, {dynamic data, Map<String, dynamic>? headers, String? contentType}) async {
    try {
      final response = await _dio.post(
        url, 
        data: data, 
        options: Options(headers: headers, contentType: contentType)
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow; // Never reached, but satisfies the compiler
    }
  }

  /// Generic GET Request Executor using Dio
  Future<dynamic> getData(String url, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
       _handleDioError(e);
       rethrow; // Never reached, but satisfies the compiler
    }
  }

  void _handleDioError(DioException e) {
    debugPrint("🔴 API DioException Type: ${e.type}");
    debugPrint("🔴 API DioException Message: ${e.message}");
    if (e.response != null) {
      debugPrint("🔴 API Response Status: ${e.response?.statusCode}");
      debugPrint("🔴 API Response Body: ${e.response?.data}");
    }
    
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Connection Timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('Connection Error: Could not reach the server. ${e.message}');
    } else if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final body = e.response?.data;
      throw Exception('Server Error (Status: $statusCode) — $body');
    } else {
      throw Exception('Network Error: ${e.message}');
    }
  }
}
