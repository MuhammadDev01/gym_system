import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/views/admin/add_market_admin_view.dart';

class MarketAdminView extends StatefulWidget {
  const MarketAdminView({super.key});

  @override
  State<MarketAdminView> createState() => _MarketAdminViewState();
}

class _MarketAdminViewState extends State<MarketAdminView> {
  @override
  void initState() {
    super.initState();
    context.read<MarketAdminCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المنتجات')),
      body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
        listener: (context, state) {
          if (state is MarketAdminDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف المنتج بنجاح')),
            );
          } else if (state is MarketAdminUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث المنتج بنجاح')),
            );
          } else if (state is MarketAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MarketAdminLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'جميع المنتجات',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }
                final product = products[index - 1];
                return _buildProductCard(product);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMarketAdminView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(MarketModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.image,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description, maxLines: 2),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${product.price} ج.م',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
                const Spacer(),
                Text(
                  product.type == ItemType.supplement ? 'مكمل' : 'أداة',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
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
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<MarketAdminCubit>().deleteProduct(product.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
