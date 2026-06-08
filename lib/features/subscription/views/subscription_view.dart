import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/subscription/views/widgets/not_subscribed_section.dart';
import 'package:gym_management_app/features/subscription/views/widgets/subscribed_section.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  final isSubscribed = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(text: 'الاشتراكات', fontSize: 24),
          isSubscribed
              ? SubscribedSection(picCard: Assets.cardsPrivateCard)
              : NotSubscribedSection(),
        ],
      ),
    );
  }
}
