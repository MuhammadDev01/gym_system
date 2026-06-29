import 'dart:convert';

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
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';

class AddItemOnMarketView extends StatefulWidget {
  const AddItemOnMarketView({super.key});

  @override
  State<AddItemOnMarketView> createState() => _AddItemOnMarketViewState();
}

class _AddItemOnMarketViewState extends State<AddItemOnMarketView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<MarketAdminCubit>().nameController.clear();
    context.read<MarketAdminCubit>().priceController.clear();
    context.read<MarketAdminCubit>().descController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'إضافة منتج'),
        body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
          listener: (context, state) {
            if (state is MarketAdminAdded) {
              appSnackbar(
                context,
                'تم إضافة المنتج بنجاح',
                color: AppColors.success,
              );
              context.pop();
            }
            if (state is MarketAdminError) {
              appSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<MarketAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MarketAdminLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: GlassWidget(
                    borderRaduis: 36,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => cubit.pickImage(),

                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(16),
                              image: cubit.imageBase64 != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(cubit.imageBase64!),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: cubit.imageBase64 == null
                                ? const Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: Colors.white54,
                                  )
                                : null,
                          ),
                        ),
                        const Gap(16),
                        CustomTextField(
                          controller: cubit.nameController,
                          labelText: 'اسم المنتج',
                          prefixIcon: Icons.shopping_bag,
                          validator: (v) => Validators.requiredField(v),
                        ),
                        const Gap(12),
                        CustomTextField(
                          controller: cubit.descController,
                          labelText: 'الوصف',
                          prefixIcon: Icons.description,
                          maxLines: 3,
                          validator: (v) => Validators.requiredField(v),
                        ),
                        const Gap(12),
                        CustomTextField(
                          controller: cubit.priceController,
                          labelText: 'السعر',
                          prefixIcon: Icons.monetization_on,
                          textInputType: TextInputType.number,
                          validator: (v) => Validators.requiredField(v),
                        ),
                        const Gap(16),
                        DropdownButtonFormField<String>(
                          initialValue: cubit.selectedType,
                          dropdownColor: AppColors.surface,
                          decoration: InputDecoration(
                            labelText: 'النوع',
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'supplement',
                              child: CustomText(text: 'أغذية'),
                            ),
                            DropdownMenuItem(
                              value: 'tool',
                              child: CustomText(text: 'أدوات'),
                            ),
                          ],
                          onChanged: (v) => cubit.setType(v),
                        ),
                        const Gap(32),
                        CustomButton(
                          text: 'إضافة',
                          icon: const Icon(Icons.add, color: Colors.black),
                          size: const Size(double.infinity, 50),
                          fontSize: 16,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (cubit.imageBase64 == null) {
                                appSnackbar(context, 'يجب وضع صورة للمنتج');
                              } else {
                                cubit.addProduct();
                              }
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
