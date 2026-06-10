import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class SuccessTraining extends StatelessWidget {
  const SuccessTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: 'تم تسجيل حضورك اليوم 💪',
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const Gap(12),
        _DateSuccessTrain(checkInTime: "7.34 AM"),
      ],
    );
  }
}

class _DateSuccessTrain extends StatelessWidget {
  const _DateSuccessTrain({required this.checkInTime});

  final String checkInTime;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: EdgeInsets.all(6),
      borderRaduis: 8,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_rounded, color: ColorsApp.success, size: 18),
            const Gap(6),
            CustomText(
              text: checkInTime,
              fontSize: 14,
              color: ColorsApp.success,
            ),
          ],
        ),
      ),
    );
  }
}
