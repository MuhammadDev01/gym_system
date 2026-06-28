import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _search() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    context.read<MemberCubit>().getAttendanceHistory(phone);
  }

  void _deleteRecord(String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const CustomText(text: 'حذف سجل الحضور', fontSize: 18),
        content: const CustomText(
          text: 'هل أنت متأكد من حذف هذا السجل؟',
          color: Colors.white70,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(text: 'إلغاء', color: Colors.white54),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final phone = _phoneController.text.trim();
              context.read<MemberCubit>().deleteAttendanceRecord(docId, phone);
            },
            child: const CustomText(text: 'حذف', color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'سجل الحضور'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (_, state) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'رقم الهاتف',
                      controller: _phoneController,
                      textInputType: TextInputType.phone,
                      prefixIcon: Icons.search,
                    ),
                  ),
                  const Gap(8),
                  CustomButton(text: 'بحث', onPressed: _search),
                ],
              ),
            ),
            Expanded(
              child: _buildContent(state),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(MemberState state) {
    if (state is MemberLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AttendanceHistoryLoaded) {
      final records = state.records;
      if (records.isEmpty) {
        return const Center(
          child: CustomText(
            text: 'لا توجد سجلات حضور لهذا المشترك',
            color: Colors.white54,
          ),
        );
      }
      return ListView.separated(
        separatorBuilder: (_, _) => Divider(color: Colors.transparent),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: records.length,
        itemBuilder: (_, index) {
          final record = records[index];
          return _AttendanceCard(
            record: record,
            onDelete: () => _deleteRecord(record.id),
          );
        },
      );
    }
    if (state is MemberErrorState) {
      return Center(
        child: CustomText(text: state.message, color: Colors.white54),
      );
    }
    return const Center(
      child: CustomText(
        text: 'ابحث برقم الهاتف لعرض السجل',
        color: Colors.white54,
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
            child: Icon(Icons.delete_outline, color: AppColors.snackError, size: 22),
          ),
        ],
      ),
    );
  }
}
