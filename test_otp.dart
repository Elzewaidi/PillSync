import 'dart:convert';

import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(validateStatus: (status) => true));

  print('Step 1: Getting a temporary email address from Guerrillamail...');
  final emailResponse = await dio.get(
    'https://api.guerrillamail.com/ajax.php?f=get_email_address',
  );

  if (emailResponse.statusCode != 200 || emailResponse.data == null) {
    print('Failed to get email address');
    return;
  }

  final emailData = emailResponse.data is String
      ? jsonDecode(emailResponse.data)
      : emailResponse.data;
  final email = emailData['email_addr'] as String;
  final sidToken = emailData['sid_token'] as String;

  print('Email acquired: $email');
  print('Sid Token: $sidToken');

  print('\nStep 2: Registering user on PillSync API with email: $email');
  final registerResponse = await dio.post(
    'https://pillsync-api.onrender.com/api/account/register',
    data: {
      'fullName': 'Test User',
      'emailAddress': email,
      'password': 'Password123!',
      'confirmPassword': 'Password123!',
      'phoneNumber': '01234567890',
      'birthDate': '2000-01-01',
    },
  );

  print('Register Status: ${registerResponse.statusCode}');
  print('Register Response Body: ${registerResponse.data}');

  if (registerResponse.statusCode != 200) {
    print('Failed to register');
    return;
  }

  print('\nStep 3: Checking Guerrillamail inbox for verification email...');
  // We will check every 5 seconds, up to 10 times.
  String? emailId;
  for (int i = 0; i < 12; i++) {
    print('Checking inbox (attempt ${i + 1}/12)...');
    final checkResponse = await dio.get(
      'https://api.guerrillamail.com/ajax.php?f=check_email&seq=0&sid_token=$sidToken',
    );

    final checkData = checkResponse.data is String
        ? jsonDecode(checkResponse.data)
        : checkResponse.data;

    final list = checkData['list'] as List?;
    if (list != null && list.isNotEmpty) {
      // Find a message that is not the welcome email
      for (var msg in list) {
        final subject = msg['mail_subject']?.toString() ?? '';
        final from = msg['mail_from']?.toString() ?? '';
        print('Message found: From: $from, Subject: $subject');
        if (!subject.contains('Welcome') &&
            !from.contains('no-reply@guerrillamail.com')) {
          emailId = msg['mail_id']?.toString();
          break;
        }
      }
    }

    if (emailId != null) {
      break;
    }

    await Future.delayed(const Duration(seconds: 5));
  }

  if (emailId == null) {
    print('No verification email received in 60 seconds.');
    return;
  }

  print('\nStep 4: Fetching email content for ID: $emailId');
  final fetchResponse = await dio.get(
    'https://api.guerrillamail.com/ajax.php?f=fetch_email&email_id=$emailId&sid_token=$sidToken',
  );

  final fetchData = fetchResponse.data is String
      ? jsonDecode(fetchResponse.data)
      : fetchResponse.data;

  final body = fetchData['mail_body'] as String?;
  print('\n=== EMAIL BODY ===');
  print(body);
  print('==================');
}
