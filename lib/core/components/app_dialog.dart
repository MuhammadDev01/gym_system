import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

//Delete
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

//Edit
void showEditDialog(
  BuildContext context, {
  required VoidCallback onConfirmDelete,
  required VoidCallback onConfirmUpdate,
  required String deleteTitle,
  required String editTitle,
  required Widget content,
}) {
  showDialog(
    context: context,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,

      child: AlertDialog(
        actionsPadding: EdgeInsets.all(12),
        actions: _editMemberActions(
          onconfirmDelete: onConfirmDelete,
          onconfirmUpdate: onConfirmUpdate,
          title: deleteTitle,
          context,
        ),
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        title: CustomText(text: editTitle),
        content: content,
      ),
    ),
  );
}

List<Widget> _editMemberActions(
  BuildContext context, {
  required VoidCallback onconfirmDelete,
  required VoidCallback onconfirmUpdate,
  required String title,
}) {
  return [
    Expanded(
      child: CustomButton(
        text: 'حذف',
        colorButton: AppColors.snackError,
        colorText: Colors.white,
        onPressed: () => showDeleteConfirm(
          onConfirm: onconfirmDelete,
          context,
          title: title,
        ),
      ),
    ),
    Expanded(
      child: CustomButton(text: 'إلغاء', onPressed: () => context.pop()),
    ),
    Expanded(
      child: CustomButton(
        text: 'حفظ',
        colorText: Colors.white,
        colorButton: AppColors.success,
        onPressed: onconfirmUpdate,
      ),
    ),
  ];
}

void onConfirmLogout(BuildContext context, {required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.background,
      title: CustomText(
        text: 'تسجيل الخروج',
        fontSize: 18,
        textAlign: TextAlign.center,
      ),
      content: CustomText(
        text: 'هل أنت متأكد من تسجيل الخروج؟',
        textAlign: TextAlign.center,
        color: AppColors.gray.withValues(alpha: 0.5),
      ),
      actions: [
        CustomButton(onPressed: () => context.pop(), text: 'إلغاء'),

        CustomButton(
          colorButton: AppColors.snackError,
          colorText: Colors.white,
          onPressed: onConfirm,
          text: 'تسجيل الخروج',
        ),
      ],
    ),
  );
}
