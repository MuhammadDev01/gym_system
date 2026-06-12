import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/routes/routes.dart';
import 'package:gym_management_app/core/service/firebase_service.dart';
import 'package:gym_management_app/core/theme/theme_app.dart';
import 'package:gym_management_app/features/market/cubit/market_cubit.dart';
import 'package:gym_management_app/features/profile/cubit/profile_cubit.dart';
import 'package:gym_management_app/features/general/cubit/gerenal_cubit.dart';
import 'package:gym_management_app/features/auth/cubit/user_cubit.dart';
import 'package:gym_management_app/features/root/cubit/root_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
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
        //BlocProvider.value(value: _userCubit),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => RootCubit()..checkAuth()),
        BlocProvider(create: (context) => GerenalCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => MarketCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gym System App',
        darkTheme: ThemeApp.defualtTheme,
        initialRoute: AppRoutes.rootView,
        routes: routes,
      ),
    );
  }
}
