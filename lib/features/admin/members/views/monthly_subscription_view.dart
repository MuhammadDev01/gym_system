import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_state.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';

class MonthlySubscriptionView extends StatefulWidget {
  const MonthlySubscriptionView({super.key});

  @override
  State<MonthlySubscriptionView> createState() =>
      _MonthlySubscriptionViewState();
}

class _MonthlySubscriptionViewState extends State<MonthlySubscriptionView> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionHistoryCubit>().loadAllHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(title: 'سجل الاشتراكات الشهري'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backround),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<SubscriptionHistoryCubit, SubscriptionHistoryState>(
          listener: (_, state) {
            if (state is SubscriptionHistoryError) {
              appSnackbar(context, state.message);
            }
          },
          buildWhen: (_, next) =>
              next is SubscriptionHistoryLoading ||
              next is SubscriptionHistoryLoaded,

          builder: (_, state) {
            if (state is SubscriptionHistoryLoading) {
              return CustomLoadingOverlay(
                isLoading: true,
                child: const SizedBox.shrink(),
              );
            }
            if (state is SubscriptionHistoryLoaded &&
                state.records.isNotEmpty) {
              return _MonthlyList(records: state.records);
            }
            return const CustomEmptyList(text: 'اشتراكات');
          },
        ),
      ),
    );
  }
}

class _MonthlyList extends StatelessWidget {
  final List<SubscriptionHistoryModel> records;

  const _MonthlyList({required this.records});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<SubscriptionHistoryModel>>{};

    for (final r in records) {
      final key =
          '${r.startDate.year}/${r.startDate.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(r);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      addAutomaticKeepAlives: false,
      itemCount: sortedKeys.length,
      separatorBuilder: (_, _) => const Gap(16),
      itemBuilder: (_, index) {
        final key = sortedKeys[index];
        final monthRecords = grouped[key]!;
        return _MonthCard(
          key: ValueKey(key),
          monthLabel: key,
          records: monthRecords,
        );
      },
    );
  }
}

class _MonthCard extends StatelessWidget {
  final String monthLabel;
  final List<SubscriptionHistoryModel> records;

  const _MonthCard({
    super.key,
    required this.monthLabel,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: BlocBuilder<SubscriptionHistoryCubit, SubscriptionHistoryState>(
        builder: (context, state) {
          final parts = monthLabel.split('/');
          final month = int.tryParse(parts[1]) ?? 0;
          final year = parts[0];
          final label = 'شهر $month $year';
          final cubit = context.read<SubscriptionHistoryCubit>();
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => cubit.toggleMonthExpanded(monthLabel),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    spacing: 12,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          color: AppColors.gold,
                          size: 22,
                        ),
                      ),
                      Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: label, fontSize: 15),
                          CustomText(
                            text: '${records.length} مشترك',
                            fontSize: 13,
                            color: AppColors.gold,
                          ),
                        ],
                      ),
                      const Spacer(),

                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () => showDeleteConfirm(
                          context,
                          title: "هل تود حذف سجل شهر $month",
                          onConfirm: () async {
                            final docIds = records
                                .map((r) => r.id)
                                .where((id) => id.isNotEmpty)
                                .toList();
                            if (docIds.isNotEmpty) {
                              await cubit.deleteRecordsByIds(docIds);
                            }
                          },
                        ),
                      ),
                      Icon(
                        cubit.expandedMonths.contains(monthLabel)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                ),
              ),
              if (cubit.expandedMonths.contains(monthLabel))
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: records.map((r) {
                      final m = r.months;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: .06),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: r.userName, fontSize: 13),
                                CustomText(
                                  text: r.userPhone,
                                  fontSize: 11,
                                  color: AppColors.gold,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomText(
                              text: '$m شهر',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
