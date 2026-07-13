import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_cubit.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_state.dart';
import 'package:gym_management_app/features/admin/alerts/views/widgets/alert_edit_dialog_content.dart';
import 'package:gym_management_app/features/admin/alerts/views/widgets/alert_item_builder.dart';

class EditAlertView extends StatefulWidget {
  const EditAlertView({super.key});

  @override
  State<EditAlertView> createState() => _EditAlertViewState();
}

class _EditAlertViewState extends State<EditAlertView> {
  @override
  void initState() {
    context.read<AlertAdminCubit>().getAlerts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(title: 'تعديل إعلان'),
        body: BlocConsumer<AlertAdminCubit, AlertAdminState>(
          listener: (_, state) {
            if (state is AlertUpdatedState) {
              appSnackbar(
                context,
                'تم التعديل بنجاح',
                color: AppColors.success,
              );
            }
            if (state is AlertDeletedState) {
              appSnackbar(context, 'تم الحذف بنجاح', color: AppColors.success);
            }

            if (state is AlertErrorState) {
              appSnackbar(context, state.message);
            }
          },
          buildWhen: (_, next) =>
              next is AlertLoadingState || next is AlertsLoaded,
          builder: (_, state) {
            final cubit = context.read<AlertAdminCubit>();
            if (state is AlertLoadingState) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }
            if (state is AlertsLoaded && state.alerts.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                addAutomaticKeepAlives: false,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: state.alerts.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      cubit.startEdit(state.alerts[index]);
                      showEditDialog(
                        context,
                        onConfirmDelete: () => cubit.deleteAlert(),
                        onConfirmUpdate: () => cubit.updateAlert(),
                        deleteTitle: 'هل تود حذف الاعلان بشكل نهائي',
                        editTitle: 'تعديل إعلان',

                        content: AlertEditDialogContent(cubit: cubit),
                      );
                    },
                    child: AlertItemBuilder(alert: state.alerts[index]),
                  );
                },
              );
            }

            return CustomEmptyList(text: 'اعلانات');
          },
        ),
      ),
    );
  }
}
