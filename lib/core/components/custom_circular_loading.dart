import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class CustomCircularLoading extends StatelessWidget {
  const CustomCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );
  }
}
