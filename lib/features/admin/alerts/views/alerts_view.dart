import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_cubit.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_state.dart';
import 'package:gym_management_app/features/admin/alerts/views/widgets/alert_item_builder.dart';

class AlertsListView extends StatefulWidget {
  const AlertsListView({super.key});

  @override
  State<AlertsListView> createState() => _AlertsListViewState();
}

class _AlertsListViewState extends State<AlertsListView> {
  @override
  void initState() {
    context.read<AlertAdminCubit>().getAlerts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          appBar: GlassAppBar(
            title: 'الإعلانات',
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: AppColors.gold),
                onPressed: () =>
                    context.read<AlertAdminCubit>().getAlerts(refresh: true),
              ),
            ],
          ),

          body: BlocConsumer<AlertAdminCubit, AlertAdminState>(
            buildWhen: (_, next) =>
                next is AlertLoadingState || next is AlertsLoaded,
            listener: (_, state) {
              if (state is AlertErrorState) {
                appSnackbar(context, state.message);
              }
            },
            builder: (_, state) {
              return CustomLoadingOverlay(
                isLoading: state is AlertLoadingState,
                child: state is AlertsLoaded && state.alerts.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        addAutomaticKeepAlives: false,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: state.alerts.length,
                        itemBuilder: (_, index) {
                          return AlertItemBuilder(alert: state.alerts[index]);
                        },
                      )
                    : CustomEmptyList(text: 'إعلاانات'),
              );
            },
          ),
        ),
      ),
    );
  }
}
