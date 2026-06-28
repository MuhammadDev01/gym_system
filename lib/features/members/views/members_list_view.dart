import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/views/widgets/member_item_builder.dart';
import 'package:gym_management_app/features/members/views/widgets/member_search_bar.dart';

class MembersListView extends StatefulWidget {
  const MembersListView({super.key});

  @override
  State<MembersListView> createState() => _MembersListViewState();
}

class _MembersListViewState extends State<MembersListView> {
  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(
          title: 'قائمة المشتركين',
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.gold),
              onPressed: () => context.read<MemberCubit>().getAllMembers(),
            ),
          ],
        ),
        body: BlocBuilder<MemberCubit, MemberState>(
          builder: (_, state) {
            return Column(
              children: [
                MemberSearchBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomLoadingOverlay(
                      isLoading: state is MemberLoadingState,
                      child: state is MemberLoadedState
                          ? ListView.separated(
                              itemCount: state.members.length,
                              separatorBuilder: (_, _) => const Gap(16),
                              itemBuilder: (_, index) {
                                return MemberItemBuilder(
                                  member: state.members[index],
                                );
                              },
                            )
                          : CustomEmptyList(text: 'أعضاء'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
