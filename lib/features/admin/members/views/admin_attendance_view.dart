import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';

class AdminAttendanceView extends StatefulWidget {
  const AdminAttendanceView({super.key});

  @override
  State<AdminAttendanceView> createState() => _AdminAttendanceViewState();
}

class _AdminAttendanceViewState extends State<AdminAttendanceView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<MemberCubit>().phoneController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: 'تسجيل حضور',
          actions: [
            IconButton(
              onPressed: () => context.push(AppRoutes.scanMemberView),
              icon: const Icon(Icons.qr_code_scanner, color: AppColors.gold),
            ),
          ],
        ),
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
          buildWhen: (_, next) =>
              next is MemberFoundState ||
              next is MemberNotFoundState ||
              next is MemberScannedState,
          builder: (_, state) {
            final cubit = context.read<MemberCubit>();
            return Padding(
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
                    Gap(12),
                    if (state is MemberLoadingState)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                          ),
                        ),
                      ),

                    if (state is MemberFoundState)
                      _AttendanceCard(cubit: cubit, member: state.member),

                    if (state is MemberNotFoundState)
                      Expanded(
                        child: Center(child: CustomText(text: state.message)),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final MemberModel member;
  final MemberCubit cubit;

  const _AttendanceCard({required this.member, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isExpired =
        member.subscriptionEnd != null &&
        DateTime.now().isAfter(member.subscriptionEnd!);
    return GlassWidget(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: member.name, fontSize: 20),
          CustomText(text: member.phone, fontSize: 18, color: AppColors.gold),
          Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                text: 'نوع الاشتراك:',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              CustomText(
                text: _typeLabel(member.subscriptionType),
                fontSize: 14,
              ),
              const CustomText(text: "|", color: AppColors.gold),
              const CustomText(
                text: 'تاريخ الانتهاء:',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              CustomText(
                text: member.subscriptionEnd != null
                    ? (isExpired
                          ? 'منتهي'
                          : '${member.subscriptionEnd!.year}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.day}')
                    : 'غير محدد',
                fontSize: 14,
                color: isExpired ? AppColors.snackError : Colors.white,
              ),
            ],
          ),
          const Gap(8),
          CustomButton(
            text: 'تأكيد الحضور',
            onPressed: () => cubit.markAttendanceWithTime(member),
          ),
        ],
      ),
    );
  }
}

String _typeLabel(String type) {
  switch (type) {
    case AppConstants.fitness:
      return 'فتنس';
    case AppConstants.gym:
      return 'جيم';
    case AppConstants.private:
      return 'برايفت';
    default:
      return type;
  }
}
