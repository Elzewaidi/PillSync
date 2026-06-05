import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/report/report_cubit.dart';
import 'package:pillsync/utils/di.dart';
import 'package:pillsync/screens/home_screen/Report_tab/widgets/reports_view.dart';

class ReportsScreen extends StatelessWidget {
  static const String routeName = '/reports';
  final bool isTab;

  const ReportsScreen({super.key, this.isTab = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReportCubit>()..fetchReports(),
      child: ReportsView(isTab: isTab),
    );
  }
}
