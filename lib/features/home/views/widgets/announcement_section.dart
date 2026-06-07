import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
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
        const CustomText(text: "تنبيهات من الكابتن", fontSize: 22),

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorsApp.gold.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: ColorsApp.gold,
              size: 20,
            ),
          ),

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
