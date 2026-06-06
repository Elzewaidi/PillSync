import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:pillsync/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pillsync/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pillsync/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pillsync/features/auth/domain/repositories/auth_repository.dart';
import 'package:pillsync/features/auth/domain/usecases/check_auth_status.dart';
import 'package:pillsync/features/auth/domain/usecases/forget_password.dart';
import 'package:pillsync/features/auth/domain/usecases/login.dart';
import 'package:pillsync/features/auth/domain/usecases/logout.dart';
import 'package:pillsync/features/auth/domain/usecases/register.dart';
import 'package:pillsync/features/auth/domain/usecases/reset_password.dart';
import 'package:pillsync/features/auth/domain/usecases/send_otp.dart';
import 'package:pillsync/features/auth/domain/usecases/verify_otp.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/profile/data/datasources/imgbb_remote_data_source.dart';
import 'package:pillsync/features/profile/domain/usecases/upload_profile_image.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';

import 'features/profile/data/datasources/profile_local_data_source.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';

import 'features/profile/domain/repositories/profile_repository.dart';

import 'features/profile/domain/usecases/update_profile.dart';

import 'features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      accountName: 'flutter_auth_tokens',
    ),
  );
  sl.registerLazySingleton(() => secureStorage);

  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient);
  sl.registerLazySingleton(() => dioClient.dio);

  sl.registerLazySingleton(() => InternetConnection());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerSingletonAsync<AuthLocalDataSource>(() async {
    final dataSource = AuthLocalDataSourceImpl(sl());
    await dataSource.init();
    return dataSource;
  });

  await sl.allReady();

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
     profileLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => VerifyOTP(sl()));
  sl.registerLazySingleton(() => SendOTP(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => ForgetPassword(sl()));

  sl.registerLazySingleton(() => ResetPassword(sl()));

  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      register: sl(),
      verifyOTP: sl(),
      sendOTP: sl(),
      logout: sl(),
      checkAuthStatus: sl(),
      forgetPassword: sl(),
      resetPassword: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  sl.registerSingletonAsync<ProfileLocalDataSource>(() async {
    final dataSource = ProfileLocalDataSourceImpl();
    await dataSource.init();
    return dataSource;
  });

  await sl.allReady();

  sl.registerLazySingleton<ImgbbRemoteDataSource>(
    () => ImgbbRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      imgbbDataSource: sl(),
      networkInfo: sl(),
       authLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => UploadProfileImage(sl()));

  sl.registerFactory(
    () => ProfileBloc(updateProfile: sl(), uploadProfileImage: sl()),
  );
}
