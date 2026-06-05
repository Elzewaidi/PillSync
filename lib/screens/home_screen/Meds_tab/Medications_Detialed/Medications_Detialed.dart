import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';
import 'package:pillsync/utils/app_assets.dart';

class MedicationDetailsScreen extends StatefulWidget {
  static const String routeName = '/med_details';

  final String? medId;
  final Map<String, dynamic>? medData;

  const MedicationDetailsScreen({super.key, this.medId, this.medData});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late Map<String, dynamic> medData;

  @override
  void initState() {
    super.initState();
    medData = widget.medData ?? {
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
          "Medication Details",
          style: AppStyles.font18SemiBoldBlack,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
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
                    color: AppColors.grey100,
                    child: const Icon(
                      Icons.medication,
                      size: 80,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // الاسم والجرعة
            Text(
              medData["name"],
              style: AppStyles.font24BoldBlack,
            ),
            const SizedBox(height: 8),
            Text(
              medData["dosage"],
              style: AppStyles.font16MediumGrey,
            ),
            const SizedBox(height: 4),
            Text(
              medData["frequency"],
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
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
                  const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.grey200),
              itemBuilder: (context, index) {
                final item = medData["history"][index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Text(
                    item["status"],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                  ),
                  subtitle: Text(
                    item["period"],
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: Text(
                    item["time"],
                    style: TextStyle(color: AppColors.textHint),
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
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Show Alternatives",
                  style: TextStyle(
                    color: AppColors.white,
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
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white, size: 30),
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
