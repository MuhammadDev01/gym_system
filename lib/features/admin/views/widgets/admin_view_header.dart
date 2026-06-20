import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class AdminViewHeader extends StatelessWidget {
  const AdminViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Image.asset(AppAssets.logo, height: 80),
          const Gap(16),
          CustomText(text: 'لوحة التحكم', fontSize: 24, color: AppColors.gold),
        ],
      ),
    );
  }
}
