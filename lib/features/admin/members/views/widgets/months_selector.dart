import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';

class MonthsSelector extends StatelessWidget {
  const MonthsSelector({super.key});
  final List<String> _months = const [
    'شهر',
    'شهرين',
    '3 أشهر',
    '4 أشهر',
    '5 أشهر',
    '6 أشهر',
    '7 أشهر',
    '8 أشهر',
    '9 أشهر',
    '10 أشهر',
    '11 شهر',
    '12 شهر',
  ];
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonFormField<int>(
        initialValue: context.read<MemberCubit>().selectedMonths - 1,
        dropdownColor: const Color(0xFF282A36),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        items: _months.asMap().entries.map((e) {
          return DropdownMenuItem<int>(
            value: e.key,
            child: CustomText(
              text: e.value,
              textDirection: TextDirection.rtl,
              fontSize: 18,
            ),
          );
        }).toList(),
        onChanged: (v) {
          if (v != null) context.read<MemberCubit>().setMonths(v + 1);
        },
      ),
    );
  }
}
