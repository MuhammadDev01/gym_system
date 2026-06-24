import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';
import 'package:gym_management_app/features/market/views/admin/widgets/edit_item_market_dialog_content.dart';
import 'package:gym_management_app/features/market/views/admin/widgets/market_item_builder.dart';

class EditItemOnMarketView extends StatefulWidget {
  const EditItemOnMarketView({super.key});

  @override
  State<EditItemOnMarketView> createState() => _EditItemOnMarketViewState();
}

class _EditItemOnMarketViewState extends State<EditItemOnMarketView> {
  @override
  void initState() {
    super.initState();
    if (context.read<MarketAdminCubit>().allProducts.isEmpty) {
      context.read<MarketAdminCubit>().getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'تعديل المنتجات'),
        body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
          listener: (_, state) {
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
          builder: (_, state) {
            final cubit = context.read<MarketAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MarketAdminLoading,
              child: cubit.allProducts.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cubit.allProducts.length,
                      itemBuilder: (_, index) {
                        return MarketItemBuilder(
                          item: cubit.allProducts[index],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: AppColors.gold),
                                onPressed: () {
                                  context.read<MarketAdminCubit>().startEdit(
                                    cubit.allProducts[index],
                                  );
                                  _showEditDialog(context);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.error,
                                ),
                                onPressed: () => showDeleteConfirm(
                                  context,
                                  title: 'هل تريد حذف المنتج بشكل نهائي؟',
                                  onConfirm: () {
                                    context
                                        .read<MarketAdminCubit>()
                                        .deleteProduct(
                                          cubit.allProducts[index].id,
                                        );
                                    context.pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : CustomEmptyList(text: 'منتجات'),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.background.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: EditItemMarketDialogContent(
            cubit: context.read<MarketAdminCubit>(),
            formkey: formKey,
          ),
        );
      },
    );
  }
}
