import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_glass_alert.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_cubit.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_state.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/details_member_ship_card.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/member_ship_card.dart';

class NotSubscribedSection extends StatelessWidget {
  const NotSubscribedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PricesCubit, PricesState>(
      builder: (context, state) {
        final gym = state is PricesLoaded ? state.gym : 300;
        final fitness = state is PricesLoaded ? state.fitness : 400;
        final priv = state is PricesLoaded ? state.private : 500;
        return Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomGlassAlert(
              text: 'أنت غير مشترك حالياً',
              color: AppColors.error,
              icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            ),
            CustomText(
              text: "الباقات المتاحة",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            _PackageCard(
              picCard: AppAssets.cardsGymCard,
              price: gym,
              color: const Color(0xff9EB1BC),
            ),
            _PackageCard(
              picCard: AppAssets.cardsFitnessCard,
              price: fitness,
              color: Colors.grey,
            ),
            _PackageCard(
              picCard: AppAssets.cardsPrivateCard,
              price: priv,
              color: AppColors.gold,
            ),
          ],
        );
      },
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
