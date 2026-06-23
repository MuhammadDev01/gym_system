import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_status_icon.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/features/alerts/data/alert_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/features/alerts/data/alert_repo.dart';

class AlertSection extends StatelessWidget {
  const AlertSection({super.key, required List<String> alerts});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AlertModel>>(
      stream: getIt<AlertRepo>().getActiveAlerts(),
      builder: (_, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final alerts = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "تنبيهات من الكابتن",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              separatorBuilder: (_, _) => const Gap(12),
              itemBuilder: (_, index) {
                return AlertItem(message: alerts[index].message);
              },
            ),
          ],
        );
      },
    );
  }
}

class AlertItem extends StatelessWidget {
  const AlertItem({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomStatusIcon(color: AppColors.gold, icon: Icons.campaign_rounded),
          const Gap(12),
          Expanded(
            child: CustomText(
              text: message,
              fontSize: 14,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
