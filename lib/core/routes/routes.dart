import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/auth/views/auth_view.dart';
import 'package:gym_management_app/features/auth/views/login_view.dart';
import 'package:gym_management_app/features/auth/views/register_view.dart';
import 'package:gym_management_app/features/general/views/gerenal_view.dart';
import 'package:gym_management_app/features/home/views/home_view.dart';
import 'package:gym_management_app/features/market/views/market_view.dart';
import 'package:gym_management_app/features/profile/views/profile_view.dart';
import 'package:gym_management_app/features/root/views/root_view.dart';
import 'package:gym_management_app/features/settings/views/branches_view.dart';
import 'package:gym_management_app/features/settings/views/settings_view.dart';
import 'package:gym_management_app/features/settings/views/subscription_history_view.dart';
import 'package:gym_management_app/features/subscription/views/subscription_view.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.rootView,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.authView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AuthView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginView,
      builder: (_, _) =>
          Directionality(textDirection: TextDirection.rtl, child: LoginView()),
    ),
    GoRoute(
      path: AppRoutes.registerView,
      builder: (_, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: RegisterView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.rootView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: RootView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.gerenalView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: GerenalView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.homeView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.subscriptionView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: SubscriptionView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.profileView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: ProfileView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.marketView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: MarketView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.settingsView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: SettingsView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.branchesSubView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: BranchesView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.subscriptionHistorySubView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: SubscriptionHistoryView(),
      ),
    ),
  ],
);
