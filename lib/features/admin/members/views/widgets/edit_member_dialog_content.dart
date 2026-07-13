import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/custom_date_picker.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/type_selector.dart';

class EditMemberDialogContent extends StatelessWidget {
  const EditMemberDialogContent({super.key, required this.cubit});
  final MemberCubit cubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: context.read<MemberCubit>().formKeyEdit,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: cubit.editNameController,
              labelText: 'الاسم ثلاثي',
              prefixIcon: Icons.person,
              validator: (p0) => Validators.requiredField(p0),
            ),
            CustomTextField(
              controller: cubit.editPhoneController,
              labelText: 'رقم الهاتف',
              prefixIcon: Icons.phone,
              textInputType: TextInputType.phone,
              validator: (p0) => Validators.requiredField(p0),
            ),
            BlocBuilder<MemberCubit, MemberState>(
              builder: (_, _) {
                return Row(
                  spacing: 8,
                  children: [
                    CustomDatePicker(
                      date: cubit.editStartDate != null
                          ? '${cubit.editStartDate!.year}/${cubit.editStartDate!.month}/${cubit.editStartDate!.day}'
                          : 'اختر تاريخ',
                      labelText: 'بداية الاشتراك',
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: cubit.editStartDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) cubit.setEditStartDate(picked);
                      },
                    ),
                    CustomDatePicker(
                      date: cubit.editEndDate != null
                          ? '${cubit.editEndDate!.year}/${cubit.editEndDate!.month}/${cubit.editEndDate!.day}'
                          : 'اختر تاريخ',
                      labelText: 'نهاية الاشتراك',
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: cubit.editEndDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) cubit.setEditEndDate(picked);
                      },
                    ),
                  ],
                );
              },
            ),
            TypeSelector(),
          ],
        ),
      ),
    );
  }
}
