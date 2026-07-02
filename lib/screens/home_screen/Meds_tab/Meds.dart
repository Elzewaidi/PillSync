import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Medications_Detialed/Medications_Detialed.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';

import '../../../l10n/app_localizations.dart';
import '../../../model/medication_model.dart';

class MedsTabContent extends StatefulWidget {
  static const String routeName = 'meds_tab_content';

  const MedsTabContent({super.key});

  @override
  State<MedsTabContent> createState() => _MedsTabContentState();
}

class _MedsTabContentState extends State<MedsTabContent> {
  Timer? _nextDoseTimer;

  @override
  void initState() {
    super.initState();
    _nextDoseTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nextDoseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicationCubit, MedicationState>(
      listener: (context, state) {
        if (state is MedicationActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        List<Medication> todaySchedule = [];
        if (state is MedicationLoaded) {
          todaySchedule = state.medications;
        }
        final cubit = context.watch<MedicationCubit>();
        final nextMed = cubit.nextUpcomingMedication;

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
                      AppLocalizations.of(context)!.mymedications,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Alert logic
                      },
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 28,
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
                            _buildNextDoseCard(context, nextMed),
                            const SizedBox(height: 25),
                            Text(
                              AppLocalizations.of(context)!.todaySchedule,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (todaySchedule.isEmpty)
                              Center(
                                child: Text("No medications for today"),
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

  Widget _buildNextDoseCard(BuildContext context, Medication? nextMed) {
    if (nextMed == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            "All done for today! 🌟",
            style: TextStyle(
              color: AppColors.cyanPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final countdownText = context.watch<MedicationCubit>().getCountdownText(
      nextMed.timeTotake,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MedicationDetailsScreen(medId: nextMed.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cyanSurface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.nextDose,
                  style: TextStyle(color: AppColors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  nextMed.medicineName,
                  style: TextStyle(
                    color: AppColors.cyanPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  countdownText,
                  style: const TextStyle(
                    color: AppColors.cyanPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicationCubit>().markMedicationTakenById(
                          nextMed.id,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cyanPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.takeNow,
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reminder snoozed for 10 minutes.'),
                            backgroundColor: AppColors.blue,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.cyanPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.snooze,
                        style: TextStyle(color: AppColors.cyanPrimary),
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
                backgroundColor: AppColors.cyanPrimary,
                child: Image.asset(AppAssets.Meds_2),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationDetailsScreen(medId: med.name),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
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
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    med.time,
                    style: const TextStyle(color: AppColors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            med.isTaken
                ? Row(
                    children: [
                      Icon(
                          Icons.check_circle, color: AppColors.green, size: 20),
                      SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.taken,
                        style: TextStyle(
                          color: AppColors.green,
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
                        color: AppColors.cyanPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.markAsTaken,
                        style: TextStyle(
                            color: AppColors.cyanPrimary, fontSize: 12),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
