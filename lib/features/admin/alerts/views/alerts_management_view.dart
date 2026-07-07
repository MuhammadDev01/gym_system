import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_card.dart';

class AlertsManagementView extends StatelessWidget {
  const AlertsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'إدارة الإعلانات'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.squarePlus,
                title: 'إضافة إعلان جديد',
                onTap: () => context.push(AppRoutes.addAlertView),
              ),
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.penToSquare,
                title: 'تعديل إعلان',
                onTap: () => context.push(AppRoutes.editAlertView),
              ),
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.list,
                title: 'قائمة الإعلانات',
                onTap: () => context.push(AppRoutes.alertsListView),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
