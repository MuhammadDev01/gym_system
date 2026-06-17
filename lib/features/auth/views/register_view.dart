import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/auth/views/widgets/gold_line.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/views/widgets/member_pick_image.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomText(
            text: 'تسجيل بيانات العضوية',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Gap(12),
          GoldLine(),
          const Gap(24),
          MemberPickImage(),
          const Gap(12),
          _instractionPorfilePic(),
          const Gap(24),
          CustomTextField(
            controller: cubit.nameController,
            labelText: 'الاسم الثلاثي بالعربي',
            prefixIcon: Icons.person,
            textInputType: TextInputType.name,
            validator: (v) => Validators.requiredField(v),
          ),
          const Gap(16),
          CustomTextField(
            controller: cubit.phoneController,
            labelText: 'رقم الهاتف',
            prefixIcon: Icons.phone,
            textInputType: TextInputType.phone,
            validator: (v) => Validators.requiredField(v),
          ),
          const Gap(24),
          CustomButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                await cubit.memeberRegister();
              }
            },
            text: 'تسجيل',
          ),
          const Gap(16),
          GestureDetector(
            onTap: () => cubit.changeField(),
            child: CustomText(
              text: 'لديك حساب بالفعل؟ سجل دخول',
              color: AppColors.gold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Row _instractionPorfilePic() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, color: AppColors.gold, size: 14),
        const Gap(4),
        CustomText(
          text: 'يجب أن تكون الصورة واضحة ويظهر فيها الوجه',
          fontSize: 10,
          color: AppColors.gray,
        ),
      ],
    );
  }
}
