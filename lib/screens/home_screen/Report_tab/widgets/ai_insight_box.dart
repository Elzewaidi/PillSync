import 'package:flutter/material.dart';
import 'package:pillsync/utils/app_colors.dart';

class AIInsightBox extends StatelessWidget {
  final double adherencePercentage;
  final String medicineName;

  const AIInsightBox({
    super.key,
    required this.adherencePercentage,
    required this.medicineName,
  });

  @override
  Widget build(BuildContext context) {
    String insightText;
    if (adherencePercentage >= 80) {
      insightText = "Great job! Your adherence for ${medicineName == 'جميع الأدوية' ? 'all medications' : medicineName} is excellent at ${adherencePercentage.toInt()}%. Keep up the good work and stay healthy!";
    } else if (adherencePercentage >= 50) {
      insightText = "You're doing okay with ${medicineName == 'جميع الأدوية' ? 'all medications' : medicineName} (${adherencePercentage.toInt()}%), but there's room for improvement. Try setting more reminders to stay on track.";
    } else {
      insightText = "Your adherence for ${medicineName == 'جميع الأدوية' ? 'all medications' : medicineName} is quite low (${adherencePercentage.toInt()}%). It's very important to take your medications as prescribed. Please consult your doctor if you're having trouble.";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insightText,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
