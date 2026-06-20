import 'package:flutter/material.dart';
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
                  icon: Icons.person_add_alt_1,
                  title: 'المشتركين',
                  onTap: () => context.push(AppRoutes.memberListView),
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.campaign,
                  title: 'الإعلانات',
                  onTap: () => context.push(AppRoutes.alertsView),
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.inventory_2,
                  title: 'إضافة ادوات و مكملات',
                  onTap: () {},
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.timer_outlined,
                  title: 'تمديد اشتراك',
                  onTap: () {},
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.people,
                  title: 'قائمة الأعضاء',
                  onTap: () => context.push(AppRoutes.memberListView),
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.logout,
                  title: 'تسجيل الخروج',
                  onTap: () => context.go(AppRoutes.gerenalView),
                  color: AppColors.snackError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
