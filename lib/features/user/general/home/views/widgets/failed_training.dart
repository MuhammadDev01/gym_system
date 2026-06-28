import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';

class FailedTraining extends StatelessWidget {
  const FailedTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: const CustomText(
        text: 'لم يتم تسجيل حضورك اليوم',
        fontSize: 12,

        color: Colors.white70,
      ),
    );
  }
}
