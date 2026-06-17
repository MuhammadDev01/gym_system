import 'package:flutter/material.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/auth/views/auth_view.dart';
import 'package:gym_management_app/features/general/views/gerenal_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return _isLogin() ? GerenalView() : AuthView();
  }

  bool _isLogin() {
    if (LocalCacheService.containsKey(AppConstants.token)) {
      if (LocalCacheService.getString(AppConstants.token) != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
