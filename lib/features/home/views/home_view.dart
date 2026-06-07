import 'package:flutter/material.dart';
import 'package:gym_management_app/features/home/widgets/home_appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(),
        Expanded(child: Center(child: Text('Welcome to the Home Page!'))),
      ],
    );
  }
}
