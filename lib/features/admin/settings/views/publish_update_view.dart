import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class PublishUpdateView extends StatefulWidget {
  const PublishUpdateView({super.key});

  @override
  State<PublishUpdateView> createState() => _PublishUpdateViewState();
}

class _PublishUpdateViewState extends State<PublishUpdateView> {
  final _versionController = TextEditingController();
  final _buildController = TextEditingController();
  final _messageController = TextEditingController();
  bool _forceUpdate = false;

  @override
  void dispose() {
    _versionController.dispose();
    _buildController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(title: 'نشر تحديث'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 24,
            children: [
              CustomTextField(
                controller: _versionController,
                labelText: 'النسخة الجديدة (مثال: 1.1.0)',
              ),
              CustomTextField(
                controller: _buildController,
                labelText: 'رقم البناء (Build Number)',
                textInputType: TextInputType.number,
              ),
              CustomTextField(
                controller: _messageController,
                labelText: 'رسالة التحديث',
                maxLines: 4,
              ),
              Row(
                children: [
                  const Text('تحديث إجباري', style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  Switch(
                    value: _forceUpdate,
                    onChanged: (v) => setState(() => _forceUpdate = v),
                    activeThumbColor: AppColors.gold,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'نشر التحديث',
                onPressed: _publish,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _publish() async {
    final version = _versionController.text.trim();
    final buildStr = _buildController.text.trim();
    final message = _messageController.text.trim();

    if (version.isEmpty || buildStr.isEmpty || message.isEmpty) {
      appSnackbar(context, 'يرجى ملء جميع الحقول', color: AppColors.error);
      return;
    }
    final build = int.tryParse(buildStr);
    if (build == null) {
      appSnackbar(context, 'رقم البناء يجب أن يكون رقماً', color: AppColors.error);
      return;
    }

    try {
      await getIt<FirebaseService>().setDocument(
        collection: 'settings',
        docId: 'update_info',
        data: {
          'latestVersion': version,
          'buildNumber': build,
          'message': message,
          'forceUpdate': _forceUpdate,
          'publishedAt': FieldValue.serverTimestamp(),
        },
      );
      if (context.mounted) {
        appSnackbar(context, 'تم نشر التحديث بنجاح', color: AppColors.success);
      }
    } catch (e) {
      if (context.mounted) {
        appSnackbar(context, e.toString(), color: AppColors.error);
      }
    }
  }
}
