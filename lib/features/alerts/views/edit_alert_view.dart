import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_cubit.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_state.dart';
import 'package:gym_management_app/features/alerts/views/widgets/alert_edit_dialog_content.dart';
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
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            cubit.startEdit(cubit.alerts[index]);
                            showEditDialog(
                              context,
                              onConfirmDelete: () {
                                context.pop();
                                context.pop();
                                cubit.deleteAlert();
                              },
                              onConfirmUpdate: () => cubit.updateAlert(),

                              deleteTitle: 'هل تود حذف الاعلان بشكل نهائي',
                              editTitle: 'تعديل إعلان',
                              content: AlertEditDialogContent(cubit: cubit),
                            );
                          },
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
}
