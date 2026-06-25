import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_glass_alert.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/member_ship_card.dart';

class SubscribedSection extends StatelessWidget {
  const SubscribedSection({super.key, required this.member});
  final MemberModel member;

  String get _cardImage {
    switch (member.subscriptionType) {
      case 'fitness':
        return AppAssets.cardsFitnessCard;
      case 'private':
        return AppAssets.cardsPrivateCard;
      default:
        return AppAssets.cardsGymCard;
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '--';
    return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isActive =
        member.subscriptionEnd != null && member.subscriptionEnd!.isAfter(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomGlassAlert(
          text: isActive ? 'عضويتك فعالة حاليًا' : 'انتهت عضويتك',
          color: isActive ? AppColors.success : AppColors.error,
          icon: isActive
              ? Icon(Icons.verified, color: AppColors.success)
              : Icon(Icons.cancel_outlined, color: AppColors.error),
        ),
        const Gap(20),
        CustomText(
          text: 'عضويتك الحالية',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Gap(20),
        MemberhipCard(picCard: _cardImage),
        const Gap(20),
        _SubscriptionInfoCard(member: member, formatDate: _formatDate),
        const Gap(100),
      ],
    );
  }
}

class _SubscriptionInfoCard extends StatelessWidget {
  const _SubscriptionInfoCard({required this.member, required this.formatDate});

  final MemberModel member;
  final String Function(DateTime?) formatDate;

  String _typeLabel(String type) {
    switch (type) {
      case 'fitness':
        return 'Fitness';
      case 'private':
        return 'خصوصي';
      default:
        return 'جيم';
    }
  }

  @override
  Widget build(BuildContext context) {
    final diff = member.subscriptionEnd?.difference(DateTime.now());
    final remainingDays = diff != null && diff.inDays > 0 ? diff.inDays : 0;

    return GlassWidget(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _InfoRow(
            title: 'نوع الاشتراك',
            value: _typeLabel(member.subscriptionType),
          ),
          const Divider(height: 24),
          _InfoRow(title: 'المدة', value: '${member.subscriptionMonths} شهر'),
          const Divider(height: 24),
          _InfoRow(
            title: 'تاريخ البداية',
            value: formatDate(member.subscriptionStart),
          ),
          const Divider(height: 24),
          _InfoRow(
            title: 'تاريخ الانتهاء',
            value: formatDate(member.subscriptionEnd),
          ),
          const Divider(height: 24),
          _InfoRow(title: 'الأيام المتبقية', value: '$remainingDays يوم'),
          Gap(40),
          CustomButton(onPressed: () {}, text: 'اشتراك'),
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
