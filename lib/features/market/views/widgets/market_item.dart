import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';

class MarketItem extends StatelessWidget {
  const MarketItem({super.key, required this.item});
  final MarketModel item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: .08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: _containerDecoration(),
                    child: Center(
                      child: Image.asset(
                        Assets.manHandADumbel,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              //market item details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: item.name, fontSize: 14),
                    const Gap(4),
                    CustomText(
                      text: item.description,
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: "${item.price} جنيه",
                            fontSize: 14,
                            color: ColorsApp.gold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          ColorsApp.gold.withValues(alpha: .2),
          ColorsApp.gold.withValues(alpha: .05),
        ],
      ),
    );
  }
}
