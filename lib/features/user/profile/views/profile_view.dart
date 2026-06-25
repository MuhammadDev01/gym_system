import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/profile/cubit/profile_cubit.dart';
import 'package:gym_management_app/features/user/profile/views/widgets/profile_header.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (_, state) {
        if (state is ProfileUpdated) {
          appSnackbar(context, 'تم حفظ التغييرات', color: AppColors.success);
        }
        if (state is ProfileError) {
          appSnackbar(context, state.message);
        }
      },
      builder: (_, state) {
        final cubit = context.read<ProfileCubit>();
        return CustomLoadingOverlay(
          isLoading: state is ProfileLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                spacing: 18,
                children: [ProfileHeader(), _profileFields(context, cubit)],
              ),
            ),
          ),
        );
      },
    );
  }

  GlassWidget _profileFields(BuildContext context, ProfileCubit cubit) {
    return GlassWidget(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }
}
