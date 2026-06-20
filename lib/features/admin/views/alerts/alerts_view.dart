import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/models/announcement_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/cubit/alert/alert_cubit.dart';
import 'package:gym_management_app/features/admin/cubit/alert/alert_state.dart';

class AlertView extends StatefulWidget {
  const AlertView({super.key});

  @override
  State<AlertView> createState() => _AlertViewState();
}

class _AlertViewState extends State<AlertView> {
  List<AlertModel> _alerts = [];

  @override
  void initState() {
    super.initState();
    context.read<AlertCubit>().getAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: GlassAppBar(title: 'الإعلانات'),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.gold,
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
            label: const CustomText(text: 'إعلان جديد', color: Colors.black),
          ),
          body: BlocConsumer<AlertCubit, AlertState>(
            listener: (_, state) {
              final cubit = context.read<AlertCubit>();
              if (state is AlertSuccessState) {
                _alerts = state.alerts;
              } else if (state is AlertUpdatedState) {
                cubit.getAlerts();
              } else if (state is AlertErrorState) {
                appSnackbar(context, state.message);
              }
            },
            builder: (_, state) {
              if (_alerts.isEmpty) {
                if (state is AlertLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const Center(child: CustomText(text: 'لا توجد إعلانات'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: _alerts.length,
                itemBuilder: (_, index) {
                  final alert = _alerts[index];
                  final isExpired = alert.isExpired;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _showEditDialog(alert),
                      child: GlassWidget(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.campaign, size: 20),
                                const Gap(8),
                                Expanded(
                                  child: CustomText(
                                    text: alert.message,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isExpired
                                        ? AppColors.snackError
                                        : AppColors.gold,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    text: isExpired ? 'منتهي' : 'نشط',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                CustomText(
                                  text:
                                      'من: ${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year}',
                                ),
                                const Spacer(),
                                CustomText(
                                  text:
                                      'إلى: ${alert.expiresAt.day}/${alert.expiresAt.month}/${alert.expiresAt.year}',
                                  color: isExpired
                                      ? AppColors.snackError
                                      : AppColors.gold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddDialog() {
    final cubit = context.read<AlertCubit>();
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background.withValues(alpha: 0.8),
          title: const CustomText(text: 'إضافة إعلان جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: cubit.alertController,
                hintText: 'نص الإعلان',
                maxLines: 3,
              ),
              const Gap(12),
              DropdownButtonFormField<int>(
                initialValue: cubit.alertDays,
                dropdownColor: AppColors.surface,
                decoration: InputDecoration(
                  labelText: 'المدة',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gold),
                  ),
                ),
                items: [1, 3, 7, 14, 30].map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: CustomText(text: '$d يوم'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) cubit.setAlertDays(v);
                },
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'إلغاء',
              onPressed: () => Navigator.pop(ctx),
              colorText: Colors.white,
              colorButton: AppColors.snackError,
            ),
            CustomButton(
              text: 'إضافة',
              colorText: Colors.white,
              colorButton: AppColors.success,
              onPressed: () {
                cubit.addAlert();
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(AlertModel ad) {
    final cubit = context.read<AlertCubit>();
    cubit.startEdit(id: ad.id, message: ad.message, extendDays: 0);
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background,
          title: const CustomText(text: 'تعديل الإعلان'),
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
          actions: [
            CustomButton(
              text: 'إلغاء',
              colorText: AppColors.snackError,
              onPressed: () => Navigator.pop(ctx),
            ),
            CustomButton(
              text: 'حفظ',
              onPressed: () {
                cubit.updateAlert();
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
