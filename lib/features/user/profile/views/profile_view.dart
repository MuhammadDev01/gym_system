import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/profile/cubit/profile_cubit.dart';
import 'package:gym_management_app/features/user/profile/views/widgets/qr_icon.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            appSnackbar(context, 'تم حفظ التغييرات', color: AppColors.success);
          }
          if (state is ProfileError) {
            appSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomLoadingOverlay(
            isLoading: state is ProfileLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: _profileHeader(
                  context,
                  cubit: context.read<ProfileCubit>(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileHeader(BuildContext context, {required ProfileCubit cubit}) =>
      Stack(
        children: [
          GlassWidget(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: () => cubit.pickImage(),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: cubit.imageBase64 != null
                            ? BaseImageCache.getImage(cubit.imageBase64!)
                            : null,
                        child: cubit.imageBase64 == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white38,
                                size: 40,
                              )
                            : null,
                      ),
                      _editPicIcon(),
                    ],
                  ),
                ),
                CustomText(
                  text: 'البيانات الشخصية',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                CustomTextField(
                  controller: cubit.nameController,
                  labelText: 'الاسم ثلاثي',
                  enabled: false,
                ),
                CustomTextField(
                  controller: cubit.phoneController,
                  labelText: 'رقم الهاتف',
                  enabled: false,
                ),
              ],
            ),
          ),
          QrIcon(),
        ],
      );
}

Positioned _editPicIcon() {
  return Positioned(
    bottom: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
      child: Icon(Icons.edit, size: 18, color: AppColors.black),
    ),
  );
}
