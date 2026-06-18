import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class AdminLoginFields extends StatelessWidget {
  const AdminLoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (_, _) {
        final cubit = context.read<AuthCubit>();
        return Column(
          children: [
            CustomTextField(
              controller: cubit.emailController,
              labelText: 'البريد الإلكتروني',
              prefixIcon: Icons.email,
              textInputType: TextInputType.emailAddress,
              validator: (v) => Validators.requiredField(v),
            ),
            const Gap(16),
            CustomTextField(
              controller: cubit.passwordController,
              labelText: 'كلمة المرور',
              prefixIcon: Icons.lock,
              obscureText: cubit.obscurePassword,
              suffixIcon: cubit.obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              onTapSufffix: () => cubit.toggleObscurePassword(),
              validator: (v) => Validators.requiredField(v),
            ),
          ],
        );
      },
    );
  }
}
