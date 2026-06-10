import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Medications_Detialed/Medications_Detialed.dart';
import 'package:pillsync/model/medication_model.dart';

import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';

class MedsTabContent extends StatelessWidget {
  static const String routeName = '/meds';

  const MedsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationCubit, MedicationState>(
      builder: (context, state) {
        List<Medication> todaySchedule = [];
        if (state is MedicationLoaded) {
          todaySchedule = state.medications;
        }

        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      "My Medications",
                      style: AppStyles.font20BoldBlack,
                    ),
                    IconButton(
                      onPressed: () => _simulateNotification(context),
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state is MedicationLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is MedicationError
                    ? Center(child: Text((state).message))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildNextDoseCard(context),
                            const SizedBox(height: 25),
                            Text(
                              "Today's Schedule",
                              style: AppStyles.font18SemiBoldBlack,
                            ),
                            const SizedBox(height: 15),
                            if (todaySchedule.isEmpty)
                              Center(
                                child: Text("No medications for today", style: AppStyles.font14MediumGrey),
                              ),
                            ...todaySchedule
                                .map(
                                  (med) => _buildMedicationItem(context, med),
                                )
                                .toList(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNextDoseCard(BuildContext context) {
    final cubit = context.watch<MedicationCubit>();
    final nextMed = cubit.nextUpcomingMedication;

    if (nextMed == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All set!",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "No upcoming doses for today. Keep up the good work!",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              backgroundColor: AppColors.success,
              child: Icon(Icons.done_all, color: Colors.white),
            ),
          ],
        ),
      );
    }

    final countdownText = cubit.getCountdownText(nextMed.timeTotake);

    return InkWell(
      onTap: () {
        context.push(
          MedicationDetailsScreen.routeName,
          extra: {
            "name": nextMed.name,
            "dosage": nextMed.dosage.isNotEmpty ? nextMed.dosage : "10mg",
            "frequency": nextMed.frequency.isNotEmpty ? nextMed.frequency : "Daily",
            "instructions": nextMed.instructions.isNotEmpty ? nextMed.instructions : "Take as directed.",
            "history": [],
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.info.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Next dose: ${nextMed.name}",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  countdownText,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicationCubit>().toggleMedication(nextMed);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Take Now",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        // Snooze/dismiss logic
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Snooze",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(nextMed.icon, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(BuildContext context, Medication med) {
    return InkWell(
      onTap: () {
        context.push(
          MedicationDetailsScreen.routeName,
          extra: {
            "name": med.name,
            "dosage": med.dosage.isNotEmpty ? med.dosage : "10mg",
            "frequency": med.frequency.isNotEmpty ? med.frequency : "Once daily",
            "instructions": med.instructions.isNotEmpty ? med.instructions : "Take with water.",
            "history": [
              {"status": "Taken", "period": "Morning", "time": "08:05 AM"},
            ],
          },
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
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
                color: med.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(med.icon, color: med.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    med.time,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            med.isTaken
                ? const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "Taken",
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : TextButton(
                    onPressed: () {
                      context.read<MedicationCubit>().toggleMedication(med);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Mark as Taken",
                        style: TextStyle(color: Colors.cyan, fontSize: 12),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _simulateNotification(BuildContext context) {
    final cubit = context.read<MedicationCubit>();
    if (cubit.state is MedicationLoaded) {
      final meds = (cubit.state as MedicationLoaded).medications;
      final upcoming = meds.where((m) => !m.isTaken).toList();
      if (upcoming.isNotEmpty) {
        cubit.triggerNotification(upcoming.first);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No remaining doses to simulate right now.",
              style: TextStyle(fontSize: 14),
            ),
            backgroundColor: AppColors.info,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
