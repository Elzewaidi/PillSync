import 'package:flutter/material.dart';
import 'package:pillsync/model/medication_model.dart';

class MedicationRepository {
  Future<List<Medication>> getMedications() async {
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const Medication(
        name: "Vitamin D",
        time: "9:00 PM",
        isTaken: false,
        icon: Icons.access_time,
        color: Colors.blueAccent,
      ),
      const Medication(
        name: "Vitamin D",
        time: "9:00 PM",
        isTaken: false,
        icon: Icons.access_time,
        color: Colors.blueAccent,
      ),
      const Medication(
        name: "Aspirin",
        time: "12:00 PM",
        isTaken: false,
        icon: Icons.hourglass_empty,
        color: Colors.cyan,
      ),
      const Medication(
        name: "Metformin",
        time: "08:00 AM",
        isTaken: true,
        icon: Icons.medication,
        color: Colors.purpleAccent,
      ),
      const Medication(
        name: "Metformin",
        time: "08:00 AM",
        isTaken: true,
        icon: Icons.medication,
        color: Colors.purpleAccent,
      ),
    ];
  }
}
