import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/models/user_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class MembersList extends StatelessWidget {
  final List<UserModel> members;

  const MembersList({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(
        child: CustomText(text: 'لا يوجد أعضاء', color: Colors.white38),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      separatorBuilder: (_, _) => const Gap(8),
      itemBuilder: (_, i) {
        final m = members[i];
        final typeLabel = _typeLabel(m.subscriptionType);
        final endDate = m.subscriptionEnd != null
            ? '${m.subscriptionEnd!.day}/${m.subscriptionEnd!.month}/${m.subscriptionEnd!.year}'
            : '—';
        return GlassWidget(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.person, color: AppColors.gold, size: 24),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: m.name, fontSize: 15),
                    const Gap(4),
                    CustomText(
                      text: m.phone,
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: typeLabel,
                    fontSize: 12,
                    color: AppColors.gold,
                  ),
                  const Gap(2),
                  CustomText(
                    text: endDate,
                    fontSize: 11,
                    color: Colors.white38,
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
