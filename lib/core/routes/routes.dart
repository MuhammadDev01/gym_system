import 'package:flutter/material.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/home/views/home_view.dart';
import 'package:gym_management_app/features/market/views/market_view.dart';
import 'package:gym_management_app/features/profile/views/profile_view.dart';
import 'package:gym_management_app/features/general/views/gerenal_view.dart';
import 'package:gym_management_app/features/settings/views/branches_view.dart';
import 'package:gym_management_app/features/settings/views/settings_view.dart';
import 'package:gym_management_app/features/settings/views/subscription_history_view.dart';
import 'package:gym_management_app/features/subscription/views/subscription_view.dart';
import 'package:gym_management_app/features/auth/views/login_view.dart';
import 'package:gym_management_app/features/auth/views/registration_view.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  //view
  AppRoutes.loginView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: LoginView(),
  ),
  AppRoutes.registrationView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: RegistrationView(),
  ),
  AppRoutes.gerenalView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: GerenalView(),
  ),
  AppRoutes.homeView: (_) =>
      const Directionality(textDirection: TextDirection.rtl, child: HomeView()),
  AppRoutes.subscriptionView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: SubscriptionView(),
  ),
  AppRoutes.profileView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: ProfileView(),
  ),
  AppRoutes.marketView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: MarketView(),
  ),
  AppRoutes.settingsView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: SettingsView(),
  ),

  //sub-views
  AppRoutes.branchesSubView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: BranchesView(),
  ),
  AppRoutes.subscriptionHistorySubView: (_) => const Directionality(
    textDirection: TextDirection.rtl,
    child: SubscriptionHistoryView(),
  ),
};
