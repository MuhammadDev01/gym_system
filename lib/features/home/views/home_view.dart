import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/features/home/views/widgets/announcement_section.dart';
import 'package:gym_management_app/features/home/views/widgets/home_banner.dart';
import 'package:gym_management_app/features/home/views/widgets/member_card.dart';
import 'package:gym_management_app/features/home/views/widgets/training_today_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            HomeBanner(),
            Gap(16),

            MemberCard(),
            Gap(16),

            TrainingTodaySection(isAttendToday: true),
            Gap(16),

            AnnouncementSection(
              announcements: ["الجيم مفتوح 24 ساعة", "عرض الشهرين 450 بدل 600"],
            ),
          ],
        ),
      ),
    );
  }
}
