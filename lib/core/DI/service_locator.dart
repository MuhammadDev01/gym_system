import 'package:get_it/get_it.dart';
import 'package:gym_management_app/core/service/network/fcm_service.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_cubit.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_repo.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/user/market/cubit/market_user_cubit.dart';
import 'package:gym_management_app/features/data/market_repo.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/general/cubit/gerenal_cubit.dart';
import 'package:gym_management_app/features/user/general/home/data/home_repo.dart';
import 'package:gym_management_app/features/user/settings/cubit/settings_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_repo.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';

final GetIt getIt = GetIt.instance;

void serviceLocatorSetup() {
  //* NETWORK
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  getIt.registerLazySingleton<FcmService>(
    () => FcmService(getIt<FirebaseService>()),
  );

  //* AUTH
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));

  //* ADMIN
  // Alert
  getIt.registerLazySingleton<AlertRepo>(
    () => AlertRepo(getIt<FirebaseService>()),
  );

  getIt.registerFactory<AlertAdminCubit>(
    () => AlertAdminCubit(getIt<AlertRepo>()),
  );

  // member
  getIt.registerLazySingleton<MemberRepo>(
    () => MemberRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<MemberCubit>(() => MemberCubit(getIt<MemberRepo>()));

  // market
  getIt.registerLazySingleton<MarketRepo>(
    () => MarketRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<MarketAdminCubit>(
    () => MarketAdminCubit(getIt<MarketRepo>()),
  );

  // subscription history
  getIt.registerLazySingleton<SubscriptionHistoryRepo>(
    () => SubscriptionHistoryRepo(getIt<FirebaseService>()),
  );
  getIt.registerFactory<SubscriptionHistoryCubit>(
    () => SubscriptionHistoryCubit(getIt<SubscriptionHistoryRepo>()),
  );

  //* USER

  getIt.registerFactory<GerenalCubit>(() => GerenalCubit());
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo());
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));
  getIt.registerFactory<MarketUserCubit>(() => MarketUserCubit());
  getIt.registerFactory<SubscriptionCubit>(
    () => SubscriptionCubit(getIt<MemberRepo>()),
  );
  getIt.registerFactory<SettingsCubit>(() => SettingsCubit(getIt<AuthRepo>()));
}
