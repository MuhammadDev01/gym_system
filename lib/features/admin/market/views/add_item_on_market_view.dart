import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/extentions/navigator_extention.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/helper/validators.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';

class AddItemOnMarketView extends StatefulWidget {
  const AddItemOnMarketView({super.key});

  @override
  State<AddItemOnMarketView> createState() => _AddItemOnMarketViewState();
}

class _AddItemOnMarketViewState extends State<AddItemOnMarketView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<MarketAdminCubit>().resetValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: GlassAppBar(title: 'إضافة منتج'),
        body: BlocConsumer<MarketAdminCubit, MarketAdminState>(
          listenWhen: (_, next) =>
              next is MarketAdminAdded || next is MarketAdminError,
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
          buildWhen: (prev, next) =>
              next is MarketAdminLoading ||
              next is MarketAdminImagePicked ||
              next is MarketAdminStockToggled ||
              next is MarketAdminKiloToggled ||
              next is MarketAdmintypeChange,
          builder: (context, state) {
            final cubit = context.read<MarketAdminCubit>();
            return CustomLoadingOverlay(
              isLoading: state is MarketAdminLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: GlassWidget(
                    borderRaduis: 12,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => cubit.pickImage(),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(12),
                              image: cubit.imageBase64 != null
                                  ? DecorationImage(
                                      image: BaseImageCache.getImage(
                                        cubit.imageBase64!,
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                            child: cubit.imageBase64 == null
                                ? const Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: AppColors.gray,
                                  )
                                : null,
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
                          isDense: false,
                          dropdownColor: AppColors.surface,
                          decoration: InputDecoration(
                            labelText: 'النوع',
                            labelStyle: TextStyle(
                              color: AppColors.gold,
                              fontSize: 18,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: AppConstants.supplement,
                              child: CustomText(text: 'مكملات', fontSize: 16),
                            ),
                            DropdownMenuItem(
                              value: AppConstants.tool,
                              child: CustomText(text: 'أدوات', fontSize: 16),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: 'يُباع بالكيلو'),
                            Switch(
                              value: cubit.sellByKilo,
                              onChanged: (_) => cubit.toggleSellByKilo(),
                              activeThumbColor: AppColors.gold,
                            ),
                          ],
                        ),
                        if (cubit.sellByKilo)
                          CustomTextField(
                            controller: cubit.kiloPriceController,
                            labelText: 'سعر الكيلو',
                            prefixIcon: Icons.monetization_on,
                            textInputType: TextInputType.number,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: 'يُباع بالأسكوب'),
                            Switch(
                              value: cubit.sellByPiece,
                              onChanged: (_) => cubit.toggleSellByPiece(),
                              activeThumbColor: AppColors.gold,
                            ),
                          ],
                        ),
                        if (cubit.sellByPiece)
                          CustomTextField(
                            controller: cubit.piecePriceController,
                            labelText: 'سعر الأسكوب',
                            prefixIcon: Icons.monetization_on,
                            textInputType: TextInputType.number,
                          ),
                        CustomButton(
                          text: 'إضافة',
                          icon: const Icon(Icons.add, color: Colors.black),
                          size: const Size(double.infinity, 50),
                          fontSize: 18,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (cubit.imageBase64 == null) {
                                appSnackbar(context, 'يجب وضع صورة للمنتج');
                              } else {
                                await cubit.addProduct();
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
