import 'package:flutter/material.dart';

class _MedItem {
  final String name;
  final String dosage;
  final String time;
  final Color color;
  bool isTaken;

  _MedItem({
    required this.name,
    required this.dosage,
    required this.time,
    required this.color,
    this.isTaken = false,
  });
}

class PatientScheduleScreen extends StatefulWidget {
  static const String routeName = 'patient_schedule';

  @override
  State<PatientScheduleScreen> createState() => _PatientScheduleScreenState();
}

class _PatientScheduleScreenState extends State<PatientScheduleScreen> {
  final List<_MedItem> _medications = [
    _MedItem(name: "Vitamin D",  dosage: "1000 IU", time: "08:00 AM", color: Colors.blueAccent),
    _MedItem(name: "Metformin",  dosage: "500mg",   time: "08:00 AM", color: Colors.purpleAccent, isTaken: true),
    _MedItem(name: "Aspirin",    dosage: "100mg",   time: "12:00 PM", color: Colors.cyan),
    _MedItem(name: "Metformin",  dosage: "500mg",   time: "08:00 PM", color: Colors.purpleAccent),
    _MedItem(name: "Vitamin D",  dosage: "1000 IU", time: "09:00 PM", color: Colors.blueAccent),
  ];

  Map<String, List<_MedItem>> _groupByTime() {
    final Map<String, List<_MedItem>> groups = {};
    for (final med in _medications) {
      groups.putIfAbsent(med.time, () => []).add(med);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final grouped    = _groupByTime();
    final completed  = _medications.where((m) => m.isTaken).length;
    final total      = _medications.length;
    final upcoming   = total - completed;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Schedule",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Today's medication schedule",
              style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTopDateCard(),
          _buildStatusRow(completed, total, upcoming),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final time = grouped.keys.elementAt(index);
                final meds = grouped[time]!;
                return _buildTimeSection(time, meds);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDateCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4D8), Color(0xFF48CAE4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today", style: TextStyle(color: Colors.white70, fontSize: 14)),
              SizedBox(height: 4),
              Text("Wednesday, Nov 19",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                Text("19", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Nov", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(int completed, int total, int upcoming) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          _statusItem(Icons.check_circle_outline, "Completed", "$completed/$total", Colors.green),
          const SizedBox(width: 15),
          _statusItem(Icons.access_time, "Upcoming", "$upcoming", Colors.orange),
        ],
      ),
    );
  }

  Widget _statusItem(IconData icon, String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(count, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(String time, List<_MedItem> meds) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.access_time, color: Color(0xFF00B4D8), size: 20),
            ),
            const SizedBox(width: 12),
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 15),
        ...meds.map((med) => _buildMedCard(med)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMedCard(_MedItem med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: med.color, width: 4),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(med.dosage, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() => med.isTaken = !med.isTaken);
            },
            child: Icon(
              med.isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
              color: med.isTaken ? Colors.green : Colors.grey[300],
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
