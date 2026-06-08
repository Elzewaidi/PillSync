import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_cubit.dart';
import 'package:pillsync/utils/app_colors.dart';

class PharmacySearchField extends StatelessWidget {
  const PharmacySearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => context.read<PharmacyCubit>().searchPharmacies(value),
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: "ابحث عن صيدلية...",
          hintStyle: TextStyle(color: AppColors.textHint),
          prefixIcon: Icon(Icons.search, color: AppColors.textHint),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
