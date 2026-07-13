import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
import 'package:gym_management_app/features/data/market_item_model.dart';

class EditItemOnMarketView extends StatefulWidget {
  const EditItemOnMarketView({super.key});

  @override
  State<EditItemOnMarketView> createState() => _EditItemOnMarketViewState();
}

class _EditItemOnMarketViewState extends State<EditItemOnMarketView> {
  String _filterType = 'all';

  @override
  void initState() {
    context.read<MarketAdminCubit>().getProducts();
    super.initState();
  }

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
            return CustomLoadingOverlay(
              isLoading: state is MarketAdminLoading,
              child: state is MarketAdminLoaded
                  ? Column(
                      children: [
                        _FilterRow(
                          selected: _filterType,
                          onChanged: (v) => setState(() => _filterType = v),
                        ),
                        Expanded(
                          child: _buildList(state.products, cubit),
                        ),
                      ],
                    )
                  : CustomEmptyList(text: 'منتجات'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<MarketItemModel> products, MarketAdminCubit cubit) {
    final filtered = _filterType == 'all'
        ? products
        : products.where((p) {
            final typeStr = p.type == ItemType.tool ? 'tool' : 'supplement';
            return typeStr == _filterType;
          }).toList();

    if (filtered.isEmpty) {
      return const CustomEmptyList(text: 'منتجات');
    }

    return ListView.separated(
      separatorBuilder: (_, _) => const Gap(16),
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return MarketItemBuilder(
          item: filtered[index],
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.gray),
                onPressed: () {
                  cubit.startEdit(filtered[index]);
                  _showEditDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.error),
                onPressed: () => showDeleteConfirm(
                  context,
                  title: 'هل تريد حذف المنتج بشكل نهائي؟',
                  onConfirm: () async {
                    await cubit.deleteProduct(filtered[index].id);
                  },
                ),
              ),
            ],
          ),
        );
      },
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

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _chip('الكل', 'all'),
          const Gap(8),
          _chip('مكملات', 'supplement'),
          const Gap(8),
          _chip('أدوات', 'tool'),
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
