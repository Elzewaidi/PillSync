import 'package:flutter/material.dart';
import 'package:pillsync/custom_widgets/custom_text_form_field.dart';
import 'package:pillsync/screens/auth/password/forget_password.dart';
import 'package:pillsync/screens/auth/register/register_screen.dart';
import 'package:pillsync/screens/home_screen/home_tap/home_screen.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  bool isRememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(AppAssets.logo_login, height: 100),
                const SizedBox(height: 8),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign in to continue to PILLSYNC',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock,
                  obscure: isObscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMe,
                      activeColor: AppColors.darkBlue,
                      onChanged: (value) {
                        setState(() {
                          isRememberMe = value!;
                        });
                      },
                    ),
                    const Text(
                      "Remember me",
                      style: TextStyle(
                          color: AppColors.whiteGray, fontSize: 14),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ForgotPasswordScreen.routeName);
                      },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routeName);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.whiteBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Or continue with ',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.darkGray.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppAssets.logo_google, height: 24),
                              const SizedBox(width: 8),
                              const Text('Google'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.darkGray.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppAssets.logo_apple, height: 24),
                              const SizedBox(width: 8),
                              const Text('Apple'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}