import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({
    super.key,
    required this.username3rd,
    required this.userPhone,
  });
  final String username3rd;
  final String userPhone;
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
          const CustomText(text: 'البيانات الشخصية', fontSize: 18),

          const Gap(16),

          CustomTextField(labelText: "الاسم ثلاثي", initialValue: username3rd),

          const Gap(12),
          CustomTextField(labelText: "رقم الهاتف", initialValue: userPhone),
        ],
      ),
    );
  }
}
