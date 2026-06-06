import 'package:flutter/material.dart';

import 'package:pillsync/features/auth/presentation/pages/login_page.dart';
import 'package:pillsync/features/profile/presentation/pages/profile_page.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Medication_Reminders_final/Medication_Reminders_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Missed_Medication_final/Missed_Medication_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Refill_Rminder_final/Refill_Rminder_final.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Language_final/Language_final.dart';


class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicationRemindersScreen(),
                  ),
                );
              },
            ),
            _buildSettingTile(
              Icons.opacity,
              "Refill Reminder",
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RefillReminderScreen(),
                  ),
                );
              },
            ),
            _buildSettingTile(
              Icons.warning_amber_rounded,
              "Missed Medication Alerts",
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MissedAlertsScreen()),
                );
              },
            ),
            _buildSettingTile(
              Icons.access_time,
              "Snooze Options",
              trailing: const Text(
                "10 minutes",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 25),
            _buildSectionTitle("General"),
            _buildSettingTile(
              Icons.language,
              "Language",
              trailing: const Text(
                "English >",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()),
                );
              },
            ),
            _buildSettingTile(
              Icons.dark_mode_outlined,
              "Dark Theme",
              trailing: Switch(
                value: isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = value;
                  });
                },
                activeColor: const Color(0xFF00B4D8),
              ),
            ),
            const SizedBox(height: 25),
            _buildSectionTitle("Account"),
            _buildSettingTile(
              Icons.person_outline,
              "Profile",
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            _buildSettingTile(
              Icons.logout,
              "Logout",
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ],
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
               Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? const Color(0xFF00B4D8)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
