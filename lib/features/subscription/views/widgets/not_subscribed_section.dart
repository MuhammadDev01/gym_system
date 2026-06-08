import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/subscription/views/widgets/details_member_ship_card.dart';
import 'package:gym_management_app/features/subscription/views/widgets/member_ship_card.dart';

class NotSubscribedSection extends StatelessWidget {
  const NotSubscribedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NotSubscribedAlert(),
        const Gap(24),
        const CustomText(text: 'اختر الباقة المناسبة', fontSize: 18),
        const Gap(16),
        const _PackageCard(
          picCard: Assets.cardsGymCard,
          price: 300,
          color: Color(0xff9EB1BC),
        ),
        const Gap(16),
        _PackageCard(
          picCard: Assets.cardsFitnessCard,
          price: 400,
          color: Colors.grey,
        ),
        const Gap(16),
        _PackageCard(
          picCard: Assets.cardsPrivateCard,
          price: 500,
          color: ColorsApp.gold,
        ),
        const Gap(150),
      ],
    );
  }
}

// alert
class _NotSubscribedAlert extends StatelessWidget {
  const _NotSubscribedAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.errorRed.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsApp.errorRed.withValues(alpha: .25)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: ColorsApp.errorRed),
          const Gap(12),
          const Expanded(
            child: CustomText(text: 'أنت غير مشترك حالياً', fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String picCard;
  final int price;
  final Color color;
  const _PackageCard({
    required this.picCard,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MembershipCard(picCard: picCard),
        Positioned.fill(
          child: DetailsMemberShipCard(price: price, color: color),
        ),
      ],
    );
  }
}
