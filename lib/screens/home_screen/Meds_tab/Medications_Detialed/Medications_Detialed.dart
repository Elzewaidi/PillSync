import 'package:flutter/material.dart';

import '../../../../utils/app_assets.dart';

class MedicationDetailsScreen extends StatefulWidget {
  static const String routeName = 'med_details';

  // هنا بنجهز المتغيرات اللي هتستقبلها من الـ API (مثلاً الـ ID الخاص بالدواء)
  final String? medId;

  const MedicationDetailsScreen({super.key, this.medId});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  // داتا تجريبية محاكية للباك أند (تبدلها لاحقاً بـ Model)
  final Map<String, dynamic> medData = {
    "name": "Metformin",
    "dosage": "500mg",
    "frequency": "1 tablet, twice daily",
    "instructions":
        "Take one tablet with meals, twice a day. Do not exceed the recommended dosage. Store in a cool, dry place.",
    "history": [
      {"status": "Taken", "period": "Morning", "time": "Today, 8:00 AM"},
      {"status": "Taken", "period": "Evening", "time": "Yesterday, 7:30 PM"},
      {"status": "Taken", "period": "Morning", "time": "Yesterday, 8:15 AM"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Medication Details",
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            // صورة الدواء
            // استبدل جزء الصورة القديم بهذا الكود
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AppAssets.img_med, // استخدام الأصول المحلية بدل الشبكة
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  // في حالة الأصول المحلية يفضل التأكد من وجود الصورة في pubspec.yaml
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.medication,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // الاسم والجرعة
            Text(
              medData["name"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              medData["dosage"],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              medData["frequency"],
              style: const TextStyle(fontSize: 16, color: Color(0xFF546E7A)),
            ),

            const SizedBox(height: 30),

            // قسم التعليمات
            _buildSectionTitle("Instructions"),
            _buildInfoCard(medData["instructions"]),

            const SizedBox(height: 20),

            // قسم السجل (History)
            _buildSectionTitle("History"),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medData["history"].length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final item = medData["history"][index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Text(
                    item["status"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item["period"],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    item["time"],
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // زر البدائل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // هنا لوجيك عرض البدائل
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B4D8),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Show Alternatives",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100), // مساحة عشان الزر العائم
          ],
        ),
      ),
      // شريط التنقل السفلي (Bottom Navigation Bar)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00B4D8),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, "Home"),
              _buildNavItem(
                Icons.medical_services_outlined,
                "Meds",
                isSelected: true,
              ),
              const SizedBox(width: 40), // مكان الزر العائم
              _buildNavItem(Icons.bar_chart_outlined, "Reports"),
              _buildNavItem(Icons.settings_outlined, "Settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.blueGrey,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? const Color(0xFF00B4D8) : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00B4D8) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
