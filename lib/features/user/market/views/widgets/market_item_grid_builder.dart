import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

class MarketItemGridBuilder extends StatelessWidget {
  const MarketItemGridBuilder({super.key, required this.item});
  final MarketItemModel item;

  @override
  Widget build(BuildContext context) {
    final opacity = item.isInStock ? 1.0 : 0.5;
    return GestureDetector(
      onTap: item.isInStock
          ? () => context.push(AppRoutes.marketItemDetailView, extra: item)
          : null,
      child: Opacity(
        opacity: opacity,
        child: Stack(
          children: [
            GlassWidget(
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
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CustomText(
                          text: item.name,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: 14,
                        ),
                        Gap(4),
                        CustomText(
                          text: item.description,
                          color: AppColors.gray.withValues(alpha: 0.5),
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: 12,
                        ),
                        Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: '${item.price} ج.م',
                              color: AppColors.gold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isInStock)
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const CustomText(
                      text: 'غير متوفر',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
