import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/cubit/add_medication/add_medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/screens/auth/login/login_screen.dart';
import 'package:pillsync/screens/auth/password/OTP_forget_pass_screen.dart';
import 'package:pillsync/screens/auth/password/forget_password.dart';
import 'package:pillsync/screens/auth/register/register_screen.dart';
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
import 'package:pillsync/screens/intro_screens/intro_screen.dart';
import 'package:pillsync/screens/intro_screens/welcome_screen.dart';
import 'package:pillsync/screens/splash_screen/splash_screen.dart';

import 'l10n/app_localizations.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MedicationRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            MedicationCubit(
              context.read<MedicationRepository>(),
            )
              ..loadMedications(),
          ),
          BlocProvider(
            create: (context) =>
                AddMedicationCubit(
                  context.read<MedicationRepository>(),
                ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PillSync',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.primary,
            ),
            scaffoldBackgroundColor: AppColors.surfaceBackground,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: AppColors.black),
            ),
          ),
          locale: Locale("en"),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: HomeScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            IntroScreen.routeName: (context) => const IntroScreen(),
            WelcomeScreen.routeName: (context) => const WelcomeScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            RegisterScreen.routeName: (context) => RegisterScreen(),
            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
            OTPScreen.routeName: (context) => OTPScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            PatientScheduleScreen.routeName: (context) =>
                PatientScheduleScreen(),
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
      ),
    );
  }
}