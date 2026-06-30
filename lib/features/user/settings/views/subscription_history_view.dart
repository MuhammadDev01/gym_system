import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_state.dart';

class SubscriptionHistoryView extends StatefulWidget {
  const SubscriptionHistoryView({super.key});

  @override
  State<SubscriptionHistoryView> createState() =>
      _SubscriptionHistoryViewState();
}

class _SubscriptionHistoryViewState extends State<SubscriptionHistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionHistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: GlassAppBar(title: "سجل الاشتراكات"),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backround),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<SubscriptionHistoryCubit, SubscriptionHistoryState>(
              builder: (_, state) {
                return CustomLoadingOverlay(
                  isLoading: state is SubscriptionHistoryLoading,
                  child: state is SubscriptionHistoryLoaded
                      ? state.records.isEmpty
                            ? const CustomEmptyList(text: 'اشتراكات سابقة')
                            : ListView.separated(
                                addAutomaticKeepAlives: false,
                                itemCount: state.records.length,
                                separatorBuilder: (_, _) => const Gap(16),
                                itemBuilder: (_, index) {
                                  final record = state.records[index];
                                  return _SubscriptionCard(
                                    plan: record.planLabel,
                                    date:
                                        '${record.startDate.day.toString().padLeft(2, '0')}/${record.startDate.month.toString().padLeft(2, '0')}/${record.startDate.year} - ${record.endDate.day.toString().padLeft(2, '0')}/${record.endDate.month.toString().padLeft(2, '0')}/${record.endDate.year}',
                                  );
                                },
                              )
                      : state is SubscriptionHistoryError
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CustomText(text: 'حدث خطأ', fontSize: 16),
                              const SizedBox(height: 8),
                              CustomText(
                                text: state.message,
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: CustomText(text: 'لا توجد اشتراكات سابقة'),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String plan;
  final String date;
  const _SubscriptionCard({required this.plan, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.fitness_center, color: AppColors.gold, size: 24),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: plan, fontSize: 15),
                const Gap(6),
                CustomText(text: date, fontSize: 13, color: Colors.white70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
