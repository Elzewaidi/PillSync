import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/cubit/locale/locale_cubit.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';

class LanguageScreen extends StatefulWidget {
  static const String routeName = '/language';

  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final activeLocale = context.watch<LocaleCubit>().state;
    final selectedLang = activeLocale.languageCode == 'ar' ? "Arabic" : "English";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text("Language / اللغة", style: AppStyles.font18SemiBoldBlack),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your preferred language / اختر لغتك المفضلة",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _buildLangTile(context, "English", "English", selectedLang == "English"),
            _buildLangTile(context, "Arabic", "العربية", selectedLang == "Arabic"),
          ],
        ),
      ),
    );
  }

  Widget _buildLangTile(BuildContext context, String title, String sub, bool isSelected) {
    return GestureDetector(
      onTap: () {
        final code = title == "Arabic" ? "ar" : "en";
        context.read<LocaleCubit>().changeLanguage(code);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 2,
          ),
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
                Text(sub, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
