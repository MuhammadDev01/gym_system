import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/admin/market/views/widgets/market_item_builder.dart';

class MarketItemsListView extends StatelessWidget {
  const MarketItemsListView({super.key});

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
              child: state is MarketAdminLoaded && state.products.isNotEmpty
                  ? ListView.separated(
                      addAutomaticKeepAlives: false,
                      separatorBuilder: (_, _) =>
                          Divider(color: Colors.transparent),
                      padding: const EdgeInsets.all(16),
                      itemCount: state.products.length,
                      itemBuilder: (_, index) {
                        return MarketItemBuilder(item: state.products[index]);
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
