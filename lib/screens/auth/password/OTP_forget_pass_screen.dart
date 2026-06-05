import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_styles.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});
  static const String routeName = '/otp';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(), 
          icon: const Icon(Icons.arrow_back, color: AppColors.black)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(AppAssets.logo_forget, height: 200),
              const SizedBox(height: 8),
              Text(
                'Enter OTP',
                style: AppStyles.font24BoldBlack,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'We sent a code to email@gmail.com',
                  style: AppStyles.font16MediumGrey,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Enter 6-digit code',
                  style: AppStyles.font14MediumGrey,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.grey300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Resend Code',
                  style: AppStyles.font16MediumGrey.copyWith(color: AppColors.primary),
                ),
              ),
  
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify OTP',
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
    );
  }
}
