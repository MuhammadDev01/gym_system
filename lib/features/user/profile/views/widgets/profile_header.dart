import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/user/profile/cubit/profile_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.username,
    required this.userphone,
  });
  final String username;
  final String userphone;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            GlassWidget(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => context.read<ProfileCubit>().pickImage(),

                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(AppAssets.picProfile),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: username, fontSize: 20),
                          const Gap(4),
                          CustomText(text: userphone, color: Colors.white70),
                        ],
                      ),
                      const Gap(12),
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
    final userData = jsonEncode({
      'name': 'cubit.name',
      'phone': 'cubit.phone',
      'imagePath': "cubit.image?.path ?? ''",
    });

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassWidget(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: const Icon(Icons.close, color: Colors.white70),
                ),

                QrImageView(
                  data: userData,
                  version: QrVersions.auto,
                  size: 200,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.gold,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.gold,
                  ),
                ),
                const Gap(12),
                CustomText(
                  text: 'امسح الباركود للوصول لبيانات العضوية',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ],
            ),
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
