import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/models/member_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class MemberList extends StatelessWidget {
  final List<MemberModel> member;

  const MemberList({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    if (member.isEmpty) {
      return Center(
        child: CustomText(text: 'لا يوجد أعضاء', color: AppColors.gray),
      );
    }
    return ListView.separated(
      itemCount: member.length,
      separatorBuilder: (_, _) => const Gap(16),
      itemBuilder: (_, i) {
        final m = member[i];
        final typeLabel = _typeLabel(m.subscriptionType);
        final endDate = m.subscriptionEnd != null
            ? '${m.subscriptionEnd!.day}/${m.subscriptionEnd!.month}/${m.subscriptionEnd!.year}'
            : '—';

        return GlassWidget(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha(38),
                      borderRadius: BorderRadius.circular(14),
                      image: m.image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(m.image),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: m.image.isEmpty
                        ? Icon(Icons.person, color: AppColors.gold, size: 24)
                        : null,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: m.name, fontSize: 15),
                        const Gap(2),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 12, color: Colors.white54),
                            const Gap(4),
                            CustomText(
                              text: m.phone,
                              fontSize: 12,
                              color: Colors.white54,
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
                              text: typeLabel,
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
                              text: endDate,
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
            ],
          ),
        );
      },
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
