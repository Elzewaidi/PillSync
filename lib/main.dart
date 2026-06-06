import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_event.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_state.dart';
import 'package:pillsync/features/auth/presentation/pages/forget_password_page.dart';
import 'package:pillsync/features/auth/presentation/pages/login_page.dart';
import 'package:pillsync/features/auth/presentation/pages/otp_page.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/Add_Meds.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/manual_screen/manual_screen.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/scan_screen/scan_screen.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Meds.dart';
import 'package:pillsync/screens/home_screen/home_tap/My_schedule/My_schedule.dart';
import 'package:pillsync/screens/home_screen/home_tap/home_screen.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Medication_Reminders_final/Medication_Reminders_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Missed_Medication_final/Missed_Medication_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Refill_Rminder_final/Refill_Rminder_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/settings_screen.dart';

import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(const AppStarted())),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
      ],
      child: MaterialApp(
        title: 'PillSync',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF00B4D8),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Geist',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00B4D8),
            brightness: Brightness.light,
          ),
        ),
        home: const AuthNavigator(),
        routes: {
          PatientScheduleScreen.routeName: (context) => PatientScheduleScreen(),
          MedsTabContent.routeName: (context) => MedsTabContent(),
          AddMedicationScreen.routeName: (context) => AddMedicationScreen(),
          ScanPrescriptionScreen.routeName: (context) =>
              ScanPrescriptionScreen(),
          ManualEntryScreen.routeName: (context) => ManualEntryScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          MedicationRemindersScreen.routeName: (context) =>
              MedicationRemindersScreen(),
          RefillReminderScreen.routeName: (context) => RefillReminderScreen(),
          MissedAlertsScreen.routeName: (context) => MissedAlertsScreen(),
        },
      ),
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
            ),
          );
        }

        if (state is Authenticated) {
          return HomeScreen(user: state.user);
        }

        if (state is OTPVerificationRequired) {
          return OTPPage(email: state.email, isFromRegistration: true);
        }

        if (state is RegistrationSuccess) {
          return OTPPage(email: state.email, isFromRegistration: true);
        }

        if (state is NavigateToForgetPasswordState) {
          return const ForgetPasswordPage();
        }
        if (state is ForgetPasswordEmailSent) {
          return OTPPage(email: state.email, isFromRegistration: false);
        }

        if (state is OTPVerificationSuccess) {
          return const LoginPage();
        }
        if (state is ResetPasswordSuccess) {
          return const LoginPage();
        }

        if (state is AuthIdle) {
          return const LoginPage();
        }

        return const LoginPage();
      },
    );
  }
}
