import 'package:flutter/material.dart';
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
        appBar: GlassAppBar(title: 'تفاصيل المنتج'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 24,
            children: [
              _DetailsItemCard(item: item),
              _PriceItemCard(price: item.price.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceItemCard extends StatelessWidget {
  const _PriceItemCard({required this.price});
  final String price;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      borderRaduis: 12,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(text: 'السعر', fontSize: 18),
          CustomText(text: '$price ج.م', fontSize: 20, color: AppColors.gold),
        ],
      ),
    );
  }
}

class _DetailsItemCard extends StatelessWidget {
  const _DetailsItemCard({required this.item});
  final MarketItemModel item;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 8,
        children: [
          Image(image: BaseImageCache.getImage(item.image)),
          CustomText(
            text: item.name,
            fontSize: 22,
            textAlign: TextAlign.center,
          ),
          CustomText(
            text: item.isInStock ? 'متوفر' : 'غير متوفر حالياً',
            fontSize: 13,
            color: item.isInStock ? AppColors.success : AppColors.error,
          ),
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'الوصف:',
                fontSize: 16,
                color: AppColors.gold,
              ),
              Expanded(
                child: CustomText(
                  text: item.description,
                  height: 1.7,
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
