import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/user/market/data/market_item_model.dart';

class MarketItem extends StatelessWidget {
  const MarketItem({super.key, required this.item});
  final MarketModel item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GlassWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(AppAssets.manHandADumbel, fit: BoxFit.cover),
            ),

            //market item details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: item.name),
                  const Gap(6),
                  CustomText(
                    text: item.description,
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                  const Gap(6),
                  CustomText(text: "${item.price} جنيه", color: AppColors.gold),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
