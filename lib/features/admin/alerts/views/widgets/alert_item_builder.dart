import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class AlertItemBuilder extends StatelessWidget {
  const AlertItemBuilder({super.key, required this.alert});
  final AlertModel alert;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: const EdgeInsets.all(16),
      borderRaduis: 12,
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                spacing: 8,
                children: [
                  const Icon(Icons.campaign, size: 20, color: AppColors.gold),
                  CustomText(text: alert.message),
                ],
              ),
              CustomText(
                text:
                    'ينتهي في:  ${alert.expiresAt.year}/${alert.expiresAt.month}/${alert.expiresAt.day} | ${alert.expiresAt.hour.toString().padLeft(2, '0')}:${alert.expiresAt.minute.toString().padLeft(2, '0')}',
                color: alert.isExpired
                    ? AppColors.snackError
                    : AppColors.textSecondary,
              ),
            ],
          ),
          GlassWidget(
            borderRaduis: 4,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: CustomText(
              text: alert.isExpired ? 'منتهي' : 'نشط',
              color: alert.isExpired ? AppColors.snackError : AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
