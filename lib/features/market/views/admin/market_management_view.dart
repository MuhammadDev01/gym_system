import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_card.dart';

class MarketManagementView extends StatelessWidget {
  const MarketManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'إدارة المتجر'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.cartPlus,
                title: 'إضافة منتج للمتجر',
                onTap: () => context.push(AppRoutes.addItemOnMarketView),
              ),
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.penToSquare,
                title: 'تعديل منتج',
                onTap: () => context.push(AppRoutes.editItemOnMarketView),
              ),
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.shopify,
                title: 'قائمة المنتجات',
                onTap: () => context.push(AppRoutes.marketItemsListView),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
