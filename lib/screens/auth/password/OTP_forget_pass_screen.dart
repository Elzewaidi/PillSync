import 'package:flutter/material.dart';
import 'package:pillsync/utils/app_colors.dart';

import '../../../utils/app_assets.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  static const String routeName = 'otp_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(AppAssets.logo_forget),
            const SizedBox(height: 8),
            const Text(
              'Enter OTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: const Text(
                'We sent a code to email@gmail.com',
                style: TextStyle(fontSize: 16, color: AppColors.darkGray),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: const Text(
                'Enter 6-digit code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkBlue,
                ),
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
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Resend Code',
                style: TextStyle(
                  color: AppColors.whiteBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteBlue,
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
    );
  }
}
