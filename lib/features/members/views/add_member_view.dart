import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/views/widgets/months_selector.dart';
import 'package:gym_management_app/features/members/views/widgets/type_selector.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key});

  @override
  State<AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<AddMemberView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MemberCubit>();
    cubit.nameController.clear();
    cubit.phoneController.clear();
    cubit.setMonths(1);
    cubit.setType('gym');
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(title: 'إضافة مشترك جديد'),
        body: BlocConsumer<MemberCubit, MemberState>(
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
            final cubit = context.read<MemberCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MemberLoadingState,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GlassWidget(
                      borderRaduis: 36,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: cubit.nameController,
                            labelText: 'اسم المشترك ثلاثي',
                            prefixIcon: Icons.person,
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
                          const Gap(16),
                          Row(
                            children: [
                              CustomText(text: 'المدة:', fontSize: 14),
                              const Gap(8),
                              Expanded(child: MonthsSelector()),
                            ],
                          ),
                          const Gap(16),
                          TypeSelector(),
                          const Gap(32),
                          CustomButton(
                            text: 'إضافة',
                            icon: const Icon(
                              Icons.person_add,
                              color: Colors.black,
                            ),
                            size: const Size(double.infinity, 50),
                            fontSize: 16,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.addMember();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
