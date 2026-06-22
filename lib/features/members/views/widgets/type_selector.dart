import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MemberCubit>();
    return BlocBuilder<MemberCubit, MemberState>(
      builder: (context, state) {
        return GlassWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: 'نوع الاشتراك', fontSize: 14),
              const Gap(8),
              Row(
                children: [
                  _TypeChip(
                    label: 'فتنس',
                    value: 'fitness',
                    selected: cubit.selectedType == 'fitness',
                    onSelected: () => cubit.setType('fitness'),
                  ),
                  const Gap(8),
                  _TypeChip(
                    label: 'جيم',
                    value: 'gym',
                    selected: cubit.selectedType == 'gym',
                    onSelected: () => cubit.setType('gym'),
                  ),
                  const Gap(8),
                  _TypeChip(
                    label: 'برايفت',
                    value: 'private',
                    selected: cubit.selectedType == 'private',
                    onSelected: () => cubit.setType('private'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onSelected;

  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.gold
                : Colors.white.withValues(alpha: .06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.gold
                  : Colors.white.withValues(alpha: .15),
            ),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 13,
              color: selected ? AppColors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
