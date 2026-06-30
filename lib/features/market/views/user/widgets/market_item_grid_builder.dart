import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';

class MarketItemGridBuilder extends StatelessWidget {
  const MarketItemGridBuilder({super.key, required this.item});
  final MarketItemModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.marketItemDetailView, extra: item),
      child: GlassWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image(
                  image: BaseImageCache.getImage(item.image),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.name,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  Gap(4),
                  CustomText(
                    text: item.description,
                    color: AppColors.gray.withValues(alpha: 0.5),
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: '${item.price} ج.م',
                        color: AppColors.gold,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomText(
                          text: item.type == ItemType.supplement
                              ? 'مكمل'
                              : 'أداة',
                          fontSize: 10,
                          color: AppColors.gold,
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
    );
  }
}
