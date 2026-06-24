import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/views/admin_view.dart';
import 'package:gym_management_app/features/admin/views/daily_qr_view.dart';
import 'package:gym_management_app/features/auth/views/splash_view.dart';
import 'package:gym_management_app/features/alerts/views/add_alert_view.dart';
import 'package:gym_management_app/features/alerts/views/alerts_management_view.dart';
import 'package:gym_management_app/features/alerts/views/alerts_view.dart';
import 'package:gym_management_app/features/alerts/views/edit_alert_view.dart';
import 'package:gym_management_app/features/market/views/admin/add_item_on_market_view.dart';
import 'package:gym_management_app/features/market/views/admin/edit_item_on_market_view.dart';
import 'package:gym_management_app/features/market/views/admin/market_items_list_view.dart';
import 'package:gym_management_app/features/market/views/admin/market_management_view.dart';
import 'package:gym_management_app/features/market/views/user/market_item_detail_view.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/members/views/add_member_view.dart';
import 'package:gym_management_app/features/members/views/edit_member_view.dart';
import 'package:gym_management_app/features/members/views/members_list_view.dart';
import 'package:gym_management_app/features/members/views/members_management_view.dart';
import 'package:gym_management_app/features/members/views/scan_member_view.dart';
import 'package:gym_management_app/features/auth/views/auth_view.dart';
import 'package:gym_management_app/features/user/general/views/gerenal_view.dart';
import 'package:gym_management_app/features/user/general/home/views/home_view.dart';
import 'package:gym_management_app/features/market/views/user/market_view.dart';
import 'package:gym_management_app/features/user/profile/views/profile_view.dart';
import 'package:gym_management_app/features/user/settings/views/branches_view.dart';
import 'package:gym_management_app/features/user/settings/views/settings_view.dart';
import 'package:gym_management_app/features/user/settings/views/subscription_history_view.dart';
import 'package:gym_management_app/features/user/subscription/views/subscription_view.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.splashView,
  debugLogDiagnostics: true,
  routes: [
    //* Splash
    GoRoute(
      path: AppRoutes.splashView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashView(),
      ),
    ),
    //*main
    GoRoute(
      path: AppRoutes.authView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AuthView(),
      ),
    ),
    //*Main
    GoRoute(
      path: AppRoutes.adminView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AdminView(),
      ),
    ),

    //*Members
    GoRoute(
      path: AppRoutes.membersManagementView,
      builder: (_, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: MembersManagementView(),
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
      path: AppRoutes.editMemberView,
      builder: (_, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: EditMemberView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.membersListView,
      builder: (_, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: MembersListView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.scanMemberView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: ScanMemberView(),
      ),
    ),
    //* Alerts
    GoRoute(
      path: AppRoutes.alertsManagementView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AlertsManagementView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addAlertView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AddAlertView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editAlertView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: EditAlertView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.alertsListView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AlertsListView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.alertsView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AlertsManagementView(),
      ),
    ),

    //* Market
    GoRoute(
      path: AppRoutes.marketManagementView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: MarketManagementView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addItemOnMarketView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: AddItemOnMarketView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editItemOnMarketView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: EditItemOnMarketView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.marketItemsListView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: MarketItemsListView(),
      ),
    ),

    GoRoute(
      path: AppRoutes.dailyQrView,
      builder: (_, _) => const Directionality(
        textDirection: TextDirection.rtl,
        child: DailyQrView(),
      ),
    ),

    //* User
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
      path: AppRoutes.marketItemDetailView,
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 400),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MarketItemDetailView(item: state.extra as MarketItemModel),
        ),
        transitionsBuilder: (_, animation, _, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        ),
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
