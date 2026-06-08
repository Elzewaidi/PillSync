import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/utils/di.dart';
import 'package:pillsync/utils/app_routes.dart';

import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_event.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_state.dart';
import 'package:pillsync/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pillsync/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MedicationRepository>(
          create: (context) => MedicationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => di.sl<AuthBloc>()..add(const AppStarted()),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => di.sl<ProfileBloc>(),
          ),
          BlocProvider<MedicationCubit>(
            create: (context) => MedicationCubit(
              context.read<MedicationRepository>(),
            )..loadMedications(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'PillSync',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00B4D8),
              primary: const Color(0xFF00B4D8),
              secondary: const Color(0xFF48CAE4),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
