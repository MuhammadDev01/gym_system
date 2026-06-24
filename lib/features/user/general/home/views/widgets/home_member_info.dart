import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';

class HomeMemberInfo extends StatelessWidget {
  const HomeMemberInfo({
    super.key,
    required this.member,
    required this.remainingDays,
  });

  final MemberModel member;
  final int remainingDays;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: member.image.isNotEmpty
                  ? MemoryImage(base64Decode(member.image))
                  : null,
              child: member.image.isEmpty
                  ? const Icon(Icons.person, color: Colors.white38)
                  : null,
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: member.name, fontSize: 16),
                  const Gap(4),
                  CustomText(
                    text: member.phone,
                    color: AppColors.gold,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CustomText(
                  text: remainingDays.toString(),
                  color: AppColors.gold,
                  fontSize: 20,
                ),
                const CustomText(text: 'يوم متبقي', color: Colors.white70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
