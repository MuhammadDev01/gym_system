import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/features/auth/cubit/user_cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _nameError;
  String? _phoneError;

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
          Navigator.pushReplacementNamed(context, AppRoutes.gerenalView);
        } else if (state is UserLoginFieldError) {
          setState(() {
            _nameError = null;
            _phoneError = null;
            if (state.field == 'name') {
              _nameError = state.message;
            } else if (state.field == 'phone') {
              _phoneError = state.message;
            } else {
              _nameError = state.message;
              _phoneError = state.message;
            }
          });
        } else if (state is UserInitial) {
          _nameController.clear();
          _phoneController.clear();
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is! UserLoading,
          progressIndicator: CircularProgressIndicator(),

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomText(
                  text: 'تسجيل الدخول',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Gap(12),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorsApp.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const Gap(24),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'الاسم الثلاثي بالعربي',
                  prefixIcon: Icons.person,
                  textInputType: TextInputType.name,
                ),
                if (_nameError != null) ...[
                  const Gap(4),
                  CustomText(
                    text: _nameError!,
                    color: ColorsApp.error,
                    fontSize: 12,
                  ),
                ],
                const Gap(16),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icons.phone,
                  textInputType: TextInputType.phone,
                ),
                if (_phoneError != null) ...[
                  const Gap(4),
                  CustomText(
                    text: _phoneError!,
                    color: ColorsApp.error,
                    fontSize: 12,
                  ),
                ],
                const Gap(24),

                CustomButton(onPressed: _login, text: 'دخول'),
                const Gap(16),
                GestureDetector(
                  onTap: () {
                    _nameController.clear();
                    _phoneController.clear();
                    setState(() {
                      _nameError = null;
                      _phoneError = null;
                    });
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.registrationView,
                    );
                  },
                  child: CustomText(
                    text: 'ليس لديك حساب؟ سجل الآن',
                    color: ColorsApp.gold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _login() {
    setState(() {
      _nameError = null;
      _phoneError = null;
    });
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

    cubit.loginUser(userName: name, userPhone: phone);
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: ColorsApp.snackError),
    );
  }
}
