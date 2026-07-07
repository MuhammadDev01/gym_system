import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

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
          child: Column(spacing: 24, children: [_itemCard(), _priceItemCard()]),
        ),
      ),
    );
  }

  GlassWidget _priceItemCard() {
    return GlassWidget(
      borderRaduis: 12,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const CustomText(text: 'السعر', fontSize: 18),
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
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Image(image: BaseImageCache.getImage(item.image)),
          CustomText(
            text: item.name,
            fontSize: 22,
            textAlign: TextAlign.center,
          ),
          const Gap(4),
          CustomText(
            text: item.isInStock ? 'متوفر' : 'غير متوفر حالياً',
            fontSize: 13,
            color: item.isInStock ? AppColors.success : AppColors.error,
          ),
          const Gap(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'الوصف:',
                fontSize: 16,
                color: AppColors.gold,
              ),
              Gap(8),
              Expanded(
                child: CustomText(
                  text: item.description,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
