import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/data/attendance_model.dart';

class AdminAttendanceHistoryView extends StatelessWidget {
  const AdminAttendanceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(title: 'سجل الحضور'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            final cubit = context.read<MemberCubit>();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  CustomTextField(
                    controller: cubit.attendanceSearchController,
                    hintText: 'بحث بالاسم أو رقم الهاتف',
                    prefixIcon: Icons.search,
                    onChanged: (_) => cubit.getAttendanceHistory(),
                  ),
                  Expanded(
                    child: state is MemberLoadingState
                        ? const CustomCircularLoading()
                        : state is AttendanceHistoryLoaded
                        ? state.records.isNotEmpty
                              ? ListView.separated(
                                  addAutomaticKeepAlives: false,
                                  itemCount: state.records.length,
                                  separatorBuilder: (_, _) => const Gap(12),
                                  itemBuilder: (_, index) {
                                    return _AttendanceCard(
                                      record: state.records[index],
                                    );
                                  },
                                )
                              : const CustomEmptyList(text: 'سجل')
                        : const CustomEmptyList(text: 'سجل'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.record});
  final AttendanceRecord record;

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}  $h:$m $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _formatTime(record.timestamp);
    return GlassWidget(
      padding: const EdgeInsets.all(12),
      borderRaduis: 8,
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 28),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: record.userName, fontSize: 14),
                const Gap(2),
                CustomText(
                  text: record.userPhone,
                  fontSize: 14,
                  color: AppColors.gold,
                ),
              ],
            ),
          ),
          CustomText(
            text: formatted,
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          const Gap(8),
          InkWell(
            onTap: () => showDeleteConfirm(
              context,
              title: "هل انت متأكد من حذف السجل المحدد",
              onConfirm: () async {
                await context.read<MemberCubit>().deleteAttendanceRecord(
                  record.id,
                );
              },
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.snackError,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
