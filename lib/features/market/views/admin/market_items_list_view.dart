import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';
import 'package:gym_management_app/features/market/views/admin/widgets/market_item_builder.dart';

class MarketItemsListView extends StatefulWidget {
  const MarketItemsListView({super.key});

  @override
  State<MarketItemsListView> createState() => _MarketItemsListViewState();
}

class _MarketItemsListViewState extends State<MarketItemsListView> {
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
        appBar: GlassAppBar(title: 'قائمة المنتجات'),
        body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
          listener: (context, state) {
            if (state is MarketAdminError) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            final cubit = context.read<MarketAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MarketAdminLoading,
              child: cubit.allProducts.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (_, _) =>
                          Divider(color: Colors.transparent),
                      padding: const EdgeInsets.all(16),
                      itemCount: cubit.allProducts.length,
                      itemBuilder: (_, index) {
                        return MarketItemBuilder(
                          item: cubit.allProducts[index],
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
}
