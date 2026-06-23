import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';

class MarketItemsListView extends StatefulWidget {
  const MarketItemsListView({super.key});

  @override
  State<MarketItemsListView> createState() => _MarketItemsListViewState();
}

class _MarketItemsListViewState extends State<MarketItemsListView> {
  @override
  void initState() {
    super.initState();
    context.read<MarketAdminCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'قائمة المنتجات'),
        body: BlocBuilder<MarketAdminCubit, MarketAdminState>(
          builder: (_, state) {
            if (state is MarketAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MarketAdminLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(child: CustomText(text: 'لا توجد منتجات'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (_, i) => _ProductCard(product: products[i]),
              );
            }
            if (state is MarketAdminError) {
              return Center(child: CustomText(text: state.message));
            }
            return const Center(child: CustomText(text: 'جاري التحميل...'));
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final MarketItemModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassWidget(
        borderRaduis: 20,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.image.isNotEmpty
                  ? Image.memory(
                      base64Decode(product.image),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.white12,
                      child: Icon(
                        Icons.shopping_bag,
                        color: AppColors.gold,
                        size: 32,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(color: AppColors.gray, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomText(
                        text: '${product.price} ج.م',
                        fontSize: 14,
                        color: AppColors.gold,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: product.type == ItemType.tool
                              ? AppColors.gold.withValues(alpha: .2)
                              : AppColors.success.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText(
                          text: product.type == ItemType.tool ? 'أداة' : 'مكمل',
                          fontSize: 11,
                          color: product.type == ItemType.tool
                              ? AppColors.gold
                              : AppColors.success,
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
