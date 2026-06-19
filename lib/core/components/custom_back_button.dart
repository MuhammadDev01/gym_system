import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Icon(Icons.arrow_back_ios, color: AppColors.gray),
    );
  }
}
