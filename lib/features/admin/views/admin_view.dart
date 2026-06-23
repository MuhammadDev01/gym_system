import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_card.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_view_header.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              children: [
                AdminViewHeader(),
                const Gap(24),
                AdminCard(
                  icon: FontAwesomeIcons.usersGear,
                  title: 'إدارة المشتركين',
                  onTap: () => context.push(AppRoutes.membersManagementView),
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
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                  title: 'تسجيل الخروج',
                  onTap: () {},
                  color: AppColors.snackError,
                  iconColor: AppColors.snackError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
