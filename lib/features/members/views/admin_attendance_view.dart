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
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';

class AdminAttendanceView extends StatefulWidget {
  const AdminAttendanceView({super.key});

  @override
  State<AdminAttendanceView> createState() => _AdminAttendanceViewState();
}

class _AdminAttendanceViewState extends State<AdminAttendanceView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'تسجيل حضور'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberScannedState) {
              appSnackbar(
                context,
                'تم تسجيل الحضور بنجاح',
                color: AppColors.success,
              );
            }
            if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            final cubit = context.read<MemberCubit>();

            return CustomLoadingOverlay(
              isLoading: state is MemberLoadingState,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'رقم الهاتف',
                        controller: cubit.phoneController,
                        textInputType: TextInputType.phone,
                        prefixIcon: Icons.search,
                        validator: (p0) => Validators.requiredField(p0),
                      ),
                      const Gap(12),
                      CustomButton(
                        text: 'بحث',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.getMemberByPhone();
                          }
                        },
                      ),
                      const Gap(24),
                      if (state is MemberFoundState)
                        _attendanceCard(state, cubit),
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

  GlassWidget _attendanceCard(MemberFoundState state, MemberCubit cubit) {
    return GlassWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person, color: AppColors.gold, size: 32),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: state.member.name, fontSize: 16),
                    const Gap(4),
                    CustomText(
                      text: state.member.phone,
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          CustomButton(
            text: 'تأكيد الحضور',
            onPressed: () => cubit.markAttendanceWithTime(),
            size: const Size(double.infinity, 48),
          ),
        ],
      ),
    );
  }
}
