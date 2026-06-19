import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_glass_alert.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/member_ship_card.dart';

class SubscribedSection extends StatelessWidget {
  const SubscribedSection({super.key, required this.picCard});
  final String picCard;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomGlassAlert(
          text: "عضويتك فعالة حاليًا",
          color: AppColors.success,
          icon: Icons.verified,
        ),
        //  _ActiveSubscriptionStatus(),
        const Gap(20),
        CustomText(
          text: 'عضويتك الحالية',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Gap(20),
        MemberhipCard(picCard: picCard),
        const Gap(20),
        _SubscriptionInfoCard(),
        const Gap(100),
      ],
    );
  }
}

class _SubscriptionInfoCard extends StatelessWidget {
  const _SubscriptionInfoCard();

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _InfoRow(title: 'تاريخ البداية', value: '01-06-2026'),
          const Divider(height: 24),
          _InfoRow(title: 'تاريخ الانتهاء', value: '01-07-2026'),
          Gap(40),
          CustomButton(onPressed: () {}, text: "اشتراك"),
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
          child: CustomText(text: title, color: Colors.white70, fontSize: 12),
        ),
        CustomText(text: value, fontSize: 14),
      ],
    );
  }
}
