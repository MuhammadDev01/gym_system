import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_state.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/not_subscribed_section.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/subscribed_section.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (_, state) {
        return CustomLoadingOverlay(
          isLoading: state is SubscriptionLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'الاشتراكات',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Gap(18),
                  state is SubscriptionLoading
                      ? SizedBox.shrink()
                      : state is SubscriptionLoaded && state.isSubscribed
                      ? SubscribedSection(member: state.member)
                      : NotSubscribedSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
