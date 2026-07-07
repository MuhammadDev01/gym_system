import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';

class MemberSearchBar extends StatefulWidget {
  const MemberSearchBar({super.key});

  @override
  State<MemberSearchBar> createState() => _MemberSearchBarState();
}

class _MemberSearchBarState extends State<MemberSearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: CustomTextField(
        controller: _searchController,
        hintText: 'بحث برقم الهاتف ...',
        prefixIcon: Icons.search,
        onChanged: (v) => context.read<MemberCubit>().searchMembers(v),
      ),
    );
  }
}
