import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  // views
  static const String splashView = '/';
  static const String authView = '/auth-view';
  //admin
  static const String adminView = '/admin-view';
  //members
  static const String addMemberView = '/add-member-view';
  static const String membersManagementView = '/members-management-list-view';
  static const String scanMemberView = '/scan-member-view';
  static const String editMemberView = '/edit-member-view';
  static const String membersListView = '/members-list-view';
  static const String adminAttendanceView = '/admin-attendance-view';
  static const String adminAttendanceHistoryView =
      '/admin-attendance-history-view';
  //alerts
  static const String alertsView = '/alerts-view';
  static const String alertsManagementView = '/alerts-management-view';
  static const String addAlertView = '/add-alert-view';
  static const String editAlertView = '/edit-alert-view';
  static const String alertsListView = '/alerts-list-view';
  //market
  static const String marketManagementView = '/market-management-view';
  static const String addItemOnMarketView = '/add-item-on-market-view';
  static const String editItemOnMarketView = '/edit-item-on-market-view';
  static const String marketItemsListView = '/market-items-list-view';

  //user
  static const String gerenalView = '/gerenal-view';
  static const String homeView = '/home-view';
  static const String subscriptionView = '/subscription-view';
  static const String profileView = '/profile-view';
  static const String marketView = '/market-view';
  static const String marketItemDetailView = '/market-item-detail-view';
  static const String settingsView = '/settings-view';

  //intenral views
  static const String branchesSubView = '/branches-sub-view';
  static const String subscriptionHistorySubView =
      '/subscription-history-sub-view';

  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  static void printCurrentRoute(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    log('📍 Current Route: $path');
  }
}
