import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pillsync/features/auth/domain/entities/user.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:pillsync/features/auth/presentation/bloc/auth_state.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/Add_Meds.dart';
import 'package:pillsync/screens/home_screen/Meds_tab/Meds.dart';

import 'package:pillsync/screens/home_screen/Report_tab/Report.dart';
import 'package:pillsync/screens/home_screen/settings_tab/settings_screen.dart';
import 'package:pillsync/screens/home_screen/home_tap/My_schedule/My_schedule.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/Location_pharmacy.dart';

import 'package:pillsync/utils/app_assets.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeBody(),
      const MedsTabContent(),
      Container(), 
      ReportsScreen(),
      SettingsScreen(),
    ];


    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {}
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicationScreen()),
          );
        },
        backgroundColor: const Color(0xFF00B4D8),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(AppAssets.home_tab, "Home", 0),
              _buildNavItem(AppAssets.Meds_tab, "Meds", 1),
              _buildNavItem(AppAssets.report_tab, "Reports", 3),
              _buildNavItem(AppAssets.settings_tab, "Settings", 4),
            ],
          ),
        ),
      ),

        body: IndexedStack(index: _selectedIndex, children: pages),
      ),
    );
  }

  Widget _buildNavItem(dynamic icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    Color activeColor = const Color(0xFF3B82F6);
    Color inactiveColor = Colors.grey;

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            _buildHeader(),

            const SizedBox(height: 20),

           // _buildUserInfoCard(),

            const SizedBox(height: 25),

            _buildHealthTip(),

            const SizedBox(height: 25),

            _buildQuickActionsGrid(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, authState) {
      final user = authState is Authenticated ? authState.user : widget.user;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                    ? NetworkImage(user.imageUrl!)
                    : null,
                child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Good morning,",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    user.fullName,  
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        
        ],
      );
    },
  );
}
 /*  Widget _buildUserInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Email", widget.user.emailAddress),
          _buildInfoRow("Phone", widget.user.phoneNumber ?? "Not set"),
          _buildInfoRow("Birth Date", widget.user.birthDate ?? "Not set"),
          _buildInfoRow("Verified", widget.user.isVerified ? "Yes ✅" : "No ❌"),
        ],
      ),
    );
  }
 
   Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  } */

  Widget _buildHealthTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.lightbulb_outline),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Stay hydrated! Drinking water is important for your health.",
            ),
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
          const Color(0xFF3B82F6),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMedicationScreen()),
            );
          },
        ),
        _actionCard(
          "My\nSchedule",
          AppAssets.scedule_icon,
          const Color(0xFF3B82F6),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientScheduleScreen()),
            );
          },
        ),
        _actionCard(
          "View\nReports",
          AppAssets.report_icon,
          const Color(0xFF3B82F6),
          () {
            setState(() => _selectedIndex = 3);
          },
        ),
        _actionCard(
          "Find\nPharmacy",
          AppAssets.location_icon,
          const Color(0xFF3B82F6),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon is String
                ? Image.asset(icon, width: 32, height: 32)
                : Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
