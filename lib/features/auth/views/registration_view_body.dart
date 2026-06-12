import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/auth/views/widgets/gold_line.dart';
import 'package:gym_management_app/features/auth/cubit/user_cubit.dart';

class RegistrationViewBody extends StatefulWidget {
  const RegistrationViewBody({super.key});

  @override
  State<RegistrationViewBody> createState() => _RegistrationViewBodyState();
}

class _RegistrationViewBodyState extends State<RegistrationViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserRegistered) {
          Navigator.pushReplacementNamed(context, AppRoutes.registrationView);
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF991111),
            ),
          );
        } else if (state is UserInitial) {
          _nameController.clear();
          _phoneController.clear();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Form(
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
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      final cubit = context.read<UserCubit>();
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: cubit.pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: cubit.image == null
                                      ? AssetImage(Assets.picProfile)
                                      : FileImage(cubit.image!)
                                            as ImageProvider,
                                ),
                                _cameraIcon(),
                              ],
                            ),
                          ),
                          const Gap(12),
                          _instractionPorfilePic(),
                        ],
                      );
                    },
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'الاسم الثلاثي بالعربي',
                    prefixIcon: Icons.person,
                    textInputType: TextInputType.name,
                  ),
                  const Gap(16),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'رقم الهاتف',
                    prefixIcon: Icons.phone,
                    textInputType: TextInputType.phone,
                  ),
                  const Gap(24),
                  CustomButton(onPressed: _onPressed, text: 'تسجيل'),
                  const Gap(16),
                  GestureDetector(
                    onTap: () {
                      _nameController.clear();
                      _phoneController.clear();
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.loginView,
                      );
                    },
                    child: CustomText(
                      text: 'لديك حساب بالفعل؟ سجل دخول',
                      color: ColorsApp.gold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (state is UserLoading) const CustomLoadingOverlay(),
          ],
        );
      },
    );
  }

  Positioned _cameraIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ColorsApp.gold,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
      ),
    );
  }

  Row _instractionPorfilePic() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, color: ColorsApp.gold, size: 14),
        const Gap(4),
        CustomText(
          text: 'يجب أن تكون الصورة واضحة ويظهر فيها الوجه',
          fontSize: 10,
          color: ColorsApp.gold,
        ),
      ],
    );
  }

  void _onPressed() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<UserCubit>();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      _showSnackbar(context, 'الرجاء إدخال الاسم الثلاثي');
      return;
    }
    if (phone.isEmpty) {
      _showSnackbar(context, 'الرجاء إدخال رقم الهاتف');
      return;
    }
    if (cubit.image == null) {
      _showSnackbar(context, 'الرجاء إضافة صورة شخصية');
      return;
    }

    cubit.registerUser(userName: name, userPhone: phone);
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF991111),
      ),
    );
  }
}
