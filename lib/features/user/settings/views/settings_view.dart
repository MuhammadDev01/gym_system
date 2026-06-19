import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/logout_button.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_footer.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_item.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin =
        LocalCacheService.getString(AppConstants.role) == AppConstants.admin;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isAdmin) ...[
          NavCard(
            title: 'لوحة التحكم',
            icon: Icons.admin_panel_settings,
            onTap: () => context.push(AppRoutes.adminView),
          ),
          const Gap(12),
        ],
        NavCard(
          title: 'فروع الجيم',
          icon: Icons.location_on,
          onTap: () => context.push(AppRoutes.branchesSubView),
        ),
        const Gap(12),
        NavCard(
          title: 'سجل الاشتراكات',
          icon: Icons.history,
          onTap: () => context.push(AppRoutes.subscriptionHistorySubView),
        ),
        const Gap(12),
        NavCard(
          title: 'الانضمام لجروب الجيم',
          icon: Icons.groups,
          onTap: () => launchUrlString(
            'https://chat.whatsapp.com/LLywZ8vUQRs9b7CgjFYF3F',
            mode: LaunchMode.externalApplication,
          ),
        ),
        const Gap(12),
        NavCard(
          title: 'التواصل مع الكابتن',
          icon: Icons.chat,
          onTap: () => launchUrlString(
            'https://chat.whatsapp.com/LLywZ8vUQRs9b7CgjFYF3F',
            mode: LaunchMode.externalApplication,
          ),
        ),
        const Gap(30),
        const LogoutButton(),
        const Gap(24),
        const SettingsFooter(),
      ],
    );
  }
}
