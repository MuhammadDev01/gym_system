import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/service/network/fcm_service.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_cubit.dart';
import 'package:gym_management_app/features/alerts/cubit/alert_user_cubit.dart';
import 'package:gym_management_app/features/alerts/data/alert_repo.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/data/market_repo.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

final GetIt getIt = GetIt.instance;

void serviceLocatorSetup() {
  //* Network
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  getIt.registerLazySingleton<FcmService>(
    () => FcmService(getIt<FirebaseService>()),
  );

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
  getIt.registerFactory<AlertUserCubit>(
    () => AlertUserCubit(getIt<AlertRepo>()),
  );
  getIt.registerFactory<AlertAdminCubit>(
    () => AlertAdminCubit(getIt<AlertRepo>()),
  );

  // member
  getIt.registerLazySingleton<MemberRepo>(
    () => MemberRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<MemberCubit>(() => MemberCubit(getIt<MemberRepo>()));

  //* market
  getIt.registerLazySingleton<MarketRepo>(
    () => MarketRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<MarketAdminCubit>(
    () => MarketAdminCubit(getIt<MarketRepo>()),
  );
}
