import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const String routeName = 'intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController controller = PageController();
  int index = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "icon": AppAssets.Meds_2,
      "title": "Track Your Medications",
      "desc":
          "Easily manage all your medications in one place. Never miss a dose again.",
    },
    {
      "icon": AppAssets.Ring,
      "title": "Smart Reminders",
      "desc":
          "Get timely notifications for your medication schedule and refills.",
    },
    {
      "icon": AppAssets.Anayls,
      "title": "Monitor Your Progress",
      "desc":
          "Track your adherence and view detailed reports of your medication history.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.darkGray, fontSize: 16),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => index = i),
                itemBuilder: (_, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: AppColors.primary.withOpacity(.1),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Image.asset(
                            pages[i]['icon'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        pages[i]['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          pages[i]['desc'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  width: index == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == i
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (index == pages.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    );
                  } else {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  index == pages.length - 1 ? "Get Started" : "Next",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
