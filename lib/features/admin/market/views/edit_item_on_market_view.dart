import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/edit_item_market_dialog_content.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/market_item_builder.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class EditItemOnMarketView extends StatelessWidget {
  const EditItemOnMarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(title: 'تعديل المنتجات'),
        body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
          listener: (context, state) {
            if (state is MarketAdminUpdated) {
              appSnackbar(
                context,
                'تم التحديث بنجاح',
                color: AppColors.success,
              );
            } else if (state is MarketAdminDeleted) {
              appSnackbar(context, 'تم الحذف بنجاح', color: AppColors.success);
            } else if (state is MarketAdminError) {
              appSnackbar(context, state.message);
            }
          },
          buildWhen: (_, next) =>
              next is MarketAdminLoading || next is MarketAdminLoaded,
          builder: (context, state) {
            final cubit = context.read<MarketAdminCubit>();
            return Column(
              children: [
                MarketItemFilter(
                  selectedFilter: cubit.selectedFilter,
                  onFilterChanged: cubit.filterByType,
                ),
                if (state is MarketAdminLoading) CustomCircularLoading(),
                if (state is MarketAdminLoaded)
                  state.products.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            addAutomaticKeepAlives: false,
                            separatorBuilder: (_, _) => const Gap(16),
                            padding: const EdgeInsets.all(16),
                            itemCount: cubit.filteredProducts.length,
                            itemBuilder: (_, index) => MarketItemBuilder(
                              item: cubit.filteredProducts[index],
                              trailing: _TrailingMarketProduct(
                                product: cubit.filteredProducts[index],
                              ),
                            ),
                          ),
                        )
                      : CustomEmptyList(text: 'منتجات'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TrailingMarketProduct extends StatelessWidget {
  const _TrailingMarketProduct({required this.product});
  final MarketItemModel product;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: AppColors.gray),
          onPressed: () {
            context.read<MarketAdminCubit>().startEdit(product);
            _showEditDialog(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: AppColors.error),
          onPressed: () => showDeleteConfirm(
            context,
            title: 'هل تريد حذف المنتج بشكل نهائي؟',
            onConfirm: () async {
              await context.read<MarketAdminCubit>().deleteProduct(product.id);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final cubit = context.read<MarketAdminCubit>();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: EditItemMarketDialogContent(cubit: cubit, formkey: formKey),
        );
      },
    );
  }
}
