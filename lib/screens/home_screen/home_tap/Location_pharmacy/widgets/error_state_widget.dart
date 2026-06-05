import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_cubit.dart';
import 'package:pillsync/utils/app_colors.dart';

class PharmacyErrorState extends StatelessWidget {
  final String message;

  const PharmacyErrorState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<PharmacyCubit>().fetchNearbyPharmacies(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("إعادة المحاولة", style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
