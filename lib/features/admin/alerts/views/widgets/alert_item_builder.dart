import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class AlertItemBuilder extends StatelessWidget {
  const AlertItemBuilder({super.key, required this.alert});
  final AlertModel alert;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassWidget(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.campaign, size: 20, color: AppColors.gold),
                const Gap(8),
                Expanded(
                  child: CustomText(text: alert.message, color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: alert.isExpired
                        ? AppColors.snackError
                        : AppColors.gold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text: alert.isExpired ? 'منتهي' : 'نشط',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                CustomText(
                  text:
                      'من: ${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year}',
                ),
                const Spacer(),
                CustomText(
                  text:
                      'إلى: ${alert.expiresAt.day}/${alert.expiresAt.month}/${alert.expiresAt.year}',
                  color: alert.isExpired
                      ? AppColors.snackError
                      : AppColors.gold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
