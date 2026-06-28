import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';

class EditMemberDialogContent extends StatelessWidget {
  const EditMemberDialogContent({super.key, required this.cubit});
  final MemberCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cubit.editTarget?.image.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    base64Decode(cubit.editTarget!.image),
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 96,
                      height: 96,
                      color: AppColors.gold.withAlpha(38),
                      child: Icon(Icons.person, color: AppColors.gold, size: 40),
                    ),
                  ),
                ),
              ),
            ),
          CustomTextField(
            controller: cubit.editNameController,
            labelText: 'الاسم ثلاثي',
            prefixIcon: Icons.person,
          ),
          const Gap(12),
          CustomTextField(
            controller: cubit.editPhoneController,
            labelText: 'رقم الهاتف',
            prefixIcon: Icons.phone,
            textInputType: TextInputType.phone,
          ),
          const Gap(16),
          Row(children: [_startDate(context), const Gap(8), _endDate(context)]),
          const Gap(12),
          _subscriptionType(),
        ],
      ),
    );
  }

  Expanded _endDate(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: cubit.editEndDate ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) cubit.setEditEndDate(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'نهاية الاشتراك',
            isDense: true,
            labelStyle: TextStyle(color: AppColors.gold),

            border: OutlineInputBorder(),
          ),
          child: CustomText(
            text: cubit.editEndDate != null
                ? '${cubit.editEndDate!.day}/${cubit.editEndDate!.month}/${cubit.editEndDate!.year}'
                : 'اختر تاريخ',
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Expanded _startDate(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: cubit.editStartDate ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) cubit.setEditStartDate(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'بداية الاشتراك',
            labelStyle: TextStyle(color: AppColors.gold),
            isDense: true,
            border: OutlineInputBorder(),
          ),
          child: CustomText(
            text: cubit.editStartDate != null
                ? '${cubit.editStartDate!.day}/${cubit.editStartDate!.month}/${cubit.editStartDate!.year}'
                : 'اختر تاريخ',
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Row _subscriptionType() {
    return Row(
      children: [
        CustomText(text: 'النوع:', fontSize: 13),
        const Gap(8),
        Expanded(
          child: DropdownButtonFormField<String>(
            dropdownColor: AppColors.surface,
            initialValue: cubit.editType,
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.gold),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'fitness',
                child: CustomText(text: 'فتنس'),
              ),
              DropdownMenuItem(
                value: 'gym',
                child: CustomText(text: 'جيم'),
              ),
              DropdownMenuItem(
                value: 'private',
                child: CustomText(text: 'برايفت'),
              ),
            ],
            onChanged: (v) {
              if (v != null) cubit.setEditType(v);
            },
          ),
        ),
      ],
    );
  }
}
