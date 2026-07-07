import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

class ManageProductsList extends StatelessWidget {
  const ManageProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketAdminCubit, MarketAdminState>(
      builder: (context, state) {
        if (state is MarketAdminLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('لا توجد منتجات')),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return _ProductCard(product: product);
              },
              childCount: products.length,
              addAutomaticKeepAlives: false,
            ),
          );
        }
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final MarketItemModel product;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<MarketAdminCubit>().deleteProduct(product.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: BaseImageCache.getImage(product.image),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[800],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          title: Text(product.name),
          subtitle: Row(
            children: [
              Text(
                '${product.price} ج.م - ${product.type == ItemType.supplement ? 'مكمل' : 'أداة'}',
              ),
              const SizedBox(width: 8),
              Text(
                product.isInStock ? '' : '(غير متوفر)',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.gold),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
