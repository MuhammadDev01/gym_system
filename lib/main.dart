import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/theme/theme_app.dart';
import 'package:gym_management_app/features/profile/cubit/profile_cubit.dart';
import 'package:gym_management_app/features/root/cubit/root_cubit.dart';
import 'package:gym_management_app/features/root/views/root_view.dart';

void main() {
  runApp(const GymSystemApp());
}

class GymSystemApp extends StatelessWidget {
  const GymSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RootCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gym System App',
        darkTheme: ThemeApp.defualtTheme,

        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const RootView(),
        ),
      ),
    );
  }
}
