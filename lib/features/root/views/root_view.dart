import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/home/views/home_view.dart';
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
  PageController pageController = PageController();
  int currentIndex = 0;
  List<Widget> views = const [
    HomeView(),
    SubscriptionView(),
    OfftersView(),
    ProfileView(),
    SettingsView(),
  ];
  @override
  initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.backround),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: views,
        ),
      ),

      //bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
            pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
            );
          });
        },
        currentIndex: currentIndex,

        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimney),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.dumbbell),
            label: 'اشتراكي',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.tag),
            label: 'العروض',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
