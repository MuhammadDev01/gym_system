import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/market/cubit/user/market_cubit.dart';
import 'package:gym_management_app/features/market/cubit/user/market_state.dart';
import 'package:gym_management_app/features/market/views/user/widgets/market_item_card.dart';
import 'package:gym_management_app/features/market/views/user/widgets/market_item_filter.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        if (state is MarketLoaded) {
          final cubit = context.read<MarketCubit>();
          return Padding(
            padding: const EdgeInsets.all(8),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: MarketItemFilter(
                    selectedFilter: cubit.selectedFilter,
                    onFilterChanged: cubit.filterByType,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                cubit.filteredItems.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text('لا توجد منتجات')),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return MarketItemCard(
                            item: cubit.filteredItems[index],
                          );
                        }, childCount: cubit.filteredItems.length),
                      ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
