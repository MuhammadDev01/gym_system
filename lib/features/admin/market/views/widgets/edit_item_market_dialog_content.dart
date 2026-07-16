import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';

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
              builder: (_, _) {
                final showImage =
                    cubit.imageBase64 != null ||
                    (cubit.itemImage != null && cubit.itemImage!.isNotEmpty);
                return Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(text: 'تعديل المنتج', fontSize: 18),
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
                                  image: BaseImageCache.getImage(
                                    cubit.imageBase64 ?? cubit.itemImage!,
                                  ),
                                  fit: BoxFit.fill,
                                )
                              : null,
                        ),
                        child: showImage
                            ? null
                            : const Icon(
                                Icons.add_photo_alternate,
                                size: 32,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    CustomTextField(
                      controller: cubit.nameController,
                      labelText: 'اسم المنتج',
                      prefixIcon: Icons.shopping_bag,
                      validator: (v) => Validators.requiredField(v),
                    ),
                    CustomTextField(
                      controller: cubit.descController,
                      labelText: 'الوصف',
                      prefixIcon: Icons.description,
                      maxLines: 3,
                      validator: (v) => Validators.requiredField(v),
                    ),
                    CustomTextField(
                      controller: cubit.priceController,
                      labelText: 'السعر',
                      prefixIcon: Icons.monetization_on,
                      textInputType: TextInputType.number,
                      validator: (v) => Validators.requiredField(v),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: cubit.selectedType,
                      dropdownColor: AppColors.background,
                      decoration: InputDecoration(
                        labelText: 'النوع',
                        labelStyle: TextStyle(color: AppColors.gold),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: AppConstants.supplement,
                          child: CustomText(text: 'مكملات'),
                        ),
                        const DropdownMenuItem(
                          value: AppConstants.tool,
                          child: CustomText(text: 'أدوات'),
                        ),
                      ],
                      onChanged: (v) => cubit.setType(v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: 'متوفر'),
                        Switch(
                          value: cubit.isInStock,
                          onChanged: (_) => cubit.toggleStock(),
                          activeThumbColor: AppColors.success,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'إلغاء',
                            colorButton: Colors.white,
                            colorText: AppColors.black,
                            onPressed: () => context.pop(),
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            text: 'حفظ',
                            icon: const Icon(Icons.check, color: Colors.black),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                cubit.updateProduct();
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
