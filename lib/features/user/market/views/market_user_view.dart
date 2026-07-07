import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/user/market/cubit/marke_user_state.dart';
import 'package:gym_management_app/features/user/market/cubit/market_user_cubit.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_grid_builder.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class MarketUserView extends StatelessWidget {
  const MarketUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketUserCubit, MarketUserState>(
      listener: (context, state) {
        if (state is MarketError) {
          appSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MarketUserCubit>();

        return CustomLoadingOverlay(
          isLoading: state is MarketLoading,
          child: state is MarketLoaded
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        MarketItemFilter(
                          selectedFilter: cubit.selectedFilter,
                          onFilterChanged: cubit.filterByType,
                        ),
                        const Gap(8),
                        Expanded(
                          child: cubit.filteredItems.isEmpty
                              ? const CustomEmptyList(text: 'منتجات')
                              : GridView.builder(
                                  addAutomaticKeepAlives: false,
                                  itemBuilder: (context, index) =>
                                      MarketItemGridBuilder(
                                        item: cubit.filteredItems[index],
                                      ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.85,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                  itemCount: cubit.filteredItems.length,
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              : const CustomEmptyList(text: 'منتجات'),
        );
      },
    );
  }
}
