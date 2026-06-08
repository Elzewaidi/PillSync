import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pillsync/api/report_remote_data_source.dart';
import 'package:pillsync/error/failures.dart';
import 'package:pillsync/model/report_model.dart';
import 'package:pillsync/network/network_info.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ReportModel>>> getMedicineReports();
}

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ReportModel>>> getMedicineReports() async {
    final connected = await networkInfo.isConnected;
    debugPrint("📊 ReportRepo: isConnected = $connected");
    
    if (connected) {
      try {
        final reports = await remoteDataSource.getMedicineReports();
        debugPrint("📊 ReportRepo: Got ${reports.length} reports from data source");
        return Right(reports);
      } catch (e) {
        debugPrint("📊 ReportRepo: CATCH → $e");
        return Left(ServerFailure(e.toString()));
      }
    } else {
      debugPrint("📊 ReportRepo: No internet connection");
      return Left(NetworkFailure("No Internet Connection"));
    }
  }
}

