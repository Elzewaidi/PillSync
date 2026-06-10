import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/model/medication_model.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/Add_Meds.dart';

class MedicationRemindersScreen extends StatefulWidget {
  static const String routeName = '/medication-reminders';

  @override
  State<MedicationRemindersScreen> createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Medication Reminders",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Active Reminders",
                        style: TextStyle(
                          color: AppColors.primary,
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
                    context.push(AddMedicationScreen.routeName);
                  },
                  icon: Image.asset(AppAssets.add_1_remind),
                  label: const Text(
                    "Add Reminder",
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: AppColors.primary.withOpacity(0.4),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
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
              color: AppColors.info.withOpacity(0.1),
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
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${med.time} | Daily",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
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
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
