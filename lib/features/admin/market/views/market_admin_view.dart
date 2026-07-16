import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/market_item_builder.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class MarketAdminView extends StatelessWidget {
  const MarketAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
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
          buildWhen: (_, next) =>
              next is MarketAdminLoaded || next is MarketAdminLoading,
          listener: (context, state) {
            if (state is MarketAdminError) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
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
                            ),
                          ),
                        )
                      : CustomEmptyList(text: "منتجات"),
              ],
            );
          },
        ),
      ),
    );
  }
}
