import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  // views
  static const String authView = '/auth-view';
  static const String adminView = '/admin-view';
  static const String addMemberView = '/add-member-view';
  static const String membersListView = '/members-list-view';
  static const String gerenalView = '/gerenal-view';
  static const String homeView = '/home-view';
  static const String subscriptionView = '/subscription-view';
  static const String profileView = '/profile-view';
  static const String marketView = '/market-view';
  static const String settingsView = '/settings-view';
  static const String rootView = '/';

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
