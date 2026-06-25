import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/profile/cubit/profile_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return Stack(
          children: [
            GlassWidget(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => cubit.pickImage(),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: cubit.imageBase64 != null
                              ? MemoryImage(base64Decode(cubit.imageBase64!))
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
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: cubit.nameController.text,
                            fontSize: 20,
                          ),
                          const Gap(4),
                          CustomText(
                            text: cubit.phoneController.text,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _qrIcon(context),
          ],
        );
      },
    );
  }

  Widget _qrIcon(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: GestureDetector(
        onTap: () => _showQrDialog(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withValues(alpha: .3)),
          ),
          child: Icon(Icons.qr_code_2, color: AppColors.gold, size: 28),
        ),
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: context.read<ProfileCubit>().phoneController.text,
                version: QrVersions.auto,
                size: 250,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
              const Gap(12),
              CustomText(
                text: 'امسح الباركود للوصول لبيانات العضوية',
                fontSize: 12,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _editPicIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.gold,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.edit, size: 18, color: AppColors.black),
      ),
    );
  }
}
