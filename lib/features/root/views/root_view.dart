import 'package:flutter/material.dart';
import 'package:gym_management_app/features/home/views/home_view.dart';
import 'package:gym_management_app/features/home/widgets/home_appbar.dart';
import 'package:gym_management_app/features/offers/views/offters_view.dart';
import 'package:gym_management_app/features/profile/views/profile_view.dart';
import 'package:gym_management_app/features/settings/views/settings_view.dart';
import 'package:gym_management_app/features/subscription/views/subscription_view.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int currentIndex = 0;
  List<Widget> views = [
    const HomeView(),
    const SubscriptionView(),
    const OfftersView(),
    ProfileView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'اشتراكي',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'العروض',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
