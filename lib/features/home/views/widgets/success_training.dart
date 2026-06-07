import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class SuccessTraining extends StatelessWidget {
  const SuccessTraining({super.key, required this.checkInTime});

  final String checkInTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: ColorsApp.successGreen.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: ColorsApp.successGreen,
            size: 35,
          ),
        ),

        const Gap(16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: 'حالة الحضور اليوم', fontSize: 18),

              const Gap(6),

              CustomText(
                text: 'تم تسجيل حضورك اليوم 💪',
                fontSize: 14,
                color: ColorsApp.gray,
              ),
            ],
          ),
        ),

        const Gap(12),

        _DateSuccessTrain(checkInTime: checkInTime),
      ],
    );
  }
}

class _DateSuccessTrain extends StatelessWidget {
  const _DateSuccessTrain({required this.checkInTime});

  final String checkInTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorsApp.successGreen.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsApp.successGreen.withValues(alpha: .25),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_rounded,
              color: ColorsApp.successGreen,
              size: 18,
            ),

            const Gap(6),

            CustomText(
              text: checkInTime,
              fontSize: 14,
              color: ColorsApp.successGreen,
            ),
          ],
        ),
      ),
    );
  }
}
