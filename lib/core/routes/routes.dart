import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/views/add_member_view.dart';
import 'package:gym_management_app/features/admin/views/admin_view.dart';
import 'package:gym_management_app/features/admin/views/advertisements_view.dart';
import 'package:gym_management_app/features/admin/views/members_list_view.dart';
import 'package:gym_management_app/features/auth/views/auth_view.dart';
import 'package:gym_management_app/features/user/general/views/gerenal_view.dart';
import 'package:gym_management_app/features/user/general/home/views/home_view.dart';
import 'package:gym_management_app/features/user/market/views/market_view.dart';
import 'package:gym_management_app/features/user/profile/views/profile_view.dart';
import 'package:gym_management_app/features/root/views/root_view.dart';
import 'package:gym_management_app/features/user/settings/views/branches_view.dart';
import 'package:gym_management_app/features/user/settings/views/settings_view.dart';
import 'package:gym_management_app/features/user/settings/views/subscription_history_view.dart';
import 'package:gym_management_app/features/user/subscription/views/subscription_view.dart';

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
      path: AppRoutes.rootView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: RootView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.adminView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AdminView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addMemberView,
      builder: (_, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: AddMemberView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.memberListView,
      builder: (_, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: MemberListView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.advertisementsView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AdvertisementsView(),
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
