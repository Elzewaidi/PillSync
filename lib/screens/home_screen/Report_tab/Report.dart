import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  static const String routeName = 'reports_screen';

  final bool isTab;
  ReportsScreen({this.isTab = true});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  final int _missedDoses = 2;
  final int _takenDoses  = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        title: const Text(
          "Reports",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Adherence Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildAdherenceChartCard(),
            const SizedBox(height: 25),
            const Text("Today's Insights",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildInsightCard("Missed Doses", "$_missedDoses", Colors.redAccent),
                const SizedBox(width: 15),
                _buildInsightCard("Taken Doses", "$_takenDoses", Colors.teal),
              ],
            ),
            const SizedBox(height: 25),
            _buildAIInsightBox(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildAdherenceChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Medication Adherence",
              style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
          const SizedBox(height: 5),
          const Row(
            children: [
              Text("93%", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text("+5%", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ],
          ),
          const Text("Last 30 Days", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 30),
          SizedBox(height: 200, child: LineChart(_mainData())),
        ],
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 1: return const Text('W1', style: TextStyle(fontSize: 10));
                case 3: return const Text('W2', style: TextStyle(fontSize: 10));
                case 5: return const Text('W3', style: TextStyle(fontSize: 10));
                case 7: return const Text('W4', style: TextStyle(fontSize: 10));
              }
              return const Text('');
            },
          ),
        ),
        leftTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1), FlSpot(1, 3.5), FlSpot(2, 2.8), FlSpot(3, 4.2),
            FlSpot(4, 3.5), FlSpot(5, 4.8), FlSpot(6, 3.2), FlSpot(7, 4.5),
          ],
          isCurved: true,
          color: const Color(0xFF00B4D8),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF00B4D8).withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.blueGrey, fontSize: 13)),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsightBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00B4D8).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF00B4D8), size: 30),
          const SizedBox(height: 10),
          Text(
            "You've shown great consistency this month! Keep up the good work. "
            "Consider setting reminders for your medication times to further improve adherence.",
            style: TextStyle(color: Colors.blueGrey[700], height: 1.5, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
