import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_back_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/admin/cubit/member/member_cubit.dart';
import 'package:gym_management_app/features/admin/cubit/member/member_state.dart';
import 'package:gym_management_app/features/admin/views/widgets/members_list.dart';

class MemberListView extends StatefulWidget {
  const MemberListView({super.key});

  @override
  State<MemberListView> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getMember();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _memberListViewHeader(),
                  Expanded(
                    child: CustomLoadingOverlay(
                      isLoading: state is MemberLoadingState,
                      child: state is MemberLoadedState
                          ? MemberList(member: state.member)
                          : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  GlassWidget _memberListViewHeader() {
    return GlassWidget(
      padding: EdgeInsets.all(12),
      child: Row(
        spacing: 16,
        children: [
          CustomBackButton(),
          const CustomText(text: 'قائمة المتشركين', fontSize: 18),
        ],
      ),
    );
  }
}
