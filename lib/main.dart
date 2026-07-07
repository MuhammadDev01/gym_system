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
  runApp(const GymSystemApp());
}

class GymSystemApp extends StatelessWidget {
  const GymSystemApp({super.key});
  final bool kDebugSingleScreen = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Gym System App',
        theme: ThemeApp.defualtTheme,
        routerConfig: goRouter,
        builder: (_, child) {
          final brightness = MediaQuery.platformBrightnessOf(context);
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
