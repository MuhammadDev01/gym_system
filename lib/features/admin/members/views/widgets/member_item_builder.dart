import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';

class MemberItemBuilder extends StatelessWidget {
  const MemberItemBuilder({super.key, required this.member});
  final MemberModel member;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gold.withAlpha(38),
              borderRadius: BorderRadius.circular(14),
              image: member.image.isNotEmpty
                  ? DecorationImage(
                      image: BaseImageCache.getImage(member.image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: member.image.isEmpty
                ? Icon(Icons.person, color: AppColors.gold, size: 24)
                : null,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: member.name, fontSize: 15),
                const Gap(2),
                Row(
                  children: [
                    Icon(Icons.phone, size: 12, color: Colors.white54),
                    const Gap(4),
                    CustomText(
                      text: member.phone,
                      fontSize: 12,
                      color: AppColors.gold,
                    ),
                  ],
                ),
                const Gap(2),
                Row(
                  children: [
                    CustomText(
                      text: 'نوع الاشتراك:',
                      fontSize: 11,
                      color: Colors.white38,
                    ),
                    const Gap(4),
                    CustomText(
                      text: _typeLabel(member.subscriptionType),
                      fontSize: 11,
                      color: AppColors.gray,
                    ),
                    CustomText(
                      text: ' | تاريخ الانتهاء',
                      fontSize: 11,
                      color: Colors.white38,
                    ),
                    const Gap(4),
                    CustomText(
                      text:
                          '${member.subscriptionEnd!.day}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.year}',
                      fontSize: 11,
                      color: AppColors.gray,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'fitness':
        return 'فتنس';
      case 'gym':
        return 'جيم';
      case 'private':
        return 'برايفت';
      default:
        return type;
    }
  }
}
