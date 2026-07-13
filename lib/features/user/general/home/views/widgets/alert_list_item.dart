import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_status_icon.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';

class AlertListItem extends StatelessWidget {
  const AlertListItem({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final remaining = alert.expiresAt.difference(DateTime.now());
    final remainingText = remaining.inDays > 0
        ? 'متبقي ${remaining.inDays} يوم'
        : remaining.inHours > 0
            ? 'متبقي ${remaining.inHours} ساعة'
            : 'آخر يوم';
    return GlassWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomText(
              text: remainingText,
              fontSize: 10,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
