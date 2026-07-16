import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class AdminViewHeader extends StatelessWidget {
  const AdminViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GlassWidget(
        borderColor: AppColors.gold,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.logo),
            CustomText(
              text: 'لوحة التحكم',
              fontSize: 24,
              color: AppColors.gold,
            ),
          ],
        ),
      ),
    );
  }
}
