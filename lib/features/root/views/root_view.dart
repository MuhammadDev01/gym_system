import 'package:flutter/material.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/admin/views/admin_view.dart';
import 'package:gym_management_app/features/auth/views/auth_view.dart';
import 'package:gym_management_app/features/user/general/views/gerenal_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_isLogin()) return const AuthView();
    final role = LocalCacheService.getString(AppConstants.role);
    if (role == AppConstants.admin) return const AdminView();
    return const GerenalView();
  }

  bool _isLogin() {
    final token = LocalCacheService.getString(AppConstants.token);
    return token != null;
  }
}
