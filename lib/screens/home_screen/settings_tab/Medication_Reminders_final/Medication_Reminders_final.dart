import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/model/medication_model.dart';
import 'package:pillsync/utils/app_assets.dart';
import '../../../../utils/app_colors.dart';

class MedicationRemindersScreen extends StatefulWidget {
  static const String routeName = 'medication_reminders_screen';

  @override
  State<MedicationRemindersScreen> createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Medication Reminders",
          style: TextStyle(
            color: AppColors.darkBlack,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<MedicationCubit, MedicationState>(
        builder: (context, state) {
          if (state is MedicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Medication> reminders = [];
          if (state is MedicationLoaded) {
            reminders = state.medications;
          }

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 100,
                ),
                itemCount: reminders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Active Reminders",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final reminder = reminders[index - 1];
                  return _buildReminderCard(reminder);
                },
              ),
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Add Medication or similar
                  },
                  icon: Image.asset(AppAssets.add_1_remind),
                  label: const Text(
                    "Add Reminder",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4D8),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: const Color(0xFF00B4D8).withOpacity(0.4),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReminderCard(Medication med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(AppAssets.med_reminders, width: 28, height: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${med.time} | Daily",
                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: med.isActive,
            onChanged: (newValue) {
              context.read<MedicationCubit>().toggleReminder(med);
            },
            activeColor: AppColors.whiteBlue,
          ),
        ],
      ),
    );
  }
}
