import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        appBar: GlassAppBar(title: 'ادارة المشتركين'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 24,
            children: [
              AdminCard(
                icon: FontAwesomeIcons.userPlus,
                title: 'إضافة مشترك جديد',
                onTap: () => context.push(AppRoutes.addMemberView),
              ),
              AdminCard(
                icon: FontAwesomeIcons.userPen,
                title: 'تعديل بيانات مشترك',
                onTap: () => context.push(AppRoutes.editMemberView),
              ),
              AdminCard(
                icon: FontAwesomeIcons.calendarCheck,
                title: 'تسجيل حضور',
                onTap: () => context.push(AppRoutes.adminAttendanceView),
              ),
              AdminCard(
                icon: FontAwesomeIcons.clockRotateLeft,
                title: 'سجل الحضور',
                onTap: () => context.push(AppRoutes.adminAttendanceHistoryView),
              ),
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
