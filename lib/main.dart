import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/observer/bloc_observer.dart';
import 'package:gym_management_app/core/routes/routes.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/core/service/network/fcm_service.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/core/theme/app_theme.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_cubit.dart';
import 'package:gym_management_app/features/alerts/cubit/alert_user_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/user/general/cubit/gerenal_cubit.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  await LocalCacheService.init();
  serviceLocatorSetup();
  try {
    await getIt<FcmService>().initialize();
  } catch (_) {}
  Bloc.observer = AppBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const GymSystemApp());
}

class GymSystemApp extends StatelessWidget {
  const GymSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => GerenalCubit()),
        BlocProvider(create: (context) => getIt<MemberCubit>()),
        BlocProvider(create: (context) => getIt<AlertUserCubit>()),
        BlocProvider(create: (context) => getIt<AlertAdminCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Gym System App',
        theme: ThemeApp.defualtTheme,
        routerConfig: goRouter,
      ),
    );
  }
}
