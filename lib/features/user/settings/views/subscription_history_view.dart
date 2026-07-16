import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/subscription_history_field_and_button.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/subscription_history_list_builder.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';

class SubscriptionHistoryView extends StatefulWidget {
  const SubscriptionHistoryView({super.key});

  @override
  State<SubscriptionHistoryView> createState() =>
      _SubscriptionHistoryViewState();
}

class _SubscriptionHistoryViewState extends State<SubscriptionHistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionHistoryCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: "سجل الاشتراكات",
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.monthlySubscriptionView),
            icon: FaIcon(FontAwesomeIcons.bars),
            color: AppColors.gold,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backround),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          spacing: 16,
          children: const [
            SubscriptionHistoryFieldAndButton(),
            SubscriptionHistoryListBuilder(),
          ],
        ),
      ),
    );
  }
}
