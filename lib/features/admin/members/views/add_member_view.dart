import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/add_member_button.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/months_selector.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/type_selector.dart';

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
    context.read<MemberCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(title: 'إضافة مشترك جديد'),
        body: BlocBuilder<MemberCubit, MemberState>(
          builder: (context, state) {
            final cubit = context.read<MemberCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MemberLoadingState,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: GlassWidget(
                    borderRaduis: 12,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        CustomTextField(
                          controller: cubit.nameController,
                          labelText: 'اسم المشترك ثلاثي',
                          prefixIcon: Icons.person,
                          validator: (v) => Validators.requiredField(v),
                        ),
                        CustomTextField(
                          controller: cubit.phoneController,
                          labelText: 'رقم الهاتف',
                          prefixIcon: Icons.phone,
                          textInputType: TextInputType.phone,
                          validator: (v) => Validators.requiredField(v),
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            CustomText(
                              text: 'المدة:',
                              fontSize: 14,
                              color: AppColors.gold,
                            ),
                            Expanded(child: MonthsSelector()),
                          ],
                        ),
                        TypeSelector(),
                        const Gap(16),
                        AddMemberButton(formKey: _formKey, cubit: cubit),
                      ],
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
