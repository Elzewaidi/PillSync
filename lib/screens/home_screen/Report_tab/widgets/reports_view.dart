import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/cubit/report/report_cubit.dart';
import 'package:pillsync/cubit/report/report_state.dart';
import 'package:pillsync/screens/home_screen/home_tap/home_screen.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';
import 'package:pillsync/screens/home_screen/Report_tab/widgets/reports_body.dart';

class ReportsView extends StatelessWidget {
  final bool isTab;

  const ReportsView({super.key, required this.isTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(HomeScreen.routeName);
                  }
                },
              ),
        title: Text(
          "Reports",
          style: AppStyles.font20BoldBlack,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (state is ReportError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ReportCubit>().fetchReports(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is ReportLoaded) {
            return ReportsBody(reports: state.reports);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
