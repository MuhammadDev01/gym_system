import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/admin/cubit/alert/alert_cubit.dart';
import 'package:gym_management_app/features/admin/cubit/alert/alert_state.dart';

class AddAlertView extends StatelessWidget {
  AddAlertView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: BlocConsumer<AlertCubit, AlertState>(
          listener: (_, state) {
            if (state is AlertAddedState) {
              appSnackbar(context, 'تم إرسال الإعلان');
              context.pop();
            } else if (state is AlertErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            return CustomLoadingOverlay(
              isLoading: state is AlertLoadingState,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white70,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  title: const CustomText(text: 'إضافة إعلان', fontSize: 18),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GlassWidget(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: 'رسالة الإعلان',
                                fontSize: 14,
                              ),
                              const Gap(8),
                              TextFormField(
                                controller: context
                                    .read<AlertCubit>()
                                    .alertController,
                                maxLines: 4,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'اكتب رسالة الإعلان هنا...',
                                  hintStyle: const TextStyle(
                                    color: Colors.white38,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(
                                    alpha: .04,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'مطلوب'
                                    : null,
                              ),
                              const Gap(24),
                              const CustomText(
                                text: 'مدة ظهور الإعلان',
                                fontSize: 14,
                              ),
                              const Gap(8),
                              _DurationSelector(),
                            ],
                          ),
                        ),
                        const Gap(24),
                        CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AlertCubit>().addAlert();
                            }
                          },
                          text: 'إرسال الإعلان',
                          size: const Size(double.infinity, 50),
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

class _DurationSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AlertCubit>();
    return GlassWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const CustomText(text: 'المدة', fontSize: 14),
          const Spacer(),
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<int>(
              initialValue: cubit.alertDays,
              dropdownColor: const Color(0xFF282A36),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              items: [1, 3, 7, 14, 30].map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: CustomText(text: '$d يوم', fontSize: 14),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) cubit.setAlertDays(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
