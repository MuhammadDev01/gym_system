import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onTap,
    required this.labelText,
    required this.date,
  });
  final DateTime? initialDate;
  final VoidCallback onTap;
  final String labelText;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: AppColors.gold),
            isDense: true,
            border: OutlineInputBorder(),
          ),
          child: CustomText(text: date, fontSize: 13),
        ),
      ),
    );
  }
}
