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
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/members/views/widgets/edit_member_dialog_content.dart';
import 'package:gym_management_app/features/members/views/widgets/member_item_builder.dart';
import 'package:gym_management_app/features/members/views/widgets/member_search_bar.dart';

class EditMemberView extends StatefulWidget {
  const EditMemberView({super.key});

  @override
  State<EditMemberView> createState() => _EditMemberViewState();
}

class _EditMemberViewState extends State<EditMemberView> {
  List<MemberModel> _members = [];
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
          buildWhen: (prev, next) =>
              next is MemberEditFormState ||
              next is MemberLoadingState ||
              next is MemberLoadedState ||
              next is MemberUpdatedState ||
              next is MemberDeletedState ||
              next is MemberErrorState,
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
            } else if (state is MemberLoadedState) {
              _members = state.members;
            }
          },
          builder: (_, state) {
            final cubit = context.read<MemberCubit>();
            return Column(
              children: [
                MemberSearchBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomLoadingOverlay(
                      isLoading: state is MemberLoadingState,
                      child: _members.isNotEmpty
                          ? ListView.separated(
                              addAutomaticKeepAlives: false,
                              itemCount: _members.length,
                              separatorBuilder: (_, _) => const Gap(16),
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    cubit.startEdit(_members[index]);
                                    showEditDialog(
                                      context,
                                      onConfirmDelete: () async {
                                        context.pop();
                                        context.pop();
                                        await cubit.deleteMember();
                                      },
                                      onConfirmUpdate: () async {
                                        context.pop();
                                        await cubit.updateMember();
                                      },
                                      deleteTitle:
                                          'هل تود حذف المشترك بشكل نهائي؟',
                                      editTitle: 'تعديل المشترك',
                                      content: EditMemberDialogContent(
                                        cubit: cubit,
                                      ),
                                    );
                                  },

                                  child: MemberItemBuilder(
                                    member: _members[index],
                                  ),
                                );
                              },
                            )
                          : CustomEmptyList(text: 'أعضاء'),
                    ),

                    //  MemberEditList(
                    //    member: context.watch<MemberCubit>().members,
                    //  ),
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
