import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/settings/views/widgets/update_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    await Future.delayed(const Duration(seconds: 2));
    final token = LocalCacheService.getString(AppConstants.token);
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.go(AppRoutes.authView),
      );
      return;
    }
    final role = LocalCacheService.getString(AppConstants.role);

    await _checkForUpdate();

    if (!context.mounted) return;
    if (role == AppConstants.admin) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.go(AppRoutes.adminView),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.go(AppRoutes.gerenalView),
      );
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final doc = await getIt<FirebaseService>().getDocument(
        collection: 'settings',
        docId: 'update_info',
      );
      if (!doc.exists) return;

      final info = await PackageInfo.fromPlatform();
      final latestBuild = doc['buildNumber'] as int? ?? 0;
      final currentBuild = int.tryParse(info.buildNumber) ?? 0;

      if (latestBuild <= currentBuild) return;

      final message = doc['message'] as String? ?? '';
      final forceUpdate = doc['forceUpdate'] as bool? ?? false;

      if (context.mounted) {
        await showUpdateDialog(context, message: message, forceUpdate: forceUpdate);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final size = MediaQuery.sizeOf(context);
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent.withValues(alpha: 0.6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.logo,
                fit: BoxFit.cover,
                cacheWidth: (size.width * dpr).round(),
                cacheHeight: (300 * dpr).round(),
              ),
              const Gap(48),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) => Transform.rotate(
                  angle: _controller.value * pi * 2,
                  child: child,
                ),
                child: DecoratedIcon(
                  icon: const Icon(
                    Icons.fitness_center,
                    color: AppColors.gold,
                    size: 50,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(
                      color: AppColors.black,
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
