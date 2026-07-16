import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: item.isInStock
          ? () => context.push(AppRoutes.marketItemDetailView, extra: item)
          : null,
      child: Opacity(
        opacity: item.isInStock ? 1.0 : 0.5,
        child: Stack(
          children: [
            GlassWidget(
              borderRaduis: 14,
              borderColor: AppColors.gold,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image(
                      image: BaseImageCache.getImage(item.image),
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      spacing: 6,
                      children: [
                        CustomText(
                          text: item.name,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: 14,
                        ),
                        CustomText(
                          text: item.description,
                          color: AppColors.textSecondary,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: 12,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomText(
                            text: '${item.price} ج.م',
                            color: AppColors.gold,
                          ),
                        ),
                        if (item.sellByKilo && item.kiloPrice != null)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CustomText(
                              text: 'الكيلو: ${item.kiloPrice} ج.م',
                              fontSize: 10,
                              color: AppColors.gray,
                            ),
                          ),
                        if (item.sellByPiece && item.piecePrice != null)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CustomText(
                              text: 'الأسكوب: ${item.piecePrice} ج.م',
                              fontSize: 10,
                              color: AppColors.gray,
                            ),
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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const CustomText(text: 'غير متوفر', fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
