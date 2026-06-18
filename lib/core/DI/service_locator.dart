import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/admin/cubit/admin_cubit.dart';
import 'package:gym_management_app/features/admin/data/admin_repo.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

final GetIt getIt = GetIt.instance;

void serviceLocatorSetup() {
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<FirebaseService>()),
  );
  getIt.registerLazySingleton<AdminRepo>(
    () => AdminRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );
  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(getIt<AdminRepo>()),
  );
}
