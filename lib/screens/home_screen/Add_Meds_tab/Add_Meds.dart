import 'package:flutter/material.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/scan_screen/scan_screen.dart';

import 'manual_screen/manual_screen.dart';

class AddMedicationScreen extends StatelessWidget {
  static const String routeName = 'add_medication_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Medication",
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How would you like to add your medication?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30),

            // خيار الـ Scan
            _buildOptionCard(
              context,
              title: "Scan Prescription",
              subtitle: "Use your camera to scan your prescription",
              icon: Icons.camera_alt_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanPrescriptionScreen(),
                ),
              ),
            ),

            SizedBox(height: 20),

            // خيار الـ Manual
            _buildOptionCard(
              context,
              title: "Enter Details Manually",
              subtitle: "Manually enter medication details",
              icon: Icons.edit_note_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManualEntryScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFF00BCD4)),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
