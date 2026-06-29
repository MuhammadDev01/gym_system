import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
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
import 'package:gym_management_app/features/members/data/attendance_model.dart';

class AdminAttendanceHistoryView extends StatefulWidget {
  const AdminAttendanceHistoryView({super.key});

  @override
  State<AdminAttendanceHistoryView> createState() =>
      _AdminAttendanceHistoryViewState();
}

class _AdminAttendanceHistoryViewState
    extends State<AdminAttendanceHistoryView> {
  List<AttendanceRecord> records = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'سجل الحضور'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
            if (state is AttendanceHistoryLoaded) {
              records = state.records;
            }
          },
          builder: (_, state) => CustomLoadingOverlay(
            isLoading: state is MemberLoadingState,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: context.read<MemberCubit>().phoneController,
                      hintText: 'رقم الهاتف',
                      prefixIcon: Icons.search,
                      validator: (p0) => Validators.requiredField(p0),
                      onChanged: (v) =>
                          context.read<MemberCubit>().searchMembers(v),
                    ),
                    Gap(12),
                    CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<MemberCubit>().getAttendanceHistory();
                        }
                      },
                      text: "بحث",
                    ),
                    records.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                              separatorBuilder: (_, _) =>
                                  Divider(color: Colors.transparent),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: records.length,
                              itemBuilder: (_, index) {
                                return _AttendanceCard(
                                  record: records[index],
                                  onDelete: () => showDeleteConfirm(
                                    context,
                                    title: "title",
                                    onConfirm: () {
                                      context.pop();
                                      context
                                          .read<MemberCubit>()
                                          .deleteAttendanceRecord(
                                            records[index].id,
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : Expanded(child: CustomEmptyList(text: 'سجلات')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.record, required this.onDelete});
  final AttendanceRecord record;
  final VoidCallback onDelete;

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
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 28),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: record.userName, fontSize: 14),
                const Gap(2),
                CustomText(
                  text: record.userPhone,
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          CustomText(text: formatted, fontSize: 11, color: AppColors.gray),
          const Gap(8),
          InkWell(
            onTap: onDelete,
            child: Icon(
              Icons.delete_outline,
              color: AppColors.snackError,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
