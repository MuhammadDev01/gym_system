import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_status_icon.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/alerts/data/alert_model.dart';

class AlertListItem extends StatelessWidget {
  const AlertListItem({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final elapsedDays = DateTime.now().difference(alert.createdAt).inDays;
    return GlassWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomStatusIcon(
                color: AppColors.gold,
                icon: Icons.campaign_rounded,
              ),
              const Gap(12),
              Expanded(child: CustomText(text: alert.message, fontSize: 14)),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              CustomText(
                text: 'منذ $elapsedDays يوم',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  text:
                      'متبقي ${alert.expiresAt.difference(DateTime.now()).inDays} يوم',
                  fontSize: 11,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
