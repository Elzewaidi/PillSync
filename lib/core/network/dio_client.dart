import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(ApiConstants.dioOptions);

    _dio.interceptors.addAll([_loggingInterceptor(), _errorInterceptor()]);
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          debugPrint('┌──  REQUEST ──────────────────────────────');
          debugPrint('│ ${options.method} ${options.path}');
          debugPrint('│ Headers: ${options.headers}');
          debugPrint('│ Data: ${options.data}');
          debugPrint('└─────────────────────────────────────────────');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('┌── RESPONSE ─────────────────────────────');
          debugPrint('│ Status: ${response.statusCode}');
          debugPrint('│ Data: ${response.data}');
          debugPrint('└─────────────────────────────────────────────');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          debugPrint('┌──  ERROR ─────────────────────────────────');
          debugPrint('│ Status: ${error.response?.statusCode}');
          debugPrint('│ Message: ${error.message}');
          debugPrint('│ Data: ${error.response?.data}');
          debugPrint('└─────────────────────────────────────────────');
        }
        handler.next(error);
      },
    );
  }

  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        String? message;

        switch (error.response?.statusCode) {
          case 401:
            message = 'Session expired. Please login again.';
            break;
          case 403:
            message = 'Access forbidden.';
            break;
          case 404:
            message = 'Resource not found.';
            break;
          case 422:
            final data = error.response?.data;
            if (data is Map && data.containsKey('message')) {
              message = data['message'];
            }
            break;
          case 429:
            message = 'Too many requests. Please try again later.';
            break;
          case 500:
          case 502:
          case 503:
            message = 'Server error. Please try again later.';
            break;
        }

        final newError = DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: message ?? error.error,
        );

        handler.next(newError);
      },
    );
  }
}
