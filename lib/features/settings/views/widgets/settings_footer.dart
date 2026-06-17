import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassWidget(
          padding: EdgeInsets.all(16),
          borderRaduis: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, color: AppColors.gold, size: 20),
              const Gap(8),
              CustomText(text: 'إدارة كابتن محمد خالد', color: AppColors.gold),
            ],
          ),
        ),
        const Gap(12),
        const CustomText(
          text: 'جميع الحقوق محفوظة © KongiGym 2026',
          fontSize: 12,
          color: Colors.white38,
        ),
      ],
    );
  }
}
