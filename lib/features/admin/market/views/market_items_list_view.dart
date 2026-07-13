import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/market_item_builder.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

class MarketItemsListView extends StatefulWidget {
  const MarketItemsListView({super.key});

  @override
  State<MarketItemsListView> createState() => _MarketItemsListViewState();
}

class _MarketItemsListViewState extends State<MarketItemsListView> {
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(
          title: 'قائمة المنتجات',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.gold),
              onPressed: () =>
                  context.read<MarketAdminCubit>().getProducts(refresh: true),
            ),
          ],
        ),
        body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
          buildWhen: (prev, next) =>
              next is MarketAdminLoaded ||
              next is MarketAdminLoading ||
              next is MarketAdminError,
          listener: (context, state) {
            if (state is MarketAdminError) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
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
                          child: _buildList(state.products),
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

  Widget _buildList(List<MarketItemModel> products) {
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
      addAutomaticKeepAlives: false,
      separatorBuilder: (_, _) => const Gap(16),
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (_, index) => MarketItemBuilder(item: filtered[index]),
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
