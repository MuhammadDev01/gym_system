import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/member_item_builder.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/member_search_bar.dart';

class MembersListView extends StatefulWidget {
  const MembersListView({super.key});

  @override
  State<MembersListView> createState() => _MembersListViewState();
}

class _MembersListViewState extends State<MembersListView> {
  @override
  void initState() {
    context.read<MemberCubit>().getAllMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemberCubit, MemberState>(
      listenWhen: (_, next) => next is MemberErrorState,
      listener: (context, state) {
        if (state is MemberErrorState) {
          appSnackbar(context, state.message);
        }
      },
      buildWhen: (_, next) =>
          next is MemberLoadedState || next is MemberLoadingState,
      builder: (context, state) {
        return Scaffold(
          appBar: GlassAppBar(
            title: 'قائمة المشتركين',
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.gold),
                onPressed: () => context.read<MemberCubit>().getAllMembers(
                  forceRefresh: true,
                ),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.backround),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              spacing: 12,
              children: [
                const MemberSearchBar(),
                const _FilterList(),
                if (state is MemberLoadingState) CustomCircularLoading(),
                if (state is MemberLoadedState)
                  Expanded(
                    child: state.members.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            addAutomaticKeepAlives: false,
                            itemCount: state.members.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 16),
                            itemBuilder: (_, index) {
                              return MemberItemBuilder(
                                member: state.members[index],
                              );
                            },
                          )
                        : const CustomEmptyList(text: 'أعضاء'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterList extends StatelessWidget {
  const _FilterList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberCubit, MemberState>(
      builder: (context, state) {
        final cubit = context.read<MemberCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            children: [
              _FilterChip(
                label: 'الكل',
                selected: cubit.filterType == MemberFilter.all,
                onTap: () => cubit.setFilter(MemberFilter.all),
              ),
              _FilterChip(
                label: 'الحاليين',
                selected: cubit.filterType == MemberFilter.active,
                onTap: () => cubit.setFilter(MemberFilter.active),
              ),
              _FilterChip(
                label: 'منتهي',
                selected: cubit.filterType == MemberFilter.expired,
                onTap: () => cubit.setFilter(MemberFilter.expired),
              ),
              if (state is MemberLoadedState)
                Expanded(
                  child: GlassWidget(
                    borderRaduis: 6,
                    borderColor: AppColors.gray,
                    padding: EdgeInsets.all(8),
                    child: CustomText(
                      text: "${state.members.length}  مشترك",
                      fontSize: 16,
                      color: AppColors.gold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold
              : Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.gold : AppColors.gray),
        ),
        child: CustomText(
          text: label,
          fontSize: 13,
          color: selected ? AppColors.black : Colors.white,
        ),
      ),
    );
  }
}
