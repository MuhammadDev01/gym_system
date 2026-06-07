import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/theme_app.dart';
import 'package:gym_management_app/features/root/views/root_view.dart';

void main() {
  runApp(const GymSystemApp());
}

class GymSystemApp extends StatelessWidget {
  const GymSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym System App',
      darkTheme: ThemeApp.defualtTheme,

      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const RootView(),
      ),
    );
  }
}
