import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(Assets.profilePic),
            ),

            Gap(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "dev muhammad"),
                  Gap(4),
                  CustomText(text: "فتنس", fontSize: 16, color: ColorsApp.gold),
                ],
              ),
            ),

            Column(
              children: [
                CustomText(text: "18", color: ColorsApp.gold, fontSize: 32),
                CustomText(
                  text: "يوم متبقي",
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
