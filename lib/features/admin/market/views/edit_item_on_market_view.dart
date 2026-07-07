import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/edit_item_market_dialog_content.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/market_item_builder.dart';

class EditItemOnMarketView extends StatelessWidget {
  const EditItemOnMarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
          builder: (context, state) {
            final cubit = context.read<MarketAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MarketAdminLoading,
              child: state is MarketAdminLoaded
                  ? ListView.separated(
                      separatorBuilder: (_, _) => const Gap(16),
                      addAutomaticKeepAlives: false,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return MarketItemBuilder(
                          item: state.products[index],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: AppColors.gold),
                                onPressed: () {
                                  cubit.startEdit(state.products[index]);
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
                                  onConfirm: () async {
                                    context.pop();
                                    await cubit.deleteProduct(
                                      state.products[index].id,
                                    );
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
    final cubit = context.read<MarketAdminCubit>();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: EditItemMarketDialogContent(cubit: cubit, formkey: formKey),
        );
      },
    );
  }
}
