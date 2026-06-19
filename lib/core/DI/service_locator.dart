import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/admin/cubit/alert/alert_cubit.dart';
import 'package:gym_management_app/features/admin/cubit/member/member_cubit.dart';
import 'package:gym_management_app/features/admin/data/Alert_repo.dart';
import 'package:gym_management_app/features/admin/data/members_repo.dart';
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

  //* admin
  // Alert
  getIt.registerLazySingleton<AlertRepo>(
    () => AlertRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<AlertCubit>(() => AlertCubit(getIt<AlertRepo>()));

  // member
  getIt.registerLazySingleton<MemberRepo>(
    () => MemberRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<MemberCubit>(() => MemberCubit(getIt<MemberRepo>()));
}
