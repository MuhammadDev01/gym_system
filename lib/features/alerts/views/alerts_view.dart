import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_empty_list.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_cubit.dart';
import 'package:gym_management_app/features/alerts/cubit/admin/alert_admin_state.dart';
import 'package:gym_management_app/features/alerts/views/widgets/alert_item_builder.dart';

class AlertsListView extends StatefulWidget {
  const AlertsListView({super.key});

  @override
  State<AlertsListView> createState() => _AlertsListViewState();
}

class _AlertsListViewState extends State<AlertsListView> {
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: GlassAppBar(
            title: 'الإعلانات',
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: AppColors.gold),
                onPressed: () => context.read<AlertAdminCubit>().getAlerts(),
              ),
            ],
          ),

          body: BlocConsumer<AlertAdminCubit, AlertAdminState>(
            listener: (_, state) {
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
                          return AlertItemBuilder(alert: cubit.alerts[index]);
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
