import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/logout_button.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_footer.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_item.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 12,
            children: [
              Gap(16),
              NavCard(
                title: 'فروع الجيم',
                icon: Icons.location_on,
                onTap: () => context.push(AppRoutes.branchesSubView),
              ),
              NavCard(
                title: 'سجل الاشتراكات',
                icon: Icons.history,
                onTap: () => context.push(AppRoutes.subscriptionHistorySubView),
              ),
              NavCard(
                title: 'الانضمام لجروب الجيم',
                icon: Icons.groups,
                onTap: () => launchUrlString(
                  'https://chat.whatsapp.com/LLywZ8vUQRs9b7CgjFYF3F',
                  mode: LaunchMode.externalApplication,
                ),
              ),
              NavCard(
                title: 'التواصل مع الادمن',
                icon: Icons.admin_panel_settings,
                onTap: () => launchUrlString(
                  'https://chat.whatsapp.com/LLywZ8vUQRs9b7CgjFYF3F',
                  mode: LaunchMode.externalApplication,
                ),
              ),
              const Gap(30),
              const LogoutButton(),
              const Gap(60),
              const SettingsFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
