import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_cubit.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_state.dart';

class AddAlertView extends StatefulWidget {
  const AddAlertView({super.key});

  @override
  State<AddAlertView> createState() => _AddAlertViewState();
}

class _AddAlertViewState extends State<AddAlertView> {
  @override
  void initState() {
    super.initState();
    context.read<AlertAdminCubit>().alertController.clear();
    context.read<AlertAdminCubit>().setAlertDuration(const Duration(days: 1));
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(title: 'إضافة إعلان جديد'),
        body: BlocConsumer<AlertAdminCubit, AlertAdminState>(
          listener: (_, state) {
            if (state is AlertAddedState) {
              appSnackbar(
                context,
                'تم إضافة الإعلان بنجاح',
                color: AppColors.success,
              );
              context.pop();
            } else if (state is AlertErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            final cubit = context.read<AlertAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is AlertLoadingState,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: GlassWidget(
                  borderRaduis: 24,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          controller: cubit.alertController,
                          hintText: 'نص الإعلان',
                          maxLines: 3,
                          validator: (p0) => Validators.requiredField(p0),
                        ),
                        const Gap(16),
                        DropdownButtonFormField<Duration>(
                          initialValue: cubit.alertDuration,
                          dropdownColor: AppColors.surface,
                          decoration: InputDecoration(
                            labelText: 'المدة',
                            labelStyle: TextStyle(color: AppColors.gold),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          items:
                              const [
                                MapEntry(Duration(hours: 2), 'ساعتان'),
                                MapEntry(Duration(hours: 4), 'اربع ساعات'),
                                MapEntry(Duration(hours: 12), 'نص يوم'),
                                MapEntry(Duration(days: 1), 'يوم'),
                                MapEntry(Duration(days: 2), 'يومان'),
                                MapEntry(Duration(days: 3), 'ثلاثة أيام'),
                                MapEntry(Duration(days: 7), 'اسبوع'),
                              ].map((e) {
                                return DropdownMenuItem(
                                  value: e.key,
                                  child: CustomText(text: e.value),
                                );
                              }).toList(),
                          onChanged: (v) {
                            if (v != null) cubit.setAlertDuration(v);
                          },
                        ),
                        const Gap(32),
                        CustomButton(
                          text: 'إضافة',
                          icon: const Icon(Icons.add, color: Colors.black),
                          fontSize: 18,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await cubit.addAlert();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
