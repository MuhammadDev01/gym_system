import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_card.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_logout_button.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_view_header.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              spacing: 24,
              children: [
                AdminViewHeader(),
                AdminCard(
                  icon: FontAwesomeIcons.usersGear,
                  title: 'إدارة المشتركين',
                  onTap: () => context.push(AppRoutes.membersManagementView),
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
                  icon: FontAwesomeIcons.cloudArrowUp,
                  title: 'نشر تحديث',
                  onTap: () => context.push(AppRoutes.publishUpdateView),
                ),
                AdminLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
