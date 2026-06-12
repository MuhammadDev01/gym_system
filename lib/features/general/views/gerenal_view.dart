import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/home/views/home_view.dart';
import 'package:gym_management_app/features/market/views/market_view.dart';
import 'package:gym_management_app/features/profile/views/profile_view.dart';
import 'package:gym_management_app/features/general/cubit/gerenal_cubit.dart';
import 'package:gym_management_app/features/general/views/widgets/custom_nav_bar.dart';
import 'package:gym_management_app/features/settings/views/settings_view.dart';
import 'package:gym_management_app/features/subscription/views/subscription_view.dart';

class GerenalView extends StatelessWidget {
  const GerenalView({super.key});

  @override
  Widget build(BuildContext context) {
    final views = const [
      HomeView(),
      SubscriptionView(),
      ProfileView(),
      MarketView(),
      SettingsView(),
    ];

    return BlocBuilder<GerenalCubit, GerenalState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            extendBody: true,
            body: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.backround),

                  fit: BoxFit.cover,
                ),
              ),

              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: SafeArea(
                  child: views[context.read<GerenalCubit>().currentIndex],
                ),
              ),
            ),

            bottomNavigationBar: CustomNavBar(),
          ),
        );
      },
    );
  }
}
