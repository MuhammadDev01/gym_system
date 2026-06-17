import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/subscription/views/widgets/not_subscribed_section.dart';
import 'package:gym_management_app/features/subscription/views/widgets/subscribed_section.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  final isSubscribed = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'الاشتراكات',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Gap(18),
        isSubscribed
            ? SubscribedSection(picCard: AppAssets.cardsPrivateCard)
            : NotSubscribedSection(),
      ],
    );
  }
}
