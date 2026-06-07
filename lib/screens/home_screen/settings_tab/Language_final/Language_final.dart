import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class LanguageScreen extends StatefulWidget {
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLang = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Language", style: TextStyle(color: AppColors.black)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your preferred language",
              style: TextStyle(color: Color(0xFF5D6778)),
            ),
            const SizedBox(height: 20),
            _buildLangTile("English", "English"),
            _buildLangTile("Arabic", "العربية"),
          ],
        ),
      ),
    );
  }

  Widget _buildLangTile(String title, String sub) {
    bool isSelected = selectedLang == title;
    return GestureDetector(
      onTap: () => setState(() => selectedLang = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(sub, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            if (isSelected) const Icon(Icons.check, color: Color(0xFF00B4D8)),
          ],
        ),
      ),
    );
  }
}
