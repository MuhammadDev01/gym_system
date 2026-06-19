import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_glass_alert.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/details_member_ship_card.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/member_ship_card.dart';

class NotSubscribedSection extends StatelessWidget {
  const NotSubscribedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomGlassAlert(
          text: 'أنت غير مشترك حالياً',
          color: AppColors.error,
          icon: Icons.cancel_outlined,
        ),
        const Gap(24),
        CustomText(
          text: "الباقات المتاحة",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Gap(16),
        const _PackageCard(
          picCard: AppAssets.cardsGymCard,
          price: 300,
          color: Color(0xff9EB1BC),
        ),
        const Gap(16),
        _PackageCard(
          picCard: AppAssets.cardsFitnessCard,
          price: 400,
          color: Colors.grey,
        ),
        const Gap(16),
        _PackageCard(
          picCard: AppAssets.cardsPrivateCard,
          price: 500,
          color: AppColors.gold,
        ),
        const Gap(80),
      ],
    );
  }
}

// Alerts

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
        MemberhipCard(picCard: picCard),
        Positioned.fill(
          child: DetailsMemberShipCard(price: price, color: color),
        ),
      ],
    );
  }
}
