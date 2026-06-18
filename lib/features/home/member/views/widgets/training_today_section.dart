import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/features/home/member/views/widgets/failed_training.dart';
import 'package:gym_management_app/features/home/member/views/widgets/success_training.dart';

class TrainingTodaySection extends StatelessWidget {
  const TrainingTodaySection({super.key, required this.isAttendToday});

  final bool isAttendToday;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(text: 'حالة الحضور اليوم'),
          Gap(12),
          isAttendToday ? SuccessTraining() : FailedTraining(),
        ],
      ),
    );
  }
}
