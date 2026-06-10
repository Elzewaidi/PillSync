import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';

class MissedAlertsScreen extends StatefulWidget {
  static const String routeName = '/missed-alerts';

  const MissedAlertsScreen({super.key});

  @override
  State<MissedAlertsScreen> createState() => _MissedAlertsScreenState();
}

class _MissedAlertsScreenState extends State<MissedAlertsScreen> {
  Box? _settingsBox;
  bool _isLoading = true;

  bool enableAlerts = true;
  bool showMotivational = true;
  final messageController = TextEditingController();
  final motivationalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onTextChanged);
    motivationalController.addListener(_onTextChanged);
    _loadSettings();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    messageController.removeListener(_onTextChanged);
    motivationalController.removeListener(_onTextChanged);
    messageController.dispose();
    motivationalController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('settings');
    setState(() {
      enableAlerts = _settingsBox!.get('enable_missed_alerts', defaultValue: true);
      showMotivational = _settingsBox!.get('missed_alerts_motivational_enabled', defaultValue: true);
      messageController.text = _settingsBox!.get('missed_alerts_message', defaultValue: "You haven't taken these medications today");
      motivationalController.text = _settingsBox!.get('missed_alerts_motivational_message', defaultValue: "Stay strong! Your health is your wealth. 💪");
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (_settingsBox != null) {
      await _settingsBox!.put('enable_missed_alerts', enableAlerts);
      await _settingsBox!.put('missed_alerts_motivational_enabled', showMotivational);
      await _settingsBox!.put('missed_alerts_message', messageController.text.trim());
      await _settingsBox!.put('missed_alerts_motivational_message', motivationalController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Missed dose alert settings saved successfully!"),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
          Expanded(
            child: Text(
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
            messageController.text.isEmpty
                ? "You haven't taken these medications today"
                : messageController.text,
            style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
          if (showMotivational && motivationalController.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Text(
                motivationalController.text,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton(String text) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveSettings,
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
