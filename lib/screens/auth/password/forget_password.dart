import 'package:flutter/material.dart';
import 'package:pillsync/custom_widgets/custom_text_form_field.dart';
import 'package:pillsync/utils/app_assets.dart';
import '../../../utils/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = 'forgot_password_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(AppAssets.logo_forget, height: 200),
                const SizedBox(height: 20),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your email to receive a verification code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 40),
                const CustomTextFormField(
                  label: "Email Address",
                  hint: 'example@gmail.com',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}