import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/admin/cubit/admin_cubit.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key});

  @override
  State<AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<AddMemberView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282A36),
      body: SafeArea(
        child: BlocConsumer<AdminCubit, AdminState>(
          listener: (_, state) {
            if (state is MemberAddedState) {
              appSnackbar(context, 'تم إضافة العضو بنجاح');
              context.pop();
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
            }
          },
          builder: (_, state) {
            return CustomLoadingOverlay(
              isLoading: state is MemberLoadingState,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: GlassWidget(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                              children: [
                                Image.asset(AppAssets.logo, height: 80),
                                const Gap(16),
                                const CustomText(
                                  text: 'إضافة عضو جديد',
                                  fontSize: 22,
                                  color: Color(0xFFFDCD03),
                                ),
                                const Gap(24),
                                CustomTextField(
                                  controller: context
                                      .read<AdminCubit>()
                                      .nameController,
                                  labelText: 'اسم العضو',
                                  prefixIcon: Icons.person,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                                ),
                                const Gap(12),
                                CustomTextField(
                                  controller: context
                                      .read<AdminCubit>()
                                      .phoneController,
                                  labelText: 'رقم الهاتف',
                                  prefixIcon: Icons.phone,
                                  textInputType: TextInputType.phone,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                                ),
                                const Gap(24),
                                CustomButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AdminCubit>().addMember();
                                    }
                                  },
                                  text: 'إضافة',
                                  size: const Size(double.infinity, 50),
                                ),
                              ],
                            ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
