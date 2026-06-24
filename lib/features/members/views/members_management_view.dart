import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_card.dart';

class MembersManagementView extends StatelessWidget {
  const MembersManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(
          title: 'ادارة المشتركين',
          actions: [
            IconButton(
              onPressed: () => context.push(AppRoutes.scanMemberView),
              icon: FaIcon(FontAwesomeIcons.qrcode),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.userPlus,
                title: 'إضافة مشترك جديد',
                onTap: () => context.push(AppRoutes.addMemberView),
              ),
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.userPen,
                title: 'تعديل بيانات مشترك',
                onTap: () => context.push(AppRoutes.editMemberView),
              ),
              const Gap(24),
              AdminCard(
                icon: FontAwesomeIcons.users,
                title: 'قائمة المشتركين',
                onTap: () => context.push(AppRoutes.membersListView),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
