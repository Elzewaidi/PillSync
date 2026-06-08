import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pillsync/features/auth/presentation/pages/otp_page.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:pillsync/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = 'register_screen';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isObscure = true;
  bool isConfirmObscure = true;
  bool agreeToTerms = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.darkBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onRegisterPressed() {
    if (formKey.currentState?.validate() ?? false) {
      if (!agreeToTerms) {
        showAuthSnackBar(context, 'Please agree to the terms');
        return;
      }
      context.read<AuthBloc>().add(
        RegisterRequested(
          fullName: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          phoneNumber: phoneController.text.trim().isEmpty
              ? ''
              : phoneController.text.trim(),
          birthDate: birthDateController.text.isNotEmpty
              ? birthDateController.text
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showAuthSnackBar(context, state.message);
          }
          if (state is RegistrationSuccessMessage) {
            showAuthSnackBar(context, state.message, isError: false);
          }
          if (state is OTPVerificationRequired) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OTPPage(email: state.email, isFromRegistration: true),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.asset(AppAssets.logo_login, height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Join PILLSYNC and manage your medications',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: emailController,
                    label: 'Email Address',
                    hint: 'Enter your email',
                    icon: Icons.email,
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
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: birthDateController,
                    label: 'Birth Date',
                    hint: 'Select your birth date',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: _pickBirthDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your birth date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number (optional)',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Create a password',
                    icon: Icons.lock,
                    obscure: isObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => isObscure = !isObscure);
                      },
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    icon: Icons.lock,
                    obscure: isConfirmObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => isConfirmObscure = !isConfirmObscure);
                      },
                      icon: Icon(
                        isConfirmObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (value) {
                          setState(() => agreeToTerms = value!);
                        },
                        activeColor: AppColors.darkBlue,
                      ),
                      const Expanded(
                        child: Text(
                          'I agree to the Terms & Conditions and Privacy Policy',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkGray,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        label: 'Create Account',
                        isLoading: state is AuthLoading,
                        onPressed: _onRegisterPressed,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
