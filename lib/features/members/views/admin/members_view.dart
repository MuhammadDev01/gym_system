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
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/models/member_model.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/views/admin/widgets/members_list.dart';
import 'package:gym_management_app/features/members/views/admin/widgets/months_selector.dart';
import 'package:gym_management_app/features/members/views/admin/widgets/type_selector.dart';

class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getAllMembers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(
          title: 'ادارة المشتركين',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: () => context.read<MemberCubit>().getAllMembers(),
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white70),
              onPressed: () => context.push(AppRoutes.scanMemberView),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.gold,
          onPressed: _showAddDialog,
          icon: const Icon(Icons.person_add),
          label: const CustomText(text: 'مشترك جديد', color: Colors.black),
        ),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) async {
            if (state is MemberAddedState) {
              appSnackbar(
                context,
                'تم إضافة المشترك بنجاح',
                color: AppColors.success,
              );
              context.pop();
              await context.read<MemberCubit>().getAllMembers();
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            } else if (state is MemberUpdatedState) {
              appSnackbar(
                context,
                'تم التحديث بنجاح',
                color: AppColors.success,
              );
            } else if (state is MemberDeletedState) {
              appSnackbar(context, 'تم حذف المشترك', color: AppColors.success);
            }
          },
          builder: (_, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: 'بحث بالاسم أو رقم الهاتف...',
                    prefixIcon: Icons.search,
                    onChanged: (v) {
                      context.read<MemberCubit>().searchMembers(v);
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomLoadingOverlay(
                      isLoading: state is MemberLoadingState,
                      child: state is MemberLoadedState
                          ? MemberList(
                              member: state.members,
                              onEdit: _showEditDialog,
                              onToggleAttendance: (m) {
                                context.read<MemberCubit>().toggleAttendance(m);
                              },
                            )
                          : const SizedBox.shrink(),
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
          backgroundColor: AppColors.background,
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
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'تاريخ البداية',
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                        const Gap(2),
                        CustomText(
                          text: member.subscriptionStart != null
                              ? '${member.subscriptionStart!.day}/${member.subscriptionStart!.month}/${member.subscriptionStart!.year}'
                              : '—',
                          fontSize: 13,
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'تاريخ الانتهاء',
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                        const Gap(2),
                        CustomText(
                          text: member.subscriptionEnd != null
                              ? '${member.subscriptionEnd!.day}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.year}'
                              : '—',
                          fontSize: 13,
                          color: cubit.editMonths != member.subscriptionMonths
                              ? AppColors.gold
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
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
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'حذف',
                    colorButton: AppColors.snackError,
                    onPressed: () {
                      Navigator.pop(ctx);
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          backgroundColor: AppColors.background,
                          title: const CustomText(text: 'تأكيد الحذف'),
                          content: const CustomText(
                            text: 'هل أنت متأكد من حذف هذا المشترك؟',
                          ),
                          actions: [
                            CustomButton(
                              text: 'إلغاء',
                              colorText: AppColors.snackError,
                              onPressed: () => Navigator.pop(c),
                            ),
                            CustomButton(
                              text: 'حذف',
                              colorButton: AppColors.snackError,
                              onPressed: () {
                                // context.read<MemberCubit>().deleteMember();
                                // Navigator.pop(c);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: CustomButton(
                    text: 'إلغاء',
                    colorText: AppColors.snackError,
                    onPressed: () {
                      cubit.cancelEdit();
                      Navigator.pop(ctx);
                    },
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: CustomButton(
                    text: 'حفظ',
                    onPressed: () {
                      cubit.updateMember();
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    final cubit = context.read<MemberCubit>();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background.withValues(alpha: 0.8),
          title: const CustomText(text: 'إضافة مشترك جديد'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: cubit.nameController,
                  labelText: 'اسم المشترك ثلاثي',
                  prefixIcon: Icons.person,
                  validator: (v) => Validators.requiredField(v),
                ),
                const Gap(12),
                CustomTextField(
                  controller: cubit.phoneController,
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icons.phone,
                  textInputType: TextInputType.phone,
                  validator: (v) => Validators.requiredField(v),
                ),
                const Gap(16),
                Row(
                  children: [
                    CustomText(text: 'المدة:', fontSize: 13),
                    const Gap(8),
                    Expanded(child: MonthsSelector()),
                  ],
                ),
                const Gap(12),

                TypeSelector(),
              ],
            ),
          ),
          actions: [
            CustomButton(
              text: 'إلغاء',
              colorButton: AppColors.snackError,
              colorText: Colors.white,
              onPressed: () => Navigator.pop(ctx),
            ),
            CustomButton(
              text: 'إضافة',
              colorText: Colors.white,
              colorButton: AppColors.success,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await cubit.addMember();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
