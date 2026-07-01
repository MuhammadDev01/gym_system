import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/profile/cubit/profile_cubit.dart';
import 'package:gym_management_app/features/user/profile/views/widgets/qr_icon.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          final homeCubit = context.read<HomeCubit>();
          if (homeCubit.member != null) {
            homeCubit.member = homeCubit.member!.copyWith(
              image: state.imageBase64,
            );
          }
          appSnackbar(context, 'تم حفظ التغييرات', color: AppColors.success);
        }
        if (state is ProfileError) {
          appSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return CustomLoadingOverlay(
          isLoading: state is ProfileLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
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
                                    backgroundColor: Colors.black,
                                    radius: 50,
                                    backgroundImage: _hasImage(cubit, context)
                                        ? BaseImageCache.getImage(
                                            cubit.imageBase64 ??
                                                context
                                                    .read<HomeCubit>()
                                                    .member!
                                                    .image,
                                          )
                                        : null,
                                    child: !_hasImage(cubit, context)
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
                              labelText: 'الاسم ثلاثي',
                              enabled: false,
                              initialValue: context
                                  .read<HomeCubit>()
                                  .member!
                                  .name,
                            ),
                            CustomTextField(
                              labelText: 'رقم الهاتف',
                              enabled: false,
                              initialValue: context
                                  .read<HomeCubit>()
                                  .member!
                                  .phone,
                            ),
                          ],
                        ),
                      ),
                      QrIcon(),
                    ],
                  ),

                  const Gap(20),
                  if (cubit.imageBase64 !=
                      context.read<HomeCubit>().member?.image)
                    CustomButton(
                      onPressed: () => cubit.updateProfileImage(
                        context.read<HomeCubit>().member!,
                      ),
                      text: 'حفظ التغييرات',
                      icon: const Icon(Icons.save_outlined),
                      size: const Size(double.infinity, 48),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

bool _hasImage(ProfileCubit cubit, BuildContext context) {
  final memberImage = context.read<HomeCubit>().member?.image;
  return (cubit.imageBase64 != null && cubit.imageBase64!.isNotEmpty) ||
      (memberImage != null && memberImage.isNotEmpty);
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
