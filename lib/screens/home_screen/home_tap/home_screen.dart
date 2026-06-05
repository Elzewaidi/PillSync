import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/cubit/medication/medication_state.dart';
import 'package:pillsync/model/medication_model.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Meds.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/Add_Meds.dart';
import 'package:pillsync/screens/home_screen/Report_tab/Report.dart';
import 'package:pillsync/screens/home_screen/settings_tab/settings_screen.dart';
import 'package:pillsync/screens/home_screen/home_tap/My_schedule/My_schedule.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/Location_pharmacy.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Missed medication sheet logic can be triggered here based on state if needed
    // For now, we removed the hardcoded delay
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
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AddMedicationScreen.routeName),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 35, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppColors.surface,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(AppAssets.home_tab, "Home", 0),
              _buildNavItem(AppAssets.Meds_tab, "Meds", 1),
              _buildNavItem(null, "Add", 2),
              _buildNavItem(AppAssets.report_tab, "Reports", 3),
              _buildNavItem(AppAssets.settings_tab, "Settings", 4),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
    );
  }

  Widget _buildNavItem(dynamic icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    Color activeColor = AppColors.primary;
    Color inactiveColor = AppColors.textHint;

    return InkWell(
      onTap: () {
        if (index == 2) {
          context.push(AddMedicationScreen.routeName);
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon == null)
            const SizedBox(height: 24)
          else if (icon is String)
            Image.asset(
              icon,
              width: 24,
              height: 24,
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
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return BlocBuilder<MedicationCubit, MedicationState>(
      builder: (context, state) {
        if (state is MedicationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Medication> medications = [];
        if (state is MedicationLoaded) {
          medications = state.medications;
        }

        // Calculate derived data
        final nextMed = medications.firstWhere(
          (m) => !m.isTaken,
          orElse: () => medications.isNotEmpty
              ? medications.first
              : const Medication(
                  name: "No Meds",
                  time: "--",
                  icon: Icons.check,
                  color: AppColors.textHint,
                ),
        );

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
                const Text(
                  "Good morning,",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                Text(
                  "Zewaidi!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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

  Widget _buildNextMedicineCard(Medication med) {
    if (med.name == "No Meds") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            "All caught up! No medications pending.",
            style: TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Medicine",
            // ignore: deprecated_member_use
            style: TextStyle(color: AppColors.white, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                med.name,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "10mg",
                style: TextStyle(color: AppColors.white, fontSize: 16),
              ),
              // Hardcoded dosage for now
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                "Today at ${med.time}",
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Tip of the Day",
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stay hydrated! Drinking water can help with medication absorption.",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            "Overall Adherence",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
                color: AppColors.primary,
              ),
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.grey100,
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
          "Add\nMedication",
          AppAssets.add_icon,
          AppColors.primary,
          () => context.push(AddMedicationScreen.routeName),
        ),
        _actionCard(
          "My\nSchedule",
          AppAssets.scedule_icon,
          AppColors.primary,
          () => context.push(PatientScheduleScreen.routeName),
        ),
        _actionCard(
          "View\nReports",
          AppAssets.report_icon,
          AppColors.primary,
          () {
            setState(() => _selectedIndex = 3);
          },
        ),
        _actionCard(
          "Find\nPharmacy",
          AppAssets.location_icon,
          AppColors.primary,
          () => context.push(NearbyPharmaciesScreen.routeName),
        ),
      ],
    );
  }

  Widget _actionCard(
    String title,
    dynamic icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
          color: Colors.white,
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Missed Medication",
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "You haven't taken these medications today",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: AppColors.textHint,
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
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "I'll Take It Later",
                  style: TextStyle(
                    color: AppColors.textPrimary,
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
        color: AppColors.error.withOpacity(0.05),
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
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Mark as Taken",
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
