import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/edit_member_dialog_content.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/member_item_builder.dart';
import 'package:gym_management_app/features/admin/members/views/widgets/member_search_bar.dart';

class EditMemberView extends StatefulWidget {
  const EditMemberView({super.key});

  @override
  State<EditMemberView> createState() => _EditMemberViewState();
}

class _EditMemberViewState extends State<EditMemberView> {
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
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(title: 'تعديل بيانات مشترك'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberUpdatedState) {
              appSnackbar(
                context,
                'تم ألتعديل بنجاح',
                color: AppColors.success,
              );
            } else if (state is MemberDeletedState) {
              appSnackbar(context, 'تم الحذف بنجاح', color: AppColors.success);
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            final cubit = context.read<MemberCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MemberLoadingState,
              child: Column(
                children: [
                  MemberSearchBar(),
                  state is MemberLoadedState
                      ? Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(12),
                            addAutomaticKeepAlives: false,
                            itemCount: state.members.length,
                            separatorBuilder: (_, _) => const Gap(16),
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {
                                  cubit.startEdit(state.members[index]);
                                  showEditDialog(
                                    context,
                                    onConfirmDelete: () async {
                                      context.pop();
                                      await cubit.deleteMember();
                                    },
                                    onConfirmUpdate: () async =>
                                        await cubit.updateMember(),
                                    deleteTitle:
                                        'هل تود حذف المشترك بشكل نهائي؟',
                                    editTitle: 'تعديل المشترك',
                                    content: BlocProvider.value(
                                      value: cubit,
                                      child: EditMemberDialogContent(
                                        cubit: cubit,
                                      ),
                                    ),
                                  );
                                },

                                child: MemberItemBuilder(
                                  member: state.members[index],
                                ),
                              );
                            },
                          ),
                        )
                      : CustomEmptyList(text: 'أعضاء'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
