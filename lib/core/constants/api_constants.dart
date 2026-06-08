import 'package:dio/dio.dart';

class ApiConstants {
  static const String baseUrl = 'https://pillsync-api.onrender.com';
  static const String apiVersion = '/api';

  static const String register = '$apiVersion/account/register';
  static const String login = '$apiVersion/account/Login';
  static const String sendOtp = '$apiVersion/account/Send-otp';
  static const String verifyOtp = '$apiVersion/account/Verify-otp';
  static const String forgetPassword = '$apiVersion/account/Forgot-password/request';
  static const String resetPassword = '$apiVersion/account/Forgot-password/reset';
  static const String editProfile = '$apiVersion/account/EditProfile';

  static const String imgbbApiKey = 'b15ef6cc7cf6fead2cf3fa8fe7bad69e';
  static const String imgbbUploadUrl = 'https://api.imgbb.com/1/upload';



  static BaseOptions get dioOptions => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},

    validateStatus: (status) {
      if (status == null) return false;
      return status >= 200 && status < 300;
    },
  );
}

