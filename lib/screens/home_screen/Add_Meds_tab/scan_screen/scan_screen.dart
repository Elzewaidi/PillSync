import 'package:flutter/material.dart';

class ScanPrescriptionScreen extends StatelessWidget {
  static const String routeName = 'scan_prescription_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const SizedBox(), // عشان نخلي الـ X على اليمين زي الصورة
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1. برواز الكاميرا (Camera Frame)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8), // لون رمادي فاتح مريح للعين
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFD1D9E6), width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 100,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ),

          // 2. النصوص التوضيحية
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 20,
              left: 40,
              right: 40,
            ),
            child: Column(
              children: [
                const Text(
                  "Scan your prescription",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Place your prescription within the frame and hold steady.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // 3. منطقة الزراير (Retake - Check - Gallery)
          Padding(
            padding: const EdgeInsets.only(bottom: 60, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSideButton(Icons.refresh, "Retake"),
                const SizedBox(width: 25),
                // الزرار الرئيسي اللبني
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B4D8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B4D8).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 35),
                ),
                const SizedBox(width: 25),
                _buildSideButton(Icons.image_outlined, "Gallery"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت للزراير الجانبية الرمادية
  Widget _buildSideButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5D6778)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D6778),
            ),
          ),
        ],
      ),
    );
  }
}
