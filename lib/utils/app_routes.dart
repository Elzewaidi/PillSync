import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/screens/auth/login/login_screen.dart';
import 'package:pillsync/screens/auth/password/OTP_forget_pass_screen.dart';
import 'package:pillsync/screens/auth/password/forget_password.dart';
import 'package:pillsync/screens/auth/register/register_screen.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Meds.dart';
import 'package:pillsync/screens/home_screen/home_tap/home_screen.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Medication_Reminders_final/Medication_Reminders_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Missed_Medication_final/Missed_Medication_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Refill_Rminder_final/Refill_Rminder_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/settings_screen.dart';
import 'package:pillsync/screens/intro_screens/intro_screen.dart';
import 'package:pillsync/screens/splash_screen/splash_screen.dart';
import 'package:pillsync/screens/intro_screens/welcome_screen.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/Add_Meds.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/manual_screen/manual_screen.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/scan_screen/scan_screen.dart';
import 'package:pillsync/screens/home_screen/home_tap/My_schedule/My_schedule.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/Location_pharmacy.dart';
import 'package:pillsync/screens/home_screen/Report_tab/Report.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Language_final/Language_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Profile_final/Profile_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Edit_Profile_final/Edit_Profile_final.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Medications_Detialed/Medications_Detialed.dart';
import 'package:pillsync/screens/auth/password/reset_password_screen.dart';

import 'package:pillsync/features/auth/domain/entities/user.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_state.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: IntroScreen.routeName,
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: WelcomeScreen.routeName,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RegisterScreen.routeName,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: ForgotPasswordScreen.routeName,
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: OTPScreen.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return OTPScreen(
            email: args['email'] as String,
            isFromRegistration: args['isFromRegistration'] as bool,
          );
        },
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) {
          final user = state.extra as User?;
          if (user != null) {
            return HomeScreen(user: user);
          }
          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated) {
            return HomeScreen(user: authState.user);
          }
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: PatientScheduleScreen.routeName,
        builder: (context, state) => const PatientScheduleScreen(),
      ),
      GoRoute(
        path: MedsTabContent.routeName,
        builder: (context, state) => const MedsTabContent(),
      ),
      GoRoute(
        path: AddMedicationScreen.routeName,
        builder: (context, state) => const AddMedicationScreen(),
      ),
      GoRoute(
        path: ScanPrescriptionScreen.routeName,
        builder: (context, state) => ScanPrescriptionScreen(),
      ),
      GoRoute(
        path: ManualEntryScreen.routeName,
        builder: (context, state) => ManualEntryScreen(),
      ),
      GoRoute(
        path: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: MedicationRemindersScreen.routeName,
        builder: (context, state) => MedicationRemindersScreen(),
      ),
      GoRoute(
        path: RefillReminderScreen.routeName,
        builder: (context, state) => const RefillReminderScreen(),
      ),
      GoRoute(
        path: MissedAlertsScreen.routeName,
        builder: (context, state) => const MissedAlertsScreen(),
      ),
      GoRoute(
        path: NearbyPharmaciesScreen.routeName,
        builder: (context, state) => const NearbyPharmaciesScreen(),
      ),
      GoRoute(
        path: ReportsScreen.routeName,
        builder: (context, state) => const ReportsScreen(isTab: false),
      ),
      GoRoute(
        path: ProfileScreen.routeName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: EditProfileScreen.routeName,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: ResetPasswordScreen.routeName,
        builder: (context, state) {
          final email = state.extra as String;
          return ResetPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: LanguageScreen.routeName,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: MedicationDetailsScreen.routeName,
        builder: (context, state) => MedicationDetailsScreen(
          medData: state.extra as Map<String, dynamic>?,
        ),
      ),
    ],
  );
}
