import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/image_cache_helper.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';

class HomeMemberInfo extends StatelessWidget {
  const HomeMemberInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return (cubit.member != null && cubit.remainingDays != null)
            ? GlassWidget(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: cubit.member!.image.isNotEmpty
                          ? BaseImageCache.getImage(cubit.member!.image)
                          : null,
                      child: cubit.member!.image.isEmpty
                          ? const Icon(Icons.person, color: Colors.white38)
                          : null,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: cubit.member!.name, fontSize: 17),
                          const Gap(6),
                          CustomText(
                            text: cubit.member!.phone,
                            color: AppColors.gold,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        CustomText(
                          text: cubit.remainingDays.toString(),
                          color: AppColors.gold,
                          fontSize: 20,
                        ),
                        const CustomText(
                          text: 'يوم متبقي',
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(color: AppColors.gold);
      },
    );
  }
}
