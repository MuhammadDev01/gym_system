import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

void showDeleteConfirm(
  BuildContext context, {
  required String title,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: AppColors.background,
        title: const CustomText(text: 'تأكيد الحذف'),
        content: CustomText(text: title),
        actions: [
          CustomButton(text: 'إلغاء', onPressed: () => context.pop()),
          CustomButton(
            text: 'حذف',
            colorButton: AppColors.snackError,
            colorText: Colors.white,
            onPressed: onConfirm,
          ),
        ],
      ),
    ),
  );
}
