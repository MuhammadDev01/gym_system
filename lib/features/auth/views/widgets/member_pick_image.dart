import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class MemberPickImage extends StatelessWidget {
  const MemberPickImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (_, state) {
        final cubit = context.read<AuthCubit>();
        return GestureDetector(
          onTap: cubit.pickImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: cubit.image == null
                    ? AssetImage(AppAssets.picProfile)
                    : MemoryImage(base64Decode(cubit.image!)) as ImageProvider,
                child: state is LoadingPickState
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: CustomLoadingOverlay(
                          indicator: CupertinoActivityIndicator(
                            color: AppColors.gold,
                          ),
                          isLoading: true,
                          color: Colors.transparent,
                          child: SizedBox.shrink(),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              _cameraIcon(),
            ],
          ),
        );
      },
    );
  }

  Positioned _cameraIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.gold,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
      ),
    );
  }
}
