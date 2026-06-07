import 'package:flutter/material.dart';
import 'package:gym_management_app/features/home/views/widgets/failed_training.dart';
import 'package:gym_management_app/features/home/views/widgets/success_training.dart';

class TrainingTodaySection extends StatelessWidget {
  const TrainingTodaySection({super.key, required this.isAttendToday});

  final bool isAttendToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: isAttendToday
          ? SuccessTraining(checkInTime: "7.34 AM")
          : FailedTraining(onScanPressed: () {}),
    );
  }
}
