import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class GoldLine extends StatelessWidget {
  const GoldLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
