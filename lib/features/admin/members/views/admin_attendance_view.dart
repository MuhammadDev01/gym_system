import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
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
  final _searchController = TextEditingController();
  @override
  void initState() {
    context.read<MemberCubit>().getAllMembers();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(title: 'تسجيل حضور'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            children: [
              CustomTextField(
                hintText: 'بحث بالاسم أو رقم الهاتف',
                controller: _searchController,
                prefixIcon: Icons.search,
                onChanged: (v) {
                  context.read<MemberCubit>().searchMembers(v);
                },
              ),
              Expanded(
                child: BlocConsumer<MemberCubit, MemberState>(
                  listener: (context, state) {
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
                  buildWhen: (_, next) => next is MemberLoadedState,
                  builder: (_, state) {
                    final cubit = context.read<MemberCubit>();

                    if (state is MemberLoadedState &&
                        _searchController.text.isNotEmpty) {
                      return state.members.isEmpty
                          ? const Center(
                              child: CustomText(text: 'لا يوجد نتائج'),
                            )
                          : ListView.separated(
                              addAutomaticKeepAlives: false,
                              itemCount: state.members.length,
                              separatorBuilder: (_, _) => const Gap(12),
                              itemBuilder: (_, index) {
                                return _AttendanceCard(
                                  cubit: cubit,
                                  member: state.members[index],
                                );
                              },
                            );
                    }
                    return const Center(child: CustomEmptyList(text: 'أعضاء'));
                  },
                ),
              ),
            ],
          ),
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
      borderColor: AppColors.gold,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          CustomText(text: member.name, fontSize: 20),
          CustomText(text: member.phone, fontSize: 18, color: AppColors.gold),
          Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text: 'نوع الاشتراك:',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              CustomText(text: _typeLabel(member.subscriptionType)),
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
            colorButton: member.attendedToday
                ? AppColors.success
                : AppColors.gold,
            colorText: member.attendedToday ? Colors.white : AppColors.black,
            text: member.attendedToday ? 'تم الحضور' : 'تأكيد الحضور',
            onPressed: member.attendedToday
                ? () {}
                : () => cubit.markAttendanceWithTime(member),
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
