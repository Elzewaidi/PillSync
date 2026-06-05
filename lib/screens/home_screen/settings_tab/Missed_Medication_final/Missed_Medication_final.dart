import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';

class MissedAlertsScreen extends StatefulWidget {
  static const String routeName = '/missed-alerts';

  const MissedAlertsScreen({super.key});

  @override
  State<MissedAlertsScreen> createState() => _MissedAlertsScreenState();
}

class _MissedAlertsScreenState extends State<MissedAlertsScreen> {
  bool enableAlerts = true;
  bool showMotivational = true;
  final messageController = TextEditingController(
    text: "You haven't taken these medications today",
  );
  final motivationalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Missed Medication Alerts",
          style: AppStyles.font18SemiBoldBlack,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildToggleCard(
              "Enable Alerts",
              "Get notified about missed medications",
              enableAlerts,
              (v) => setState(() => enableAlerts = v),
            ),
            const SizedBox(height: 20),
            _buildInputLabel("Alert Time"),
            _buildReadOnlyField(
              "Time to check for missed medications at the end of the day",
              "21:00",
            ),
            const SizedBox(height: 20),
            _buildInputLabel("Alert Message"),
            _buildCustomTextField(
              messageController,
              "Customize the message shown",
            ),
            const SizedBox(height: 20),
            _buildToggleCard(
              "Motivational Message",
              "Show encouraging message in alerts",
              showMotivational,
              (v) => setState(() => showMotivational = v),
            ),
            if (showMotivational) ...[
              const SizedBox(height: 10),
              _buildCustomTextField(
                motivationalController,
                "Enter your motivational message...",
                isSmall: true,
              ),
            ],
            const SizedBox(height: 30),
            _buildPreviewCard(),
            const SizedBox(height: 30),
            _buildSaveButton("Save Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard(
    String title,
    String sub,
    bool value,
    Function(bool) onChange,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChange,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String sub, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(            child: Text(
              sub,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(TextEditingController ctrl, String hint, {bool isSmall = false}) {
    return TextField(
      controller: ctrl,
      maxLines: isSmall ? 1 : 2,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.error),
              const SizedBox(width: 10),
              Text(
                "Preview Alert",
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            messageController.text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(String text) {
    return ElevatedButton(
      onPressed: () => context.pop(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
