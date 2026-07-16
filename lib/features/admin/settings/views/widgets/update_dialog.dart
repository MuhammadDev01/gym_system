import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showUpdateDialog(
  BuildContext context, {
  required String message,
  required bool forceUpdate,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: !forceUpdate,
    builder: (dialogContext) => PopScope(
      canPop: !forceUpdate,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background,
          content: GlassWidget(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  const Icon(Icons.system_update, color: AppColors.gold, size: 48),
                  CustomText(
                    text: '📢 تحديث جديد',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  CustomText(text: message, fontSize: 15),
                ],
              ),
            ),
          ),
          actions: [
            if (!forceUpdate)
              CustomButton(
                text: 'لاحقاً',
                onPressed: () => Navigator.pop(dialogContext),
              ),
            CustomButton(
              text: 'تحديث',
              onPressed: () async {
                final url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.gym_management_app',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
                if (forceUpdate) return;
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
