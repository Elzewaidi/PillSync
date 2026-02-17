import 'package:flutter/material.dart';

class MissedAlertsScreen extends StatefulWidget {
  static const String routeName = 'missed_alerts';

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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Missed Medication Alerts",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChange,
            activeColor: const Color(0xFF00B4D8),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) => Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFF5D6778),
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildCustomTextField(
    TextEditingController ctrl,
    String hint, {
    bool isSmall = false,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: isSmall ? 2 : 1,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFECEFF1)),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String sub, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFECEFF1)),
          ),
          child: Text(val),
        ),
      ],
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Preview",
            style: TextStyle(
              color: Color(0xFF1976D2),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Alert Message:\n\"${messageController.text}\"",
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),
          const Text(
            "Motivational Message:\n\"Taking medications on time improves effectiveness\"",
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(String txt) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00B4D8),
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        txt,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
