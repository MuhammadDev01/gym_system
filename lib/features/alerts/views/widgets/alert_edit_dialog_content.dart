import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_cubit.dart';

class AlertEditDialogContent extends StatelessWidget {
  const AlertEditDialogContent({super.key, required this.cubit});
  final AlertAdminCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: cubit.editMessageController,
          hintText: 'نص الإعلان',
          maxLines: 3,
        ),
        const Gap(12),
        CustomText(
          text:
              'ينتهي في: ${cubit.alertEndDate!.day}/${cubit.alertEndDate!.month}/${cubit.alertEndDate!.year}',
        ),
        const Gap(12),
        DropdownButtonFormField<int>(
          initialValue: cubit.editExtendDays,
          dropdownColor: AppColors.surface,
          decoration: InputDecoration(
            labelText: 'تمديد (أيام إضافية)',
            labelStyle: TextStyle(color: AppColors.gold),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gold),
            ),
          ),
          items: [0, 1, 2, 3, 5, 7, 15, 30].map((d) {
            return DropdownMenuItem(
              value: d,
              child: CustomText(text: d == 0 ? 'لا تمديد' : '$d يوم'),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) cubit.setEditExtendDays(v);
          },
        ),
      ],
    );
  }
}
