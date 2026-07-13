import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

class MarketItemBuilder extends StatelessWidget {
  const MarketItemBuilder({super.key, required this.item, this.trailing});
  final MarketItemModel item;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      borderRaduis: 16,
      child: ListTile(
        leading: item.image.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: BaseImageCache.getImage(item.image),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              )
            : const Icon(Icons.shopping_bag, color: AppColors.gold),
        title: CustomText(text: item.name),
        subtitle: CustomText(
          text: '${item.price} ج.م',
          fontSize: 13,
          color: AppColors.gold,
        ),
        trailing: trailing,
      ),
    );
  }
}
