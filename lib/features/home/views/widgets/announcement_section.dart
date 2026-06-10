import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_status_icon.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class AnnouncementSection extends StatelessWidget {
  const AnnouncementSection({super.key, required this.announcements});

  final List<String> announcements;

  @override
  Widget build(BuildContext context) {
    if (announcements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "تنبيهات من الكابتن",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Gap(12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: announcements.length,
          separatorBuilder: (_, _) => const Gap(12),
          itemBuilder: (_, index) {
            return AnnouncementItem(message: announcements[index]);
          },
        ),
      ],
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomStatusIcon(color: ColorsApp.gold, icon: Icons.campaign_rounded),

          const Gap(12),

          Expanded(
            child: CustomText(
              text: message,
              fontSize: 14,
              color: ColorsApp.gray,
            ),
          ),
        ],
      ),
    );
  }
}
