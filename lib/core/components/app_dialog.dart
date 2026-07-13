import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

//Delete
void showDeleteConfirm(
  BuildContext context, {
  required String title,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        title: const CustomText(
          text: 'تأكيد الحذف',
          textAlign: TextAlign.center,
          fontSize: 18,
        ),
        actionsAlignment: MainAxisAlignment.center,
        content: CustomText(
          text: title,
          textAlign: TextAlign.center,
          color: AppColors.textSecondary,
        ),
        actions: [
          CustomButton(text: 'إلغاء', onPressed: () => dialogContext.pop()),
          CustomButton(
            text: 'حذف',
            colorButton: AppColors.snackError,
            colorText: Colors.white,
            onPressed: () {
              dialogContext.pop();
              onConfirm();
            },
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
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,

      child: AlertDialog(
        actionsPadding: EdgeInsets.all(12),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          CustomButton(
            text: 'حذف',
            colorButton: AppColors.snackError,
            colorText: Colors.white,
            onPressed: () => showDeleteConfirm(
              dialogContext,
              title: deleteTitle,
              onConfirm: () {
                dialogContext.pop();
                onConfirmDelete();
              },
            ),
          ),
          CustomButton(text: 'إلغاء', onPressed: () => dialogContext.pop()),
          CustomButton(
            text: 'حفظ',
            colorText: Colors.white,
            colorButton: AppColors.success,
            onPressed: () {
              dialogContext.pop();
              onConfirmUpdate();
            },
          ),
        ],
        backgroundColor: AppColors.background,
        title: CustomText(text: editTitle, color: AppColors.gold),
        content: content,
      ),
    ),
  );
}

void onConfirmLogout(BuildContext context, {required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.background,
      title: CustomText(
        text: 'تسجيل الخروج',
        fontSize: 18,
        textAlign: TextAlign.center,
      ),
      content: CustomText(
        text: 'هل أنت متأكد من تسجيل الخروج؟',
        textAlign: TextAlign.center,
        color: AppColors.textSecondary,
      ),
      actions: [
        CustomButton(onPressed: () => context.pop(), text: 'إلغاء'),
        CustomButton(
          colorButton: AppColors.snackError,
          colorText: Colors.white,
          onPressed: () {
            context.pop();
            onConfirm();
          },
          text: 'تسجيل الخروج',
        ),
      ],
    ),
  );
}
