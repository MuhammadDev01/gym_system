import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/service/local/image_picker_service.dart';
import 'package:gym_management_app/core/service/local/qr_service.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

final GetIt getIt = GetIt.instance;

void serviceLocatorSetup() {
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<FirebaseService>()),
  );
  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<ImagePickerService>(),
      getIt<AuthRepo>(),
      getIt<QrService>(),
    ),
  );
  getIt.registerLazySingleton<QrService>(() => QrService());
}
