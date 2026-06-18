import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/admin/cubit/admin_cubit.dart';
import 'package:gym_management_app/features/admin/data/admin_repo.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

final GetIt getIt = GetIt.instance;

void serviceLocatorSetup() {
  //* Network
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());

  //* Auth
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));

  //* Admin
  getIt.registerLazySingleton<AdminRepo>(
    () => AdminRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<AdminCubit>(() => AdminCubit(getIt<AdminRepo>()));
}
