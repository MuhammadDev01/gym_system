import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CustomText(
            text: 'تغيير كلمة المرور',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(16),
          CustomTextField(labelText: "كلمة المرور الحالية", obscureText: true),
          const Gap(12),
          CustomTextField(labelText: "كلمة المرور الجديدة", obscureText: true),
          const Gap(12),
          CustomTextField(
            labelText: "تأكيد كلمة المرور الجديدة",
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
