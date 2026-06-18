import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_back_button.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/cubit/admin_cubit.dart';
import 'package:gym_management_app/features/admin/views/widgets/months_selector.dart';
import 'package:gym_management_app/features/admin/views/widgets/type_selector.dart';

class AddMemberView extends StatelessWidget {
  AddMemberView({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: BlocConsumer<AdminCubit, AdminState>(
          listener: (_, state) {
            if (state is MemberAddedState) {
              appSnackbar(
                context,
                'تم إضافة المشترك بنجاح',
                color: AppColors.success,
              );
              context.pop();
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            return CustomLoadingOverlay(
              isLoading: state is MemberLoadingState,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBackButton(),
                      const Gap(24),
                      GlassWidget(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Image.asset(AppAssets.logo, height: 80),
                              const Gap(16),
                              CustomText(
                                text: 'إضافة مشترك جديد',
                                fontSize: 22,
                                color: AppColors.gold,
                              ),
                              const Gap(24),
                              CustomTextField(
                                controller: context
                                    .read<AdminCubit>()
                                    .nameController,
                                labelText: 'اسم المشترك ثلاثي',
                                prefixIcon: Icons.person,
                                validator: (v) => Validators.requiredField(v),
                              ),
                              const Gap(12),
                              CustomTextField(
                                controller: context
                                    .read<AdminCubit>()
                                    .phoneController,
                                labelText: 'رقم الهاتف',
                                prefixIcon: Icons.phone,
                                textInputType: TextInputType.phone,
                                validator: (v) => Validators.requiredField(v),
                              ),
                              const Gap(20),
                              MonthsSelector(),
                              const Gap(20),
                              TypeSelector(),
                              const Gap(24),
                              CustomButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AdminCubit>().addMember();
                                  }
                                },
                                text: 'إضافة',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
