import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/features/user/market/cubit/market_cubit.dart';
import 'package:gym_management_app/features/user/market/cubit/market_state.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'المتجر',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Gap(16),
        BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            final cubit = context.read<MarketCubit>();
            return Column(
              children: [
                ItemFilter(
                  selectedFilter: cubit.selectedFilter,
                  onFilterChanged: (filter) => cubit.filterByType(filter),
                ),
                const Gap(16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: cubit.filteredItems.length,
                  itemBuilder: (context, index) {
                    return MarketItem(item: cubit.filteredItems[index]);
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
