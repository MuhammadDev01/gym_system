import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/features/admin/views/widgets/admin_card.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: GlassWidget(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          Image.asset(AppAssets.logo, height: 80),
                          const Gap(16),
                          const CustomText(
                            text: 'لوحة التحكم',
                            fontSize: 24,
                            color: Color(0xFFFDCD03),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(24),
                AdminCard(
                  icon: Icons.person_add_alt_1,
                  title: 'إضافة عضو جديد',
                  onTap: () => context.push('/admin-view/add-member'),
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.campaign,
                  title: 'إضافة اعلانات',
                  onTap: () {},
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
                  onTap: () {},
                ),
                const Gap(12),
                AdminCard(
                  icon: Icons.home,
                  title: 'العودة للرئيسية',
                  onTap: () => context.go(AppRoutes.gerenalView),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
