import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/auth/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMemberInfo extends StatelessWidget {
  const HomeMemberInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final cubit = context.read<UserCubit>();
        return GlassWidget(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: cubit.image != null
                      ? FileImage(cubit.image!)
                      : const AssetImage(Assets.picProfile) as ImageProvider,
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: cubit.name),
                      const Gap(4),
                      CustomText(
                        text: cubit.phone,
                        color: ColorsApp.gold,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    CustomText(text: "18", color: ColorsApp.gold, fontSize: 20),
                    const CustomText(text: "يوم متبقي", color: Colors.white70),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
