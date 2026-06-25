import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/user/general/home/views/home_view.dart';
import 'package:gym_management_app/features/market/views/user/market_user_view.dart';
import 'package:gym_management_app/features/user/profile/views/profile_view.dart';
import 'package:gym_management_app/features/user/general/cubit/gerenal_cubit.dart';
import 'package:gym_management_app/features/user/general/views/widgets/custom_nav_bar.dart';
import 'package:gym_management_app/features/user/settings/views/settings_view.dart';
import 'package:gym_management_app/features/user/subscription/views/subscription_view.dart';

class GerenalView extends StatelessWidget {
  GerenalView({super.key});

  final views = [
    HomeView(),
    SubscriptionView(),
    ProfileView(),
    MarketUserView(),
    SettingsView(),
  ];
  @override
  Widget build(BuildContext context) {
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
                  image: AssetImage(AppAssets.backround),
                  fit: BoxFit.cover,
                ),
              ),

              child: views[context.read<GerenalCubit>().currentIndex],
            ),

            bottomNavigationBar: CustomNavBar(),
          ),
        );
      },
    );
  }
}
