import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_cubit.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_state.dart';

class PricesView extends StatefulWidget {
  const PricesView({super.key});

  @override
  State<PricesView> createState() => _PricesViewState();
}

class _PricesViewState extends State<PricesView> {
  final _gymController = TextEditingController();
  final _fitnessController = TextEditingController();
  final _privateController = TextEditingController();

  @override
  void dispose() {
    _gymController.dispose();
    _fitnessController.dispose();
    _privateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(title: 'اسعار الاشتراكات'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backround),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<PricesCubit, PricesState>(
          builder: (context, state) {
            if (state is PricesLoaded) {
              if (_gymController.text.isEmpty) {
                _gymController.text = state.gym.toString();
                _fitnessController.text = state.fitness.toString();
                _privateController.text = state.private.toString();
              }
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  spacing: 24,
                  children: [
                    CustomTextField(
                      controller: _gymController,
                      labelText: 'سعر الجيم (شهرياً)',
                      textInputType: TextInputType.number,
                    ),
                    CustomTextField(
                      controller: _fitnessController,
                      labelText: 'سعر الفتنس (شهرياً)',
                      textInputType: TextInputType.number,
                    ),
                    CustomTextField(
                      controller: _privateController,
                      labelText: 'سعر البرايفت (شهرياً)',
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'حفظ التغييرات',
                      onPressed: () => _save(context),
                    ),
                  ],
                ),
              );
            }
            return const CustomCircularLoading();
          },
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final gym = int.tryParse(_gymController.text.trim());
    final fitness = int.tryParse(_fitnessController.text.trim());
    final private = int.tryParse(_privateController.text.trim());
    if (gym == null || fitness == null || private == null) {
      appSnackbar(context, 'يرجى إدخال أرقام صحيحة', color: AppColors.error);
      return;
    }
    try {
      await context.read<PricesCubit>().updatePrices(
        gym: gym,
        fitness: fitness,
        private: private,
      );
      if (context.mounted) {
        appSnackbar(context, 'تم حفظ الأسعار بنجاح', color: AppColors.success);
      }
    } catch (e) {
      if (context.mounted) {
        appSnackbar(context, e.toString(), color: AppColors.error);
      }
    }
  }
}
