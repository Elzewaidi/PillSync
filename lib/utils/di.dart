import 'package:pillsync/api/report_remote_data_source.dart';
import 'package:pillsync/api/report_repository.dart';
import 'package:pillsync/cubit/report/report_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pillsync/api/core/api_manager.dart';
import 'package:pillsync/api/pharmacy_repository.dart';
import 'package:pillsync/api/pharmacy_remote_data_source.dart';
import 'package:pillsync/services/location_service.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_cubit.dart';
import 'package:pillsync/network/network_info.dart';

final getIt = GetIt.instance;

void setupDI() {
  // External
  getIt.registerLazySingleton(() => Connectivity());

  // Core Network Infrastructure 
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  getIt.registerLazySingleton<ApiManager>(() => ApiManager());

  // Services
  getIt.registerLazySingleton<LocationService>(() => LocationServiceImpl());

  // Data Sources
  getIt.registerLazySingleton<PharmacyRemoteDataSource>(
    () => PharmacyRemoteDataSourceImpl(apiManager: getIt()),
  );
  getIt.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(apiManager: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<PharmacyRepository>(
    () => PharmacyRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Cubits / ViewModels
  getIt.registerFactory(() => PharmacyCubit(
    pharmacyRepository: getIt(),
    locationService: getIt(),
  ));
  getIt.registerFactory(() => ReportCubit(
    reportRepository: getIt(),
  ));
}
