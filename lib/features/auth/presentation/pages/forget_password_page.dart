import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/features/auth/presentation/pages/reset_password_page.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:pillsync/utils/app_assets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';


class ForgetPasswordPage extends StatefulWidget {
  static const String routeName = 'forgot_password_screen';

  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _onSendOTPPressed() {
    if (formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        ForgetPasswordRequested(email: emailController.text.trim()),
      );
    }
  }


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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showAuthSnackBar(context, state.message);
          }

          if (state is ForgetPasswordEmailSent) {
            showAuthSnackBar(
              context,
              'OTP sent to your email!',
              isError: false,
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ResetPasswordPage(email: state.email),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(AppAssets.logo_forget, height: 200),
                      const SizedBox(height: 20),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Enter your email to receive a verification code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        controller: emailController,
                        label: 'Email Address',
                        hint: 'example@gmail.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      AuthButton(
                        label: 'Send OTP',
                        isLoading: state is AuthLoading,
                        onPressed: _onSendOTPPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
