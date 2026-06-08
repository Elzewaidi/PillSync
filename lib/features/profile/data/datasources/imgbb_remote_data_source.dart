import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ImgbbRemoteDataSource {
 
  Future<String> uploadImage(File imageFile);
}

class ImgbbRemoteDataSourceImpl implements ImgbbRemoteDataSource {
  
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 60), 
    ),
  );

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
  
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final formData = FormData.fromMap({
        'key': ApiConstants.imgbbApiKey,
        'image': base64Image,
      });

      final response = await _dio.post(
        ApiConstants.imgbbUploadUrl,
        data: formData,
        options: Options(
        
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;

        if (data['success'] == true) {
        
          final imageUrl = data['data']['url'] as String?;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return imageUrl;
          }
        }

      
        final errorMessage =
            data['error']?['message'] as String? ?? 'Image upload failed';
        throw ServerException(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }

      throw ServerException(
        message: 'Failed to upload image. Status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          message: 'Connection timeout while uploading image.',
        );
      }
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'No internet connection.');
      }
      throw ServerException(
        message: e.message ?? 'Image upload failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
