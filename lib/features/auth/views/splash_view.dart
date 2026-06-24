import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_decoration/icon_decoration.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final token = LocalCacheService.getString(AppConstants.token);
    if (token == null) {
      context.go(AppRoutes.authView);
      return;
    }
    final role = LocalCacheService.getString(AppConstants.role);
    if (role == AppConstants.admin) {
      context.go(AppRoutes.adminView);
    } else {
      context.go(AppRoutes.gerenalView);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent.withValues(alpha: 0.6),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.logo),
              const SizedBox(height: 48),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) => Transform.rotate(
                  angle: _controller.value * 6.28,
                  child: child,
                ),
                child: DecoratedIcon(
                  icon: Icon(
                    Icons.fitness_center,
                    color: AppColors.gold,
                    size: 50,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(
                      color: AppColors.black, // لون إطار الأيقونة
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
