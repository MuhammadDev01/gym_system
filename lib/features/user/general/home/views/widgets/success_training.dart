import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class SuccessTraining extends StatelessWidget {
  const SuccessTraining({super.key, this.lastAttendance});

  final DateTime? lastAttendance;

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final time =
        lastAttendance != null ? _formatTime(lastAttendance!) : null;
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: 'تم تسجيل حضورك اليوم 💪',
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        if (time != null) ...[
          const Gap(12),
          _DateSuccessTrain(checkInTime: time),
        ],
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
            Icon(Icons.access_time_rounded, color: AppColors.success, size: 18),
            const Gap(6),
            CustomText(
              text: checkInTime,
              fontSize: 14,
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}
