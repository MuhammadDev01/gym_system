import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
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
    context.read<MemberCubit>().getAllMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(
          title: 'تعديل بيانات مشترك',
          actions: [
            IconButton(
              onPressed: () async {
                await context.read<MemberCubit>().getAllMembers(
                  forceRefresh: true,
                );
              },
              icon: Icon(Icons.refresh, color: AppColors.gold),
            ),
          ],
        ),
        body: Column(
          children: [
            MemberSearchBar(),
            BlocConsumer<MemberCubit, MemberState>(
              listener: (context, state) {
                if (state is MemberUpdatedState) {
                  appSnackbar(
                    context,
                    'تم التعديل بنجاح',
                    color: AppColors.success,
                  );
                } else if (state is MemberDeletedState) {
                  appSnackbar(
                    context,
                    'تم الحذف بنجاح',
                    color: AppColors.success,
                  );
                } else if (state is MemberErrorState) {
                  appSnackbar(context, state.message);
                }
              },
              buildWhen: (_, next) =>
                  next is MemberLoadingState || next is MemberLoadedState,
              builder: (context, state) {
                if (state is MemberLoadingState) {
                  return CustomCircularLoading();
                }
                if (state is MemberLoadedState && state.members.isNotEmpty) {
                  final cubit = context.read<MemberCubit>();
                  return Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      addAutomaticKeepAlives: false,
                      itemCount: state.members.length,
                      separatorBuilder: (_, _) => const Gap(16),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            cubit.startEdit(state.members[index]);
                            showEditDialog(
                              context,
                              onConfirmDelete: () async {
                                await cubit.deleteMember();
                              },
                              onConfirmUpdate: () async {
                                if (cubit.formKeyEdit.currentState!
                                    .validate()) {
                                  await cubit.updateMember();
                                }
                              },
                              deleteTitle: 'هل تود حذف المشترك بشكل نهائي؟',
                              editTitle: 'تعديل المشترك',
                              content: BlocProvider.value(
                                value: cubit,
                                child: EditMemberDialogContent(cubit: cubit),
                              ),
                            );
                          },

                          child: MemberItemBuilder(
                            member: state.members[index],
                          ),
                        );
                      },
                    ),
                  );
                }

                return Expanded(child: CustomEmptyList(text: "أعضاء"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
