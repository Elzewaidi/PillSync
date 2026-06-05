import 'package:flutter/material.dart';
import 'package:pillsync/model/report_model.dart';
import 'package:pillsync/screens/home_screen/Report_tab/widgets/adherence_overview_card.dart';
import 'package:pillsync/screens/home_screen/Report_tab/widgets/insight_card.dart';
import 'package:pillsync/screens/home_screen/Report_tab/widgets/ai_insight_box.dart';
import 'package:pillsync/utils/app_colors.dart';

import 'package:pillsync/utils/app_styles.dart';

class ReportsBody extends StatefulWidget {
  final List<ReportModel> reports;

  const ReportsBody({super.key, required this.reports});

  @override
  State<ReportsBody> createState() => _ReportsBodyState();
}

class _ReportsBodyState extends State<ReportsBody> {
  ReportModel? selectedReport; // Null represents "All Medications"

  @override
  void initState() {
    super.initState();
    selectedReport = null; // Default selection is All Medications
  }

  @override
  void didUpdateWidget(covariant ReportsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reports.isNotEmpty) {
      if (selectedReport != null && !widget.reports.contains(selectedReport)) {
        selectedReport = null;
      } else if (selectedReport != null) {
        selectedReport = widget.reports.firstWhere((r) => r == selectedReport);
      }
    } else {
      selectedReport = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reports.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    // Calculate totals for cumulative insights
    int totalTaken = widget.reports.fold(0, (sum, item) => sum + item.weeklyTakenCount);
    int totalMissed = widget.reports.fold(0, (sum, item) => sum + item.weeklyMissedCount);

    double displayAdherence;
    int displayMissed;
    int displayTaken;
    String displayName;

    if (selectedReport == null) {
      final int grandTotal = totalTaken + totalMissed;
      displayAdherence = grandTotal > 0 ? (totalTaken / grandTotal) * 100 : 0.0;
      displayMissed = totalMissed;
      displayTaken = totalTaken;
      displayName = "جميع الأدوية";
    } else {
      displayAdherence = selectedReport!.adherencePercentage;
      displayMissed = selectedReport!.weeklyMissedCount;
      displayTaken = selectedReport!.weeklyTakenCount;
      displayName = selectedReport!.medicineName;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Adherence Overview",
                style: AppStyles.font18SemiBoldBlack,
              ),
              _buildMedicineSelector(),
            ],
          ),
          const SizedBox(height: 16),
          AdherenceOverviewCard(
            adherencePercentage: displayAdherence,
            trend: "+5%",
          ),
          const SizedBox(height: 32),
          Text(
            "Weekly Insights: $displayName",
            style: AppStyles.font18SemiBoldBlack,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InsightCard(
                title: "Missed",
                value: "$displayMissed",
              ),
              const SizedBox(width: 16),
              InsightCard(
                title: "Taken",
                value: "$displayTaken",
              ),
            ],
          ),
          const SizedBox(height: 24),
          const AIInsightBox(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMedicineSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<ReportModel?>(
        value: selectedReport,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
        items: [
          const DropdownMenuItem<ReportModel?>(
            value: null,
            child: Text(
              "جميع الأدوية",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          ...widget.reports.map((ReportModel report) {
            return DropdownMenuItem<ReportModel?>(
              value: report,
              child: Text(
                report.medicineName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            );
          }),
        ],
        onChanged: (ReportModel? newValue) {
          setState(() {
            selectedReport = newValue;
          });
        },
      ),
    );
  }
}
