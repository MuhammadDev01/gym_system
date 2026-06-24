import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_card.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_view_header.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: CustomText(
          text: 'تسجيل الخروج',
          fontSize: 18,
          textAlign: TextAlign.center,
        ),
        content: CustomText(
          text: 'هل أنت متأكد من تسجيل الخروج؟',
          textAlign: TextAlign.center,
          color: AppColors.gray.withValues(alpha: 0.5),
        ),
        actions: [
          CustomButton(onPressed: () => context.pop(), text: 'إلغاء'),

          CustomButton(
            colorButton: AppColors.snackError,
            colorText: Colors.white,
            onPressed: () {
              context.pop();
              context.read<AuthCubit>().logout();
            },
            text: 'تسجيل الخروج',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (_, state) {
        if (state is AuthLogoutedState) {
          context.go(AppRoutes.authView);
        }
      },
      builder: (_, state) => AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomLoadingOverlay(
            isLoading: state is AuthLoadingState,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: Column(
                  children: [
                    AdminViewHeader(),
                    const Gap(24),
                    AdminCard(
                      icon: FontAwesomeIcons.usersGear,
                      title: 'إدارة المشتركين',
                      onTap: () =>
                          context.push(AppRoutes.membersManagementView),
                    ),
                    const Gap(12),
                    AdminCard(
                      icon: FontAwesomeIcons.bullhorn,
                      title: 'إدارة الإعلانات',
                      onTap: () => context.push(AppRoutes.alertsManagementView),
                    ),
                    const Gap(12),
                  AdminCard(
                    icon: FontAwesomeIcons.shop,
                    title: 'إدارة المتجر',
                    onTap: () => context.push(AppRoutes.marketManagementView),
                  ),
                  const Gap(12),
                  AdminCard(
                    icon: FontAwesomeIcons.qrcode,
                    title: 'باركود تسجيل الحضور',
                    onTap: () => context.push(AppRoutes.dailyQrView),
                  ),
                  const Gap(12),
                  AdminCard(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      title: 'تسجيل الخروج',
                      onTap: () => _confirmLogout(context),
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
