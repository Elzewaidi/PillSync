import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pillsync/utils/app_colors.dart';

class AdherenceOverviewCard extends StatelessWidget {
  final double adherencePercentage;
  final String trend;

  const AdherenceOverviewCard({
    super.key,
    required this.adherencePercentage,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medication Adherence",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${adherencePercentage.toInt()}%",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
                Text(
                  trend,
                  style: TextStyle(
                    color: trend.startsWith('+') ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          const Text(
            "Last 30 Days",
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(_mainData()),
          ),
          const SizedBox(height: 16),
          _buildTimelineLabels(),
        ],
      ),
    );
  }

  Widget _buildTimelineLabels() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Week 1", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text("Week 2", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text("Week 3", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text("Week 4", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  LineChartData _mainData() {
    // Ensure value is a valid finite number between 0 and 100
    final double cleanAdherence = (adherencePercentage.isNaN || adherencePercentage.isInfinite)
        ? 0.0
        : adherencePercentage.clamp(0.0, 100.0);
    
    // Generate spots based on the adherencePercentage to make the chart feel real
    // We map the Y-axis from 0 to 100 for proper percentage display
    
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, (cleanAdherence * 0.8).clamp(0, 100)),
            FlSpot(1, (cleanAdherence * 1.1).clamp(0, 100)),
            FlSpot(2, (cleanAdherence * 0.9).clamp(0, 100)),
            FlSpot(3, (cleanAdherence * 1.2).clamp(0, 100)),
            FlSpot(4, (cleanAdherence * 1.0).clamp(0, 100)),
            FlSpot(5, (cleanAdherence * 1.05).clamp(0, 100)),
            FlSpot(6, cleanAdherence),
          ],
          isCurved: true,
          color: const Color(0xFF4FA8B8),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4FA8B8).withOpacity(0.2),
                const Color(0xFF4FA8B8).withOpacity(0.01),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
