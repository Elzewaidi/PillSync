import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/model/medication_model.dart';
// import 'package:horizontal_calendar/horizontal_calendar.dart';

class PatientScheduleScreen extends StatefulWidget {
  static const String routeName = 'patient_schedule';

  @override
  State<PatientScheduleScreen> createState() => _PatientScheduleScreenState();
}

class _PatientScheduleScreenState extends State<PatientScheduleScreen> {
  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Today's medication schedule",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<MedicationCubit, MedicationState>(
        builder: (context, state) {
          if (state is MedicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Medication> medications = [];
          if (state is MedicationLoaded) {
            medications = state.medications;
          }

          final groupedMeds = _groupMedsByTime(medications);
          final completedCount = medications.where((m) => m.isTaken).length;
          final totalCount = medications.length;
          final upcomingCount = totalCount - completedCount;

          return Column(
            children: [
              _buildTopDateCard(),
              _buildStatusRow(completedCount, totalCount, upcomingCount),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: groupedMeds.length,
                  itemBuilder: (context, index) {
                    final time = groupedMeds.keys.elementAt(index);
                    final meds = groupedMeds[time]!;
                    return _buildTimeSection(time, meds);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<Medication>> _groupMedsByTime(List<Medication> meds) {
    final Map<String, List<Medication>> groups = {};
    for (var med in meds) {
      if (!groups.containsKey(med.time)) {
        groups[med.time] = [];
      }
      groups[med.time]!.add(med);
    }
    // Sort by time could be added here if needed, assuming simple string sort for now or implicit order
    return groups;
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
              Text(
                "Today",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                "Wednesday, Nov 19",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                Text(
                  "19",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Nov",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
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
          _statusItem(
            Icons.check_circle_outline,
            "Completed",
            "$completed/$total",
            Colors.green,
          ),
          const SizedBox(width: 15),
          _statusItem(
            Icons.access_time,
            "Upcoming",
            "$upcoming",
            Colors.orange,
          ),
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
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(String time, List<Medication> meds) {
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
              child: const Icon(
                Icons.access_time,
                color: Color(0xFF00B4D8),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                // Period logic removed for simplicity or can be derived from time
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...meds.map((med) => _buildMedCard(med)).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMedCard(Medication med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
                Text(
                  med.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "10mg",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                // Hardcoded for now
              ],
            ),
          ),
          InkWell(
            onTap: () {
              context.read<MedicationCubit>().toggleMedication(med);
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
