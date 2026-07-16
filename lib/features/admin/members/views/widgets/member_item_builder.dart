import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';

class MemberItemBuilder extends StatelessWidget {
  const MemberItemBuilder({super.key, required this.member});
  final MemberModel member;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      borderRaduis: 8,
      borderColor: AppColors.gold,
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gold.withAlpha(38),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person, color: AppColors.gold, size: 24),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: member.name),
                Row(
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    CustomText(
                      text: member.phone,
                      fontSize: 12,
                      color: AppColors.gold,
                    ),
                  ],
                ),
                Row(
                  spacing: 6,
                  children: [
                    const CustomText(
                      text: 'نوع الاشتراك:',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    CustomText(
                      text: _typeLabel(member.subscriptionType),
                      fontSize: 12,
                    ),
                    const CustomText(text: "|", color: AppColors.gold),
                    const CustomText(
                      text: 'تاريخ الانتهاء',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    CustomText(
                      text:
                          '${member.subscriptionEnd!.year}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.day}',
                      fontSize: 12,
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
      case AppConstants.fitness:
        return 'فتنس';
      case AppConstants.gym:
        return 'جيم';
      case AppConstants.private:
        return 'برايفت';
      default:
        return type;
    }
  }
}
