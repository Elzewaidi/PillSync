import 'package:dartz/dartz.dart';
import 'package:pillsync/model/pharmacy_model.dart';
import 'package:pillsync/utils/osm_parser.dart';
import 'package:pillsync/error/failures.dart';
import 'package:pillsync/api/pharmacy_remote_data_source.dart';
import 'package:pillsync/network/network_info.dart';

abstract class PharmacyRepository {
  Future<Either<Failure, List<PharmacyModel>>> getNearbyPharmacies(double latitude, double longitude);
}

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PharmacyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PharmacyModel>>> getNearbyPharmacies(double latitude, double longitude) async {
    // True production standard: Explicitly check for network health before burning resources.
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت. يرجى تفعيل الشبكة.'));
    }

    try {
      final response = await remoteDataSource.fetchNearbyPharmacies(latitude, longitude);
      
      final elements = response['elements'] as List<dynamic>? ?? [];
      
      if (elements.isEmpty) {
        return const Right([]);
      }

      final parsedPharmacies = OsmParser.parseOsmResponse(elements, latitude, longitude);
      
      return Right(parsedPharmacies);
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('timeout') || 
          errorMsg.contains('network') || 
          errorMsg.contains('socket') || 
          errorMsg.contains('connection')) {
        return const Left(NetworkFailure('تأكد من اتصالك بالإنترنت ثم حاول مرة أخرى.'));
      }
      return const Left(ServerFailure('حدث خطأ أثناء الاتصال بالخادم الداخلي.'));
    }
  }
}

