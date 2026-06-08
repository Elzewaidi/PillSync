import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Medication_Reminders_final/Medication_Reminders_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Missed_Medication_final/Missed_Medication_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Refill_Rminder_final/Refill_Rminder_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Language_final/Language_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Profile_final/Profile_final.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';

import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_event.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_state.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Settings",
            style: AppStyles.font18SemiBoldBlack,
          ),
          centerTitle: true,
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Reminders"),
              _buildSettingTile(
                Icons.notifications_none,
                "Medication Reminders",
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(MedicationRemindersScreen.routeName),
              ),
              _buildSettingTile(
                Icons.warning_amber_rounded,
                "Missed Dose Alerts",
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(MissedAlertsScreen.routeName),
              ),
              _buildSettingTile(
                Icons.replay_rounded,
                "Refill Reminders",
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(RefillReminderScreen.routeName),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("Account"),
              _buildSettingTile(
                Icons.person_outline,
                "Profile",
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(ProfileScreen.routeName),
              ),
              _buildSettingTile(
                Icons.language_rounded,
                "Language",
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(LanguageScreen.routeName),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("App Settings"),
              _buildSettingTile(
                Icons.dark_mode_outlined,
                "Dark Theme",
                trailing: Switch(
                  value: isDarkTheme,
                  onChanged: (val) {
                    setState(() {
                      isDarkTheme = val;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              _buildSettingTile(
                Icons.logout_rounded,
                "Logout",
                textColor: AppColors.error,
                onTap: () {
                  _showLogoutDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text(
          "Are you sure you want to leave? Your meds will miss you!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Stay"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
