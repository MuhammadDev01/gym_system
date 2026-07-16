import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
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
      listenWhen: (_, next) => next is MarketError,
      listener: (context, state) {
        if (state is MarketError) {
          appSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MarketUserCubit>();
        if (state is MarketLoading) {
          return CustomCircularLoading();
        }
        if (cubit.filteredItems.isNotEmpty) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                spacing: 8,
                children: [
                  MarketItemFilter(
                    selectedFilter: cubit.selectedFilter,
                    onFilterChanged: cubit.filterByType,
                  ),
                  Expanded(
                    child: GridView.builder(
                      addAutomaticKeepAlives: false,
                      itemBuilder: (context, index) => MarketItemGridBuilder(
                        item: cubit.filteredItems[index],
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      itemCount: cubit.filteredItems.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const CustomEmptyList(text: 'منتجات');
      },
    );
  }
}
