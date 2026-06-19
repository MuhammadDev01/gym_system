import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/announcement_section.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/home_banner.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/home_member_info.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/training_today_section.dart';

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
      children: const [
        HomeBanner(),
        Gap(16),
        HomeMemberInfo(),
        Gap(16),
        TrainingTodaySection(isAttendToday: true),
        Gap(16),
        AlertSection(
          alerts: [
            "الجيم مفتوح 24 ساعة",
            "عرض الشهرين 450 بدل 600",
            "عرض الشهرين 450 بدل 600",
            "عرض الشهرين 450 بدل 600",
          ],
        ),
      ],
    );
  }
}
