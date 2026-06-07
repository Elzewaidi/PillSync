import 'package:flutter/material.dart';
import 'package:pillsync/utils/app_colors.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/app_assets.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  static const String routeName = 'otp_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(AppAssets.logo_forget),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.enterOtp,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                AppLocalizations.of(context)!.weSentCodeTo,
                style: TextStyle(fontSize: 16, color: AppColors.darkGray),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                AppLocalizations.of(context)!.enterSixDigitCode,
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
              child: Text(
                AppLocalizations.of(context)!.resendCode,
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
                child: Text(
                  AppLocalizations.of(context)!.verifyOtp,
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
