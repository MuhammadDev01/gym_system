import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/features/subscription/views/widgets/member_ship_card.dart';

class SubscribedSection extends StatelessWidget {
  const SubscribedSection({super.key, required this.picCard});
  final String picCard;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ActiveSubscriptionStatus(),
          const Gap(20),
          const CustomText(text: 'عضويتك الحالية', fontSize: 24),
          const Gap(20),
          MembershipCard(picCard: picCard),
          const Gap(20),

          SubscriptionInfoCard(),

          const Gap(100),
        ],
      ),
    );
  }
}

class SubscriptionInfoCard extends StatelessWidget {
  const SubscriptionInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        children: [
          _InfoRow(title: 'تاريخ البداية', value: '01 / 06 / 2026'),

          const Divider(height: 24),

          _InfoRow(title: 'تاريخ الانتهاء', value: '01 / 07 / 2026'),

          Gap(40),

          CustomButton(
            onPressed: () {},
            text: "اشتراك",
            size: Size(100, 50),
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(text: title, fontSize: 14, color: Colors.white70),
        ),

        CustomText(text: value, fontSize: 16),
      ],
    );
  }
}

class _ActiveSubscriptionStatus extends StatelessWidget {
  const _ActiveSubscriptionStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: .2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified, color: Colors.green),

          Gap(12),

          CustomText(
            text: 'عضويتك فعالة حالياً',
            color: Colors.green,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
