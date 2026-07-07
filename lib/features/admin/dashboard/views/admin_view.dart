import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_card.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_view_header.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutedState) {
          context.go(AppRoutes.authView);
        }
      },
      builder: (context, state) => AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomLoadingOverlay(
              isLoading: state is AuthLoadingState,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  spacing: 24,
                  children: [
                    AdminViewHeader(),
                    AdminCard(
                      icon: FontAwesomeIcons.usersGear,
                      title: 'إدارة المشتركين',
                      onTap: () =>
                          context.push(AppRoutes.membersManagementView),
                    ),
                    AdminCard(
                      icon: FontAwesomeIcons.bullhorn,
                      title: 'إدارة الإعلانات',
                      onTap: () => context.push(AppRoutes.alertsManagementView),
                    ),
                    AdminCard(
                      icon: FontAwesomeIcons.shop,
                      title: 'إدارة المتجر',
                      onTap: () => context.push(AppRoutes.marketManagementView),
                    ),
                    AdminCard(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      title: 'تسجيل الخروج',
                      onTap: () => onConfirmLogout(
                        context,
                        onConfirm: () async {
                          context.pop();
                          await context.read<AuthCubit>().logoutAdmin();
                        },
                      ),
                      color: AppColors.snackError,
                      iconColor: AppColors.snackError,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
