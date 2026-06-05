import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/custom_widgets/custom_text_form_field.dart';
import 'package:pillsync/screens/auth/password/OTP_forget_pass_screen.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = '/forget-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            context.pop();
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
                Text(
                  'Forgot Password?',
                  style: AppStyles.font24BoldBlack,
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter your email to receive a verification code',
                  textAlign: TextAlign.center,
                  style: AppStyles.font16MediumGrey,
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
                    onPressed: () => context.push(OTPScreen.routeName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
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