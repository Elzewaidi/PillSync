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
                  _showAlternativesSheet(context, medData["name"]);
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

  List<Map<String, String>> _getAlternatives(String medName) {
    final nameLower = medName.toLowerCase().trim();
    if (nameLower.contains("panadol") || nameLower.contains("paracetamol") || nameLower.contains("abimol") || nameLower.contains("cetal")) {
      return [
        {
          "name": "Adol",
          "active": "Paracetamol",
          "dosage": "500mg",
          "price": "18 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "ADCO"
        },
        {
          "name": "Abimol",
          "active": "Paracetamol",
          "dosage": "500mg",
          "price": "15 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "GlaxoSmithKline"
        },
        {
          "name": "Cetal",
          "active": "Paracetamol",
          "dosage": "500mg",
          "price": "12 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "EIPICO"
        },
        {
          "name": "Paramol",
          "active": "Paracetamol",
          "dosage": "500mg",
          "price": "14 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Misr Pharma"
        },
      ];
    } else if (nameLower.contains("aspirin") || nameLower.contains("aspocid") || nameLower.contains("jusprin")) {
      return [
        {
          "name": "Jusprin",
          "active": "Acetylsalicylic Acid",
          "dosage": "81mg",
          "price": "20 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "MUP"
        },
        {
          "name": "Aspocid",
          "active": "Acetylsalicylic Acid",
          "dosage": "75mg",
          "price": "15 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "CID"
        },
        {
          "name": "Ecotrin",
          "active": "Acetylsalicylic Acid",
          "dosage": "100mg",
          "price": "30 EGP",
          "match": "90% Match",
          "type": "Similar Dose / Same Ingredient",
          "manufacturer": "Hikma"
        },
      ];
    } else if (nameLower.contains("concor") || nameLower.contains("bistol")) {
      return [
        {
          "name": "Bistol",
          "active": "Bisoprolol Fumarate",
          "dosage": "5mg",
          "price": "40 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Amoun"
        },
        {
          "name": "Sandoz Bisoprolol",
          "active": "Bisoprolol Fumarate",
          "dosage": "5mg",
          "price": "45 EGP",
          "match": "100% Match",
          "type": "Generic Alternative",
          "manufacturer": "Sandoz"
        },
        {
          "name": "Lobeta",
          "active": "Bisoprolol Fumarate",
          "dosage": "5mg",
          "price": "38 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Sigma"
        },
      ];
    } else if (nameLower.contains("augmentin") || nameLower.contains("amoxicillin") || nameLower.contains("curam")) {
      return [
        {
          "name": "Curam",
          "active": "Amoxicillin + Clavulanic Acid",
          "dosage": "1g",
          "price": "85 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Sandoz"
        },
        {
          "name": "Hibiotic",
          "active": "Amoxicillin + Clavulanic Acid",
          "dosage": "1g",
          "price": "75 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Amoun"
        },
        {
          "name": "Megamox",
          "active": "Amoxicillin + Clavulanic Acid",
          "dosage": "1g",
          "price": "80 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Hikma"
        },
      ];
    } else if (nameLower.contains("brufen") || nameLower.contains("ibuprofen") || nameLower.contains("profen")) {
      return [
        {
          "name": "Ibufen",
          "active": "Ibuprofen",
          "dosage": "400mg",
          "price": "22 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Kahira"
        },
        {
          "name": "Profen",
          "active": "Ibuprofen",
          "dosage": "400mg",
          "price": "18 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Alexandria"
        },
        {
          "name": "Catafast",
          "active": "Diclofenac Potassium",
          "dosage": "50mg",
          "price": "45 EGP",
          "match": "85% Match",
          "type": "Same Drug Class (NSAID)",
          "manufacturer": "Novartis"
        },
      ];
    } else {
      final cleanedMed = medName.replaceAll(RegExp(r'\d+.*'), '').trim();
      return [
        {
          "name": "${cleanedMed} Alt 1",
          "active": "${cleanedMed} Generic",
          "dosage": medData["dosage"] ?? "10mg",
          "price": "25 EGP",
          "match": "100% Match",
          "type": "Generic Alternative",
          "manufacturer": "Eva Pharma"
        },
        {
          "name": "${cleanedMed} Alt 2",
          "active": "${cleanedMed} Generic",
          "dosage": medData["dosage"] ?? "10mg",
          "price": "22 EGP",
          "match": "100% Match",
          "type": "Same Active Ingredient",
          "manufacturer": "Pharco"
        },
      ];
    }
  }

  void _showAlternativesSheet(BuildContext context, String medName) {
    final list = _getAlternatives(medName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.swap_horiz_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Medication Alternatives",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                "Substitutes for $medName",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.grey200),
                  Expanded(
                    child: list.isEmpty
                        ? const Center(
                            child: Text(
                              "No alternatives found.",
                              style: TextStyle(color: AppColors.textHint),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(20),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final alt = list[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.cardShadow,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.05),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ExpansionTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.primary.withOpacity(0.1),
                                        child: const Icon(
                                          Icons.medication_liquid_outlined,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            alt["name"]!,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFECFDF5),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              alt["match"]!,
                                              style: const TextStyle(
                                                color: Color(0xFF047857),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "Active: ${alt["active"]!}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      childrenPadding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 16,
                                      ),
                                      children: [
                                        const Divider(height: 1, color: AppColors.grey200),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Strength",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  alt["dosage"]!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Est. Price",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  alt["price"]!,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.cyan[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Manufacturer",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  alt["manufacturer"]!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    medData["name"] = alt["name"]!;
                                                    medData["dosage"] = alt["dosage"]!;
                                                  });
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Replaced with ${alt["name"]!} successfully.",
                                                      ),
                                                      backgroundColor: AppColors.success,
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Select Alternative",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
