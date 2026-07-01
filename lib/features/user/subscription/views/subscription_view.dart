import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/not_subscribed_section.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/subscribed_section.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return context.read<HomeCubit>().member == null
            ? Center(child: CircularProgressIndicator(color: AppColors.gold))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'الاشتراكات',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const Gap(18),
                      cubit.member?.subscriptionEnd != null
                          ? SubscribedSection(member: cubit.member!)
                          : NotSubscribedSection(),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
