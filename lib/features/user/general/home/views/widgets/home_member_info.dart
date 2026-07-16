import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_circular_loading.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
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
                  spacing: 12,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.black,
                      backgroundImage: AssetImage(AppAssets.picProfile),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 6,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: cubit.member!.name, fontSize: 17),
                          CustomText(
                            text: cubit.member!.phone,
                            color: AppColors.gold,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      spacing: 6,
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
            : CustomCircularLoading();
      },
    );
  }
}
