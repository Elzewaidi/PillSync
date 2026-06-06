import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/profile_model.dart';
import '../models/update_profile_request_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> updateProfile(
    UpdateProfileRequestModel request, {
    required String token,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<ProfileModel> updateProfile(
    UpdateProfileRequestModel request, {
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.editProfile,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('=== EDIT PROFILE RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('=============================');

      if (response.data is Map<String, dynamic>) {
        return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerException(message: 'Unexpected response format');
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
}
