import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pillsync/features/auth/presentation/pages/reset_password_page.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:pillsync/screens/home_screen/home_tap/home_screen.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OTPPage extends StatefulWidget {
  final String email;
  final bool isFromRegistration;
  const OTPPage({
    super.key,
    required this.email,
    required this.isFromRegistration,
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  String get _otpCode {
    return _controllers.map((c) => c.text.trim()).join();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onVerifyPressed() {
    final otp = _otpCode;
    if (otp.length == 5) {
      context.read<AuthBloc>().add(
        OTPVerificationRequested(
          email: widget.email.trim(),
          otpCode: otp,
          isFromRegistration: widget.isFromRegistration,
        ),
      );
    } else {
      showAuthSnackBar(context, 'Please enter complete 5-digit code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showAuthSnackBar(context, state.message);
          }
          if (state is Authenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomeScreen(user: state.user)),
              (route) => false,
            );
          }
          if (state is OTPVerificationSuccess) {
            if (!widget.isFromRegistration) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ResetPasswordPage(email: widget.email),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
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
                Text(
                  'We sent a code to ${widget.email}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Enter 5-digit code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 55,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.darkBlue,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          final cleanValue = value.trim();

                          if (cleanValue.isNotEmpty && index < 4) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (cleanValue.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      ResendOTPRequested(email: widget.email),
                    );
                    showAuthSnackBar(
                      context,
                      'OTP resent successfully!',
                      isError: false,
                    );
                  },
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
                AuthButton(
                  label: 'Verify OTP',
                  isLoading: state is AuthLoading,
                  onPressed: _onVerifyPressed,
                  color: AppColors.whiteBlue,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
