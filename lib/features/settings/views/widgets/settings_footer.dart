import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorsApp.gold.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColorsApp.gold.withValues(alpha: .2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, color: ColorsApp.gold, size: 20),
              const Gap(8),
              CustomText(
                text: 'إدارة كابتن محمد خالد',
                fontSize: 14,
                color: ColorsApp.gold,
              ),
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
