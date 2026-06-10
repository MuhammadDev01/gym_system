import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';

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
    return GlassWidget(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CustomText(
            text: 'البيانات الشخصية',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(16),
          CustomTextField(labelText: "الاسم ثلاثي", initialValue: username3rd),
          const Gap(12),
          CustomTextField(labelText: "رقم الهاتف", initialValue: userPhone),
        ],
      ),
    );
  }
}
