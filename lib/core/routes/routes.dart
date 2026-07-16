import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_shell.dart';
import 'package:gym_management_app/features/admin/dashboard/views/admin_dashboard_view.dart';
import 'package:gym_management_app/features/auth/views/splash_view.dart';
import 'package:gym_management_app/features/admin/alerts/views/add_alert_view.dart';
import 'package:gym_management_app/features/admin/alerts/views/alerts_management_view.dart';
import 'package:gym_management_app/features/admin/alerts/views/alerts_view.dart';
import 'package:gym_management_app/features/admin/alerts/views/edit_alert_view.dart';
import 'package:gym_management_app/features/admin/market/views/add_item_on_market_view.dart';
import 'package:gym_management_app/features/admin/market/views/edit_item_on_market_view.dart';
import 'package:gym_management_app/features/admin/market/views/market_admin_view.dart';
import 'package:gym_management_app/features/admin/market/views/market_management_view.dart';
import 'package:gym_management_app/features/user/market/views/market_item_detail_view.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';
import 'package:gym_management_app/features/admin/members/views/add_member_view.dart';
import 'package:gym_management_app/features/admin/members/views/edit_member_view.dart';
import 'package:gym_management_app/features/admin/members/views/members_list_view.dart';
import 'package:gym_management_app/features/admin/members/views/members_management_view.dart';
import 'package:gym_management_app/features/admin/members/views/monthly_subscription_view.dart';
import 'package:gym_management_app/features/admin/members/views/scan_member_view.dart';
import 'package:gym_management_app/features/admin/members/views/admin_attendance_view.dart';
import 'package:gym_management_app/features/admin/members/views/admin_attendance_history_view.dart';
import 'package:gym_management_app/features/auth/views/auth_view.dart';
import 'package:gym_management_app/features/user/general/views/gerenal_view.dart';
import 'package:gym_management_app/features/user/general/home/views/home_view.dart';
import 'package:gym_management_app/features/user/market/views/market_user_view.dart';
import 'package:gym_management_app/features/user/profile/views/profile_view.dart';
import 'package:gym_management_app/features/user/settings/views/branches_view.dart';
import 'package:gym_management_app/features/user/settings/views/settings_view.dart';
import 'package:gym_management_app/features/user/settings/views/subscription_history_view.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_cubit.dart';
import 'package:gym_management_app/features/admin/settings/views/prices_view.dart';
import 'package:gym_management_app/features/user/subscription/views/subscription_view.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.splashView,
  debugLogDiagnostics: true,
  routes: [
    //* Splash
    GoRoute(
      path: AppRoutes.splashView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.splashView,
        pageView: SplashView(),
      ),
    ),
    //* Auth
    GoRoute(
      path: AppRoutes.authView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.authView,
        pageView: AuthView(),
      ),
    ),
    //* Admin shell — provides AdminShell (MemberCubit, AlertAdminCubit, MarketAdminCubit)
    ShellRoute(
      builder: (_, _, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.adminView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.adminView,
            pageView: AdminDashboardView(),
          ),
        ),
        //* Members
        GoRoute(
          path: AppRoutes.membersManagementView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.membersManagementView,
            pageView: MembersManagementView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addMemberView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.addMemberView,
            pageView: AddMemberView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.editMemberView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.editMemberView,
            pageView: EditMemberView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.membersListView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.membersListView,
            pageView: MembersListView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.scanMemberView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.scanMemberView,
            pageView: ScanMemberView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.adminAttendanceView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.adminAttendanceView,
            pageView: AdminAttendanceView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.adminAttendanceHistoryView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.adminAttendanceHistoryView,
            pageView: AdminAttendanceHistoryView(),
          ),
        ),
        //* Alerts
        GoRoute(
          path: AppRoutes.alertsManagementView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.alertsManagementView,
            pageView: AlertsManagementView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addAlertView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.addAlertView,
            pageView: AddAlertView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.editAlertView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.editAlertView,
            pageView: EditAlertView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.alertsListView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.alertsListView,
            pageView: AlertsListView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.alertsView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.alertsView,
            pageView: AlertsManagementView(),
          ),
        ),
        //* Market
        GoRoute(
          path: AppRoutes.marketManagementView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.marketManagementView,
            pageView: MarketManagementView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addItemOnMarketView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.addItemOnMarketView,
            pageView: AddItemOnMarketView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.editItemOnMarketView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.editItemOnMarketView,
            pageView: EditItemOnMarketView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.marketItemsListView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.marketItemsListView,
            pageView: MarketAdminView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.subscriptionHistoryView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.subscriptionHistoryView,
            pageView: SubscriptionHistoryView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.monthlySubscriptionView,
          pageBuilder: (_, _) => _customAnimteMothlySubscriptionView(),
        ),
        GoRoute(
          path: AppRoutes.pricesView,
          pageBuilder: (_, _) => _customAnimatePushRoutePage(
            pageKey: AppRoutes.pricesView,
            pageView: const PricesView(),
          ),
        ),
      ],
    ),
    //* User
    GoRoute(
      path: AppRoutes.gerenalView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.gerenalView,
        pageView: GerenalView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.homeView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.homeView,
        pageView: HomeView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.subscriptionView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.subscriptionView,
        pageView: BlocProvider(
          create: (_) => getIt<PricesCubit>(),
          child: SubscriptionView(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.profileView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.profileView,
        pageView: ProfileView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.marketView,
      pageBuilder: (_, _) => _customAnimatePushRoutePage(
        pageKey: AppRoutes.marketView,
        pageView: MarketUserView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.marketItemDetailView,
      pageBuilder: (_, state) => _customAnimateMarketDetailsView(state),
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
  ],
);

CustomTransitionPage<dynamic> _customAnimteMothlySubscriptionView() {
  return CustomTransitionPage(
    key: const ValueKey('monthly-subscription'),
    transitionDuration: const Duration(milliseconds: 400),
    child: const Directionality(
      textDirection: TextDirection.rtl,
      child: MonthlySubscriptionView(),
    ),
    transitionsBuilder: (_, animation, _, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}

//! METHODS

CustomTransitionPage<dynamic> _customAnimateMarketDetailsView(
  GoRouterState state,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 400),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: MarketItemDetailView(item: state.extra as MarketItemModel),
    ),
    transitionsBuilder: (_, animation, _, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}

CustomTransitionPage<dynamic> _customAnimatePushRoutePage({
  required String pageKey,
  required Widget pageView,
}) {
  return CustomTransitionPage(
    key: ValueKey(pageKey),
    child: Directionality(textDirection: TextDirection.rtl, child: pageView),
    transitionsBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
