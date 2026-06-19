import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class DialogMessage extends StatelessWidget {
  const DialogMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _containerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: _containerDecoration2(),
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 40,
            ),
          ),

          Gap(20),
          CustomText(text: 'تأكيد التغييرات', color: AppColors.gold),
          Gap(12),
          CustomText(
            text:
                'هل أنت متأكد من حفظ التغييرات؟\nلن يتم التراجع عنها بعد الحفظ.',
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
          Gap(24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "إلغاء",
                  colorButton: Colors.white,
                ),
              ),

              Gap(12),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "تأكيد",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration2() {
    return BoxDecoration(
      color: AppColors.gold.withValues(alpha: .15),
      shape: BoxShape.circle,
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: .06),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: .08)),
    );
  }
}
