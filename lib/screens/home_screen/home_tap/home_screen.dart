import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/model/medication_model.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Meds.dart';
import 'package:pillsync/screens/home_screen/home_tap/My_schedule/My_schedule.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';

import '../../../features/auth/domain/entities/user.dart';
import '../../../l10n/app_localizations.dart';
import '../Add_Meds_tab/Add_Meds.dart';
import '../Report_tab/Report.dart';
import '../settings_tab/settings_screen.dart';
import 'Location_pharmacy/Location_pharmacy.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';
  final User? user;

  const HomeScreen({Key? key, this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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
    // We define pages dynamically to ensure they have access to latest state/context if needed
    final List<Widget> pages = [
      _buildHomeBody(),
      const MedsTabContent(),
      Container(), // Placeholder for "Add" since it's a modal/push
      ReportsScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicationScreen()),
          );
        },
        backgroundColor: AppColors.skyBlue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 35, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppColors.white,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  AppAssets.home_tab,
                  AppLocalizations.of(context)!.home,
                  0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  AppAssets.Meds_tab,
                  AppLocalizations.of(context)!.meds,
                  1,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  null,
                  AppLocalizations.of(context)!.add,
                  2,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  AppAssets.report_tab,
                  AppLocalizations.of(context)!.reports,
                  3,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  AppAssets.settings_tab,
                  AppLocalizations.of(context)!.settings,
                  4,
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
    );
  }

  Widget _buildNavItem(dynamic icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    Color activeColor = AppColors.blue500;
    Color inactiveColor = AppColors.grey;

    return InkWell(
      onTap: () {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicationScreen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon == null)
              const SizedBox(height: 24)
            else
              if (icon is String)
                Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                  color: isSelected ? activeColor : inactiveColor,
                )
              else
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeBody() {
    return BlocConsumer<MedicationCubit, MedicationState>(
      listener: (context, state) {
        if (state is MedicationActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is MedicationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Medication> medications = [];
        if (state is MedicationLoaded) {
          medications = state.medications;
        }

        final cubit = context.watch<MedicationCubit>();
        final nextMed = cubit.nextUpcomingMedication;

        final totalMeds = medications.length;
        final takenMeds = medications.where((m) => m.isTaken).length;
        final adherence = totalMeds > 0 ? takenMeds / totalMeds : 0.0;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 25),
                _buildNextMedicineCard(nextMed),
                const SizedBox(height: 20),
                _buildHealthTip(),
                const SizedBox(height: 25),
                _buildAdherenceTracker(adherence),
                const SizedBox(height: 25),
                _buildQuickActionsGrid(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(AppAssets.zewaidi),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.goodMorning,
                  style: TextStyle(color: AppColors.grey, fontSize: 14),
                ),
                Text(
                  "${widget.user?.fullName ?? "Zewaidi!"}!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_outlined, size: 28),
        ),
      ],
    );
  }

  Widget _buildNextMedicineCard(Medication? med) {
    if (med == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            "All done for today! 🌟",
            style: TextStyle(color: AppColors.blue500, fontSize: 16),
          ),
        ),
      );
    }

    final countdownText = context.watch<MedicationCubit>().getCountdownText(
      med.timeTotake,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blue500,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.nextMedicine,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                med.medicineName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                med.dosage,
                style: const TextStyle(color: AppColors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context)!.todayAt} ${med.time}",
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            countdownText,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.blue100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.blue500Alt,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.healthTipTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.healthTipContent,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdherenceTracker(double adherence) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.overallAdherence,
            style: TextStyle(color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 85.0,
            lineWidth: 12.0,
            percent: adherence,
            center: Text(
              "${(adherence * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.blue500,
              ),
            ),
            progressColor: AppColors.blue500,
            backgroundColor: AppColors.slateSurface,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1500,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _actionCard(
          AppLocalizations.of(context)!.addMedication,
          AppAssets.add_icon,
          AppColors.blue500,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMedicationScreen()),
            );
          },
        ),
        _actionCard(
          AppLocalizations.of(context)!.mySchedule,
          AppAssets.scedule_icon,
          AppColors.blue500,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientScheduleScreen()),
            );
          },
        ),
        _actionCard(
          AppLocalizations.of(context)!.viewReports,
          AppAssets.report_icon,
          AppColors.blue500,
              () {
            setState(() => _selectedIndex = 3);
          },
        ),
        _actionCard(
          AppLocalizations.of(context)!.findPharmacy,
          AppAssets.location_icon,
          AppColors.blue500,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NearbyPharmaciesScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _actionCard(String title,
      dynamic icon,
      Color color,
      VoidCallback onTap,) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: icon is String
                  ? Image.asset(icon, width: 32, height: 32)
                  : Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showMissedMedicationSheet(BuildContext context) {
    // This sheet logic should ideally also be driven by state, but for now we keep it simple
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.whiteRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.darkRed,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.missedMedicationTitle,
                        style: const TextStyle(
                          color: AppColors.darkRed,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.missedMedicationSubtitle,
                        style: TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _buildMissedItem("Panadol", "9:00 AM"), // Still hardcoded
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.whiteGray_2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.takeLater,
                  style: TextStyle(
                    color: AppColors.darkBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissedItem(String name, String time) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.whiteRed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.darkRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkRed,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context)!.markAsTaken,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}