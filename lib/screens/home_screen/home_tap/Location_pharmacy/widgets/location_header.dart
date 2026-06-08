import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_cubit.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_state.dart';
import 'package:pillsync/utils/app_colors.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      builder: (context, state) {
        String displayLocation = "يتم تحديد موقعك...";
        if (state is PharmacyLoaded) {
          displayLocation = state.currentLocationName;
        } else if (state is PharmacyError) {
          displayLocation = context.read<PharmacyCubit>().currentLocationName;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 50, bottom: 25, left: 10, right: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 22),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "موقعك الحالي",
                      style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayLocation,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.near_me, color: AppColors.white, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
