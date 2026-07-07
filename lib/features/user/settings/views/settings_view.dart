import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/user/settings/cubit/settings_cubit.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/logout_button.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_footer.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_item.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>(),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLogoutedState) {
            context.go(AppRoutes.authView, extra: true);
          }
        },
        builder: (context, state) {
          return CustomLoadingOverlay(
            isLoading: state is SettingsLoadingState,
            child: SingleChildScrollView(
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
                      const LogoutButton(),
                      const Gap(60),
                      const SettingsFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
