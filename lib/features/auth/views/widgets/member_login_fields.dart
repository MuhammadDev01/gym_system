import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class MemberLoginFields extends StatelessWidget {
  const MemberLoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: context.read<AuthCubit>().nameController,
          labelText: 'الاسم الثلاثي',
          prefixIcon: Icons.person,
          textInputType: TextInputType.name,
          validator: (v) => Validators.requiredField(v),
        ),
        const Gap(16),
        CustomTextField(
          controller: context.read<AuthCubit>().phoneController,
          labelText: 'رقم الهاتف',
          prefixIcon: Icons.phone,
          textInputType: TextInputType.phone,
          validator: (v) => Validators.requiredField(v),
        ),
      ],
    );
  }
}
