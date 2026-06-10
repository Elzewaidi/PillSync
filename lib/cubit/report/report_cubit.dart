import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/api/report_repository.dart';
import 'package:pillsync/error/failures.dart';
import 'package:pillsync/cubit/report/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository reportRepository;

  ReportCubit({required this.reportRepository}) : super(ReportInitial());

  Future<void> fetchReports() async {
    debugPrint("📊 ReportCubit: Starting fetchReports...");
    emit(ReportLoading());
    try {
      final result = await reportRepository.getMedicineReports();
      result.fold(
        (failure) {
          debugPrint("📊 ReportCubit: FAILURE → ${failure.runtimeType}: ${failure.message}");
          emit(ReportError(_mapFailureToMessage(failure)));
        },
        (reports) {
          debugPrint("📊 ReportCubit: SUCCESS → ${reports.length} reports loaded");
          emit(ReportLoaded(reports));
        },
      );
    } catch (e, stackTrace) {
      debugPrint("📊 ReportCubit: EXCEPTION → $e");
      debugPrint("📊 StackTrace: $stackTrace");
      emit(ReportError("Unexpected error: $e"));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return "No Internet Connection";
    }
    return "Unexpected Error";
  }
}

