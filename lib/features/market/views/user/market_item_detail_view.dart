import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';

class MarketItemDetailView extends StatelessWidget {
  const MarketItemDetailView({super.key, required this.item});

  final MarketItemModel item;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'تفاصيل المنتج'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(children: [_itemCard(), Gap(24), _priceItemCard()]),
        ),
      ),
    );
  }

  GlassWidget _priceItemCard() {
    return GlassWidget(
      borderRaduis: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const CustomText(text: 'السعر', fontSize: 16),
          const Spacer(),
          CustomText(
            text: '${item.price} ج.م',
            fontSize: 20,
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }

  GlassWidget _itemCard() {
    return GlassWidget(
      child: Column(
        children: [
          Image(
            image: BaseImageCache.getImage(item.image),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          Gap(20),
          CustomText(text: item.name, fontSize: 22),
          Gap(8),
          CustomText(
            text: item.description,
            color: AppColors.gray.withValues(alpha: 0.8),
          ),
          Gap(16),
          Container(
            margin: EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: item.type == ItemType.tool
                  ? AppColors.gold.withValues(alpha: 0.15)
                  : AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomText(
              text: item.type == ItemType.tool ? 'أداة' : 'مكمل',
              fontSize: 13,
              color: item.type == ItemType.tool
                  ? AppColors.gold
                  : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
