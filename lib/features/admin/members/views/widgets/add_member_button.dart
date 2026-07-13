import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({
    super.key,
    required this.formKey,
    required this.cubit,
  });
  final GlobalKey<FormState> formKey;
  final MemberCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemberCubit, MemberState>(
      listener: (context, state) {
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
      child: CustomButton(
        text: 'إضافة',
        icon: const Icon(Icons.person_add, color: Colors.black),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit.addMember();
          }
        },
      ),
    );
  }
}
