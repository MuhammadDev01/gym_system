import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';

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
    final member = state.member;
    final isExpired =
        member.subscriptionEnd != null &&
        DateTime.now().isAfter(member.subscriptionEnd!);

    return GlassWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.gold.withAlpha(38),
                  borderRadius: BorderRadius.circular(16),
                  image: member.image.isNotEmpty
                      ? DecorationImage(
                          image: BaseImageCache.getImage(member.image),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: member.image.isEmpty
                    ? Icon(Icons.person, color: AppColors.gold, size: 32)
                    : null,
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: member.name, fontSize: 16),
                  const Gap(4),
                  CustomText(
                    text: member.phone,
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ],
              ),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'نوع الاشتراك:',
                fontSize: 12,
                color: Colors.white38,
              ),
              const Gap(4),
              CustomText(
                text: _typeLabel(member.subscriptionType),
                fontSize: 12,
                color: AppColors.gray,
              ),
              const Gap(16),
              CustomText(
                text: 'تاريخ الانتهاء:',
                fontSize: 12,
                color: Colors.white38,
              ),
              const Gap(4),
              CustomText(
                text: member.subscriptionEnd != null
                    ? (isExpired
                          ? 'منتهي'
                          : '${member.subscriptionEnd!.day}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.year}')
                    : 'غير محدد',
                fontSize: 12,
                color: isExpired ? AppColors.snackError : AppColors.gray,
              ),
            ],
          ),
          const Gap(16),
          CustomButton(
            text: 'تأكيد الحضور',
            onPressed: () => cubit.markAttendanceWithTime(),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'fitness':
        return 'فتنس';
      case 'gym':
        return 'جيم';
      case 'private':
        return 'برايفت';
      default:
        return type;
    }
  }
}
