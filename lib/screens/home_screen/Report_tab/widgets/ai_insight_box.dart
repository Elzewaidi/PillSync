import 'package:flutter/material.dart';
import 'package:pillsync/utils/app_colors.dart';

class AIInsightBox extends StatelessWidget {
  const AIInsightBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        "You've shown great consistency this month! Keep up the good work. Consider setting reminders for your medication times to further improve adherence.",
        style: TextStyle(
          color: AppColors.grey600,
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }
}
