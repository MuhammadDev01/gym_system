import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/views/widgets/admin_login_fields.dart';
import 'package:gym_management_app/features/auth/views/widgets/member_login_fields.dart';
import 'package:gym_management_app/features/auth/views/widgets/gold_line.dart';

class LoginViewBody extends StatelessWidget {
  LoginViewBody({super.key, required this.cubit});
  final _formKey = GlobalKey<FormState>();
  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomText(
            text: 'تسجيل الدخول',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Gap(12),
          GoldLine(),
          const Gap(24),
          if (!cubit.isAdmin) MemberLoginFields(),
          if (cubit.isAdmin) AdminLoginFields(),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: cubit.isAdmin,
                onChanged: cubit.toggleAdmin,
                activeColor: AppColors.gold,
                checkColor: AppColors.black,
                side: BorderSide(color: AppColors.gray),
              ),
              const Gap(4),
              CustomText(text: 'أدمن', fontSize: 13, color: AppColors.gray),
            ],
          ),
          const Gap(12),
          CustomButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                if (cubit.isAdmin) {
                  await cubit.adminLogin();
                } else {
                  await cubit.memberLogin();
                }
              }
            },
            text: 'دخول',
          ),
        ],
      ),
    );
  }
}
