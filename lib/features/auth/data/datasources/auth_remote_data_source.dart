import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequestModel request);
  Future<UserModel> register(RegisterRequestModel request);
  Future<void> sendOTP(String emailAddress, {String? token});
  Future<bool> verifyOTP(String emailAddress, String otpCode, {String? token, bool requiresAuth});
  Future<void> forgetPassword(String emailAddress);
  

  Future<void> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<UserModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      print('=== LOGIN RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('Data Type: ${response.data.runtimeType}');
      print('======================');

      if (response.data is String) {
        throw ServerException(message: response.data as String);
      }

      if (response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(message: 'Unexpected response format');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      print('=== REGISTER RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('Data Type: ${response.data.runtimeType}');
      print('=========================');

      if (response.data is String) {
        throw ServerException(message: response.data as String);
      }

      if (response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(message: 'Unexpected response format');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> sendOTP(String emailAddress, {String? token}) async {
    try {
      final options = token != null
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null;

      await _dio.post(
        ApiConstants.sendOtp,
        data: {'emailAddress': emailAddress},
        options: options,
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
@override
Future<bool> verifyOTP(
  String emailAddress,
  String otpCode, {
  String? token,
  bool requiresAuth = true,
}) async {
  try {
    final cleanOtp = otpCode.trim();

   
    final options = (token != null && requiresAuth)
        ? Options(headers: {'Authorization': 'Bearer $token'})
        : null;

    final response = await _dio.post(
      ApiConstants.verifyOtp,
      data: {
        'emailAddress': emailAddress.trim(),
        'code': cleanOtp,
      },
      options: options,
    );

    return response.statusCode == 200;
  } on DioException catch (e) {
    _handleDioError(e);
    rethrow;
  }
}

  @override
  Future<void> forgetPassword(String emailAddress) async {
    try {
      await _dio.post(
        ApiConstants.forgetPassword,
        data: {'emailAddress': emailAddress},
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw NetworkException(message: 'Connection timeout. Please try again.');
    }

    if (e.type == DioExceptionType.connectionError) {
      throw NetworkException(message: 'No internet connection.');
    }

    final statusCode = e.response?.statusCode;

    final responseData = e.response?.data;
    String message;

    if (responseData is String && responseData.isNotEmpty) {
      message = responseData;
    } else if (responseData is Map && responseData.containsKey('message')) {
      message = responseData['message']?.toString() ?? 'Unknown error';
    } else if (e.error != null) {
      message = e.error.toString();
    } else {
      message = e.message ?? 'Unknown error';
    }

    if (statusCode == 401) {
      throw UnauthorizedException(message: message);
    }

    throw ServerException(message: message, statusCode: statusCode);
  }

@override
  Future<void> resetPassword({
  required String email,
  required String otpCode,
  required String newPassword,
  required String confirmPassword,
}) async {
  try {
    await _dio.post(
      ApiConstants.resetPassword,
      data: {
        'emailAddress': email,
        'code': otpCode,           
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  } on DioException catch (e) {
    _handleDioError(e);
    rethrow;
  }
}
}