import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/home/views/home_view.dart';
import 'package:gym_management_app/features/market/views/market_view.dart';
import 'package:gym_management_app/features/profile/views/profile_view.dart';
import 'package:gym_management_app/features/root/cubit/root_cubit.dart';
import 'package:gym_management_app/features/root/views/widgets/custom_nav_bar.dart';
import 'package:gym_management_app/features/settings/views/settings_view.dart';
import 'package:gym_management_app/features/subscription/views/subscription_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final views = const [
      HomeView(),
      SubscriptionView(),
      ProfileView(),
      MarketView(),
      SettingsView(),
    ];

    return BlocBuilder<RootCubit, RootState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.backround),
                fit: BoxFit.cover,
              ),
            ),

            child: views[context.read<RootCubit>().currentIndex],
          ),

          bottomNavigationBar: CustomNavBar(),
        );
      },
    );
  }
}
