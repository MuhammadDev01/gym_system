import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/core/service/local/local_image_service.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class HomeMemberInfo extends StatelessWidget {
  const HomeMemberInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = LocalCacheService.getString(AppConstants.token);
    return GlassWidget(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: userId != null
                  ? FileImage(
                      File(
                        '${LocalImageService.getImagePathSync('profile_$userId.png')}',
                      ),
                    )
                  : null,
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: LocalCacheService.getString(AppConstants.name)!,
                  ),
                  const Gap(4),
                  CustomText(
                    text: LocalCacheService.getString(AppConstants.phone)!,
                    color: AppColors.gold,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CustomText(text: "18", color: AppColors.gold, fontSize: 20),
                const CustomText(text: "يوم متبقي", color: Colors.white70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
