import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/models/announcement_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_cubit.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_state.dart';
import 'package:gym_management_app/features/alerts/views/widgets/alert_item_builder.dart';

class EditAlertView extends StatefulWidget {
  const EditAlertView({super.key});

  @override
  State<EditAlertView> createState() => _EditAlertViewState();
}

class _EditAlertViewState extends State<EditAlertView> {
  @override
  void initState() {
    if (context.read<AlertAdminCubit>().alerts.isEmpty) {
      context.read<AlertAdminCubit>().getAlerts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'تعديل إعلان'),
        body: BlocConsumer<AlertAdminCubit, AlertAdminState>(
          listener: (_, state) {
            if (state is AlertUpdatedState) {
              appSnackbar(
                context,
                'تم التعديل بنجاح',
                color: AppColors.success,
              );
              context.pop();
            }
            if (state is AlertDeletedState) {
              appSnackbar(context, 'تم الحذف بنجاح', color: AppColors.success);
            }

            if (state is AlertErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            final cubit = context.read<AlertAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is AlertLoadingState,
              child: cubit.alerts.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      itemCount: cubit.alerts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              _showEditDialog(cubit.alerts[index], context),
                          child: AlertItemBuilder(alert: cubit.alerts[index]),
                        );
                      },
                    )
                  : CustomEmptyList(text: 'اعلانات'),
            );
          },
        ),
      ),
    );
  }

  void _showEditDialog(AlertModel ad, BuildContext context) {
    final cubit = context.read<AlertAdminCubit>();
    cubit.startEdit(id: ad.id, message: ad.message, extendDays: 0);
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background.withValues(alpha: 0.8),
          title: CustomText(text: 'تعديل الإعلان', color: AppColors.gold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: cubit.editMessageController,
                hintText: 'نص الإعلان',
                maxLines: 3,
              ),
              const Gap(12),
              CustomText(
                text:
                    'ينتهي في: ${ad.expiresAt.day}/${ad.expiresAt.month}/${ad.expiresAt.year}',
              ),
              const Gap(12),
              DropdownButtonFormField<int>(
                initialValue: cubit.editExtendDays,
                dropdownColor: AppColors.surface,
                decoration: InputDecoration(
                  labelText: 'تمديد (أيام إضافية)',
                  labelStyle: TextStyle(color: AppColors.gold),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gold),
                  ),
                ),
                items: [0, 1, 2, 3, 5, 7, 15, 30].map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: CustomText(text: d == 0 ? 'لا تمديد' : '$d يوم'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) cubit.setEditExtendDays(v);
                },
              ),
            ],
          ),
          actions: _alertActions(context, cubit, ad),
        ),
      ),
    );
  }

  List<Widget> _alertActions(
    BuildContext context,
    AlertAdminCubit cubit,
    AlertModel ad,
  ) {
    return [
      CustomButton(
        text: 'حذف',
        colorButton: AppColors.snackError,
        colorText: Colors.white,
        onPressed: () => showDeleteConfirm(
          context,
          title: 'هل تود حذف هذا الاعلان',
          onConfirm: () {
            context.pop();
            context.pop();
            cubit.deleteAlert(ad.id);
          },
        ),
      ),
      CustomButton(text: 'إلغاء', onPressed: () => context.pop()),
      CustomButton(
        text: 'حفظ',
        colorButton: AppColors.success,
        colorText: Colors.white,
        onPressed: () => cubit.updateAlert(),
      ),
    ];
  }
}
