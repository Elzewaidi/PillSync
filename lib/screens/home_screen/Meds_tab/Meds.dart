import 'package:flutter/material.dart';


import 'package:pillsync/screens/home_screen/Meds_tab/Medications_Detialed/Medications_Detialed.dart';
import 'package:pillsync/utils/app_assets.dart';


class MedsTabContent extends StatelessWidget {
  static const String routeName = 'meds_tab_content';

  const MedsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "My Medications",
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
                child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildNextDoseCard(context),
                            const SizedBox(height: 25),
                            const Text(
                              "Today's Schedule",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            
                              const Center(
                                child: Text("No medications for today"),
                              ),
                          
                               
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
             ] ),
            
          );
       
      }
    
  }

  Widget _buildNextDoseCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MedicationDetailsScreen(medId: "next_dose_id"),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Next dose: Aspirin",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  "in 25 minutes",
                  style: TextStyle(
                    color: Color(0xFF00BCD4),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Take now API logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BCD4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Take Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        // Snooze logic
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00BCD4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Snooze",
                        style: TextStyle(color: Color(0xFF00BCD4)),
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
                backgroundColor: const Color(0xFF00BCD4),
                child: Image.asset(AppAssets.Meds_2),
              ),
            ),
          ],
        ),
      ),
    );
  }


