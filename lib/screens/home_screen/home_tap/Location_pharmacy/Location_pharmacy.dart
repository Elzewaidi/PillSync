import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_cubit.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_state.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/di.dart';
import 'package:pillsync/utils/app_styles.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/widgets/location_header.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/widgets/pharmacy_card.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/widgets/error_state_widget.dart';
import 'package:pillsync/screens/home_screen/home_tap/Location_pharmacy/widgets/pharmacy_search_field.dart';

class NearbyPharmaciesScreen extends StatelessWidget {
  static const String routeName = '/nearby_pharmacies';

  const NearbyPharmaciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PharmacyCubit>()..fetchNearbyPharmacies(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const LocationHeader(),
            Expanded(
              child: BlocBuilder<PharmacyCubit, PharmacyState>(
                builder: (context, state) {
                  if (state is PharmacyInitial || state is PharmacyLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  } else if (state is PharmacyError) {
                    return PharmacyErrorState(message: state.message);
                  } else if (state is PharmacyLoaded) {
                    final pharmacies = state.pharmacies;
                    
                    // High Performance Lazy Rebuilding ListView
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      itemCount: pharmacies.length + 2, // Account for Search field + Title
                      itemBuilder: (context, index) {
                        if (index == 0) return const PharmacySearchField();
                        if (index == 1) return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "أقرب الصيدليات",
                            style: AppStyles.font18SemiBoldBlack,
                          ),
                        );
                        // Shift index back to map correctly to Data array
                        final pharmacy = pharmacies[index - 2];
                        return PharmacyCard(data: pharmacy);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
