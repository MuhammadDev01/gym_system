import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final member = context.read<HomeCubit>().member!;
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBackground(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: 24,
              children: [
                GlassWidget(
                  borderRaduis: 20,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    spacing: 16,
                    children: [
                      Center(
                        child: CustomText(
                          text: 'البيانات الشخصية',
                          fontSize: 22,
                        ),
                      ),
                      CustomText(
                        text: 'الاسم ثلاثي',
                        fontSize: 16,
                        color: AppColors.gold,
                      ),
                      CustomTextField(
                        initialValue: member.name,
                        enabled: false,
                      ),
                      CustomText(
                        text: 'رقم الهاتف',
                        fontSize: 16,
                        color: AppColors.gold,
                      ),
                      CustomTextField(
                        initialValue: member.phone,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                GlassWidget(
                  borderRaduis: 20,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    spacing: 16,
                    children: [
                      QrImageView(
                        data: member.phone,
                        version: QrVersions.auto,
                        size: screenWidth * 0.4,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.white,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.white,
                        ),
                      ),
                      CustomText(
                        text: 'امسح الباركود للوصول لبيانات العضوية',
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
