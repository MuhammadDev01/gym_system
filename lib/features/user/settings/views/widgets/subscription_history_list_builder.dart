import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_state.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';

class SubscriptionHistoryListBuilder extends StatelessWidget {
  const SubscriptionHistoryListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionHistoryCubit, SubscriptionHistoryState>(
      listener: (_, state) {
        if (state is SubscriptionHistoryError) {
          appSnackbar(context, state.message);
        }
        if (state is SubscriptionHistoryDeleted) {
          appSnackbar(context, "تم الحذف بنجاح", color: AppColors.success);
        }
      },
      builder: (_, state) {
        if (state is SubscriptionHistoryLoading) {
          return CustomCircularLoading();
        }
        if (state is SubscriptionHistoryLoaded) {
          return state.records.isEmpty
              ? Expanded(
                  child: const CustomEmptyList(text: 'سجلات لهذا المشترك'),
                )
              : Expanded(
                  child: ListView.separated(
                    addAutomaticKeepAlives: false,
                    itemCount: state.records.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final record = state.records[index];
                      return _SubscriptionCard(record: record);
                    },
                  ),
                );
        }
        return Expanded(
          child: const Center(
            child: CustomText(text: 'ابحث بالاسم أو رقم الهاتف لعرض السجل'),
          ),
        );
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionHistoryModel record;
  const _SubscriptionCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final date =
        '${record.startDate.day.toString().padLeft(2, '0')}/${record.startDate.month.toString().padLeft(2, '0')}/${record.startDate.year} - ${record.endDate.day.toString().padLeft(2, '0')}/${record.endDate.month.toString().padLeft(2, '0')}/${record.endDate.year}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 14,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.gold,
                  size: 24,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: record.userName, fontSize: 15),
                    CustomText(
                      text: record.userPhone,
                      fontSize: 13,
                      color: AppColors.gold,
                    ),
                    CustomText(text: record.planLabel, fontSize: 15),
                    CustomText(
                      text: date,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.snackError,
                ),
                onPressed: () => showDeleteConfirm(
                  context,
                  title: "هل أنت متأكد من حذف هذا السجل",
                  onConfirm: () async {
                    await context.read<SubscriptionHistoryCubit>().deleteRecord(
                      record.id,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _confirmDeleteOne(BuildContext context, String docId) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       backgroundColor: const Color(0xFF1A1A2E),
  //       title: const CustomText(text: 'حذف السجل'),
  //       content: const CustomText(text: 'هل أنت متأكد من حذف هذا السجل؟'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => ctx.pop();
  //           child: const CustomText(text: 'إلغاء'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             ctx.pop();
  //             await context.read<SubscriptionHistoryCubit>().deleteRecord(
  //               docId,
  //             );
  //           },
  //           child: const CustomText(text: 'حذف', color: AppColors.snackError),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
