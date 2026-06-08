import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/screens/auth/password/reset_password_screen.dart';
import 'package:pillsync/screens/home_screen/home_tap/home_screen.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_styles.dart';

import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_event.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_state.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final bool isFromRegistration;

  const OTPScreen({
    super.key,
    required this.email,
    required this.isFromRegistration,
  });

  static const String routeName = '/otp';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 5-digit code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is Authenticated) {
            context.go(HomeScreen.routeName, extra: state.user);
          }
          if (state is OTPVerificationSuccess) {
            if (!widget.isFromRegistration) {
              context.pushReplacement(
                ResetPasswordScreen.routeName,
                extra: widget.email,
              );
            }
          }
        },
        child: Padding(
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
                    'We sent a code to ${widget.email}',
                    style: AppStyles.font16MediumGrey,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Enter 5-digit code',
                    style: AppStyles.font14MediumGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.grey300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP resent successfully!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Resend Code',
                    style: AppStyles.font16MediumGrey.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading ? null : _onVerifyPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Verify OTP',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
