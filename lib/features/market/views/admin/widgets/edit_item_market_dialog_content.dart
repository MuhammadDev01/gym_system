import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';

class EditItemMarketDialogContent extends StatelessWidget {
  const EditItemMarketDialogContent({
    super.key,
    required this.cubit,
    required this.formkey,
  });
  final MarketAdminCubit cubit;
  final GlobalKey<FormState> formkey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formkey,
            child: BlocBuilder<MarketAdminCubit, MarketAdminState>(
              bloc: cubit,
              builder: (_, state) {
                final showImage =
                    cubit.imageBase64 != null ||
                    (cubit.itemImage != null && cubit.itemImage!.isNotEmpty);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(text: 'تعديل المنتج', fontSize: 18),
                    const Gap(16),
                    GestureDetector(
                      onTap: () => cubit.pickImage(),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                          image: showImage
                              ? DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(
                                      cubit.imageBase64 ?? cubit.itemImage!,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: showImage
                            ? null
                            : const Icon(
                                Icons.add_photo_alternate,
                                size: 32,
                                color: Colors.white54,
                              ),
                      ),
                    ),
                    const Gap(12),
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
                      validator: (v) => Validators.requiredField(
                        v,
                        message: 'هذا الحقل مطلوب',
                      ),
                    ),
                    const Gap(16),
                    DropdownButtonFormField<String>(
                      initialValue: cubit.selectedType,
                      dropdownColor: AppColors.surface,
                      decoration: InputDecoration(
                        labelText: 'النوع',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 'supplement',
                          child: CustomText(text: 'أغذية'),
                        ),
                        const DropdownMenuItem(
                          value: 'tool',
                          child: CustomText(text: 'أدوات'),
                        ),
                      ],
                      onChanged: (v) => cubit.setType(v),
                    ),
                    const Gap(24),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'إلغاء',
                            colorButton: AppColors.gray,
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: CustomButton(
                            text: 'حفظ',
                            icon: const Icon(Icons.check, color: Colors.black),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                context
                                    .read<MarketAdminCubit>()
                                    .updateProduct();
                                context.pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
