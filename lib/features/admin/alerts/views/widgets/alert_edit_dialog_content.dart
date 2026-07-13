import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_cubit.dart';

class AlertEditDialogContent extends StatelessWidget {
  const AlertEditDialogContent({super.key, required this.cubit});
  final AlertAdminCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: cubit.editMessageController,
          hintText: 'نص الإعلان',
          maxLines: 3,
        ),
        CustomText(
          color: AppColors.textSecondary,
          text:
              'ينتهي في: ${cubit.alertEndDate!.year}/${cubit.alertEndDate!.month}/${cubit.alertEndDate!.day} ',
        ),
        DropdownButtonFormField<Duration>(
          initialValue: cubit.editExtendDuration,
          dropdownColor: AppColors.surface,
          decoration: InputDecoration(
            labelText: 'تمديد مدة الإعلان',
            labelStyle: TextStyle(color: AppColors.gold),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gold),
            ),
          ),
          items:
              const [
                MapEntry(Duration.zero, 'لا تمديد'),
                MapEntry(Duration(hours: 2), 'ساعتين'),
                MapEntry(Duration(hours: 4), 'اربع ساعات'),
                MapEntry(Duration(hours: 12), 'نص يوم'),
                MapEntry(Duration(days: 1), 'يوم'),
                MapEntry(Duration(days: 2), 'يومين'),
                MapEntry(Duration(days: 3), 'تلات ايام'),
                MapEntry(Duration(days: 7), 'اسبوع'),
              ].map((e) {
                return DropdownMenuItem(
                  value: e.key,
                  child: CustomText(text: e.value),
                );
              }).toList(),
          onChanged: (v) {
            if (v != null) cubit.setEditExtendDuration(v);
          },
        ),
      ],
    );
  }
}
