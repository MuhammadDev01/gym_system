import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/models/member_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/views/widgets/member_search_bar.dart';
import 'package:gym_management_app/features/members/views/widgets/member_edit_list.dart';

class EditMemberView extends StatefulWidget {
  const EditMemberView({super.key});

  @override
  State<EditMemberView> createState() => _EditMemberViewState();
}

class _EditMemberViewState extends State<EditMemberView> {
  @override
  void initState() {
    super.initState();
    if (context.read<MemberCubit>().allMembers.isEmpty) {
      context.read<MemberCubit>().getAllMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'تعديل بيانات مشترك'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberUpdatedState) {
              appSnackbar(
                context,
                'تم التحديث بنجاح',
                color: AppColors.success,
              );
            } else if (state is MemberDeletedState) {
              appSnackbar(context, 'تم الحذف بنجاح', color: AppColors.success);
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            return Column(
              children: [
                MemberSearchBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomLoadingOverlay(
                      isLoading: state is MemberLoadingState,
                      child: MemberEditList(
                        member: context.watch<MemberCubit>().allMembers,
                        onEdit: _showEditDialog,
                      ),
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

  void _showEditDialog(MemberModel member) {
    final cubit = context.read<MemberCubit>();
    cubit.startEdit(member);
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,

        child: AlertDialog(
          actions: _editMemberActions(ctx, member, cubit),
          backgroundColor: AppColors.background.withValues(alpha: 0.8),
          title: const CustomText(text: 'تعديل المشترك'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: cubit.editNameController,
                labelText: 'الاسم ثلاثي',
                prefixIcon: Icons.person,
              ),
              const Gap(12),
              CustomTextField(
                controller: cubit.editPhoneController,
                labelText: 'رقم الهاتف',
                prefixIcon: Icons.phone,
                textInputType: TextInputType.phone,
              ),
              const Gap(16),
              BlocBuilder<MemberCubit, MemberState>(
                builder: (_, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  cubit.editStartDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) cubit.setEditStartDate(picked);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'بداية الاشتراك',
                              labelStyle: TextStyle(color: AppColors.gold),
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            child: CustomText(
                              text: cubit.editStartDate != null
                                  ? '${cubit.editStartDate!.day}/${cubit.editStartDate!.month}/${cubit.editStartDate!.year}'
                                  : 'اختر تاريخ',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: cubit.editEndDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) cubit.setEditEndDate(picked);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'نهاية الاشتراك',
                              isDense: true,
                              labelStyle: TextStyle(color: AppColors.gold),

                              border: OutlineInputBorder(),
                            ),
                            child: CustomText(
                              text: cubit.editEndDate != null
                                  ? '${cubit.editEndDate!.day}/${cubit.editEndDate!.month}/${cubit.editEndDate!.year}'
                                  : 'اختر تاريخ',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Gap(16),
              Row(
                children: [
                  CustomText(text: 'المدة:', fontSize: 13),
                  const Gap(8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      dropdownColor: AppColors.surface,
                      initialValue: cubit.editMonths,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      items: List.generate(12, (i) => i + 1).map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: CustomText(text: '$m شهر'),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) cubit.setEditMonths(v);
                      },
                    ),
                  ),
                ],
              ),

              const Gap(12),
              Row(
                children: [
                  CustomText(text: 'النوع:', fontSize: 13),
                  const Gap(8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: AppColors.surface,
                      initialValue: cubit.editType,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'fitness',
                          child: CustomText(text: 'فتنس'),
                        ),
                        DropdownMenuItem(
                          value: 'gym',
                          child: CustomText(text: 'جيم'),
                        ),
                        DropdownMenuItem(
                          value: 'private',
                          child: CustomText(text: 'برايفت'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) cubit.setEditType(v);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _editMemberActions(
    BuildContext ctx,
    MemberModel member,
    MemberCubit cubit,
  ) {
    return [
      CustomButton(
        text: 'حذف',
        colorButton: AppColors.snackError,
        colorText: Colors.white,
        onPressed: () {
          Navigator.pop(ctx);
          _showDeleteConfirm(member);
        },
      ),
      CustomButton(
        text: 'إلغاء',
        onPressed: () {
          cubit.cancelEdit();
          Navigator.pop(ctx);
        },
      ),
      CustomButton(
        text: 'حفظ',
        colorText: Colors.white,
        colorButton: AppColors.success,
        onPressed: () {
          cubit.updateMember();
          Navigator.pop(ctx);
        },
      ),
    ];
  }

  void _showDeleteConfirm(MemberModel member) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background.withValues(alpha: 0.6),
          title: const CustomText(text: 'تأكيد الحذف'),
          content: CustomText(text: 'هل أنت متأكد من حذف ${member.name}?'),
          actions: [
            CustomButton(text: 'إلغاء', onPressed: () => context.pop()),
            CustomButton(
              text: 'حذف',
              colorButton: AppColors.snackError,
              colorText: Colors.white,
              onPressed: () async {
                context.pop();
                await context.read<MemberCubit>().deleteMember(member.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
