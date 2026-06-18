import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_back_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/admin/cubit/admin_cubit.dart';
import 'package:gym_management_app/features/admin/views/widgets/members_list.dart';

class MembersListView extends StatefulWidget {
  const MembersListView({super.key});

  @override
  State<MembersListView> createState() => _MembersListViewState();
}

class _MembersListViewState extends State<MembersListView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: BlocConsumer<AdminCubit, AdminState>(
          listener: (_, state) {
            if (state is MembersErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _membersListViewHeader(),
                  Expanded(
                    child: CustomLoadingOverlay(
                      isLoading: state is MembersLoadingState,
                      child: state is MembersLoadedState
                          ? MembersList(members: state.members)
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

  GlassWidget _membersListViewHeader() {
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
