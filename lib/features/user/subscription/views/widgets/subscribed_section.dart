import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_glass_alert.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';
import 'package:gym_management_app/features/user/subscription/views/widgets/member_ship_card.dart';

class SubscribedSection extends StatelessWidget {
  const SubscribedSection({super.key, required this.member});
  final MemberModel member;

  String get _cardImage {
    switch (member.subscriptionType) {
      case AppConstants.fitness:
        return AppAssets.cardsFitnessCard;
      case AppConstants.private:
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
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomGlassAlert(
          text: isActive ? 'عضويتك فعالة حاليًا' : 'انتهت عضويتك',
          color: isActive ? AppColors.success : AppColors.error,
          icon: isActive
              ? const Icon(Icons.verified, color: AppColors.success)
              : const Icon(Icons.cancel_outlined, color: AppColors.error),
        ),
        CustomText(
          text: 'عضويتك الحالية',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        MemberhipCard(picCard: _cardImage),
        _SubscriptionInfoCard(member: member, formatDate: _formatDate),
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
      case AppConstants.fitness:
        return 'فتنس';
      case AppConstants.private:
        return 'برايفت';
      default:
        return 'جيم';
    }
  }

  List<InfoRowModel> get _infoRows => [
    InfoRowModel(
      title: 'نوع الاشتراك',
      value: _typeLabel(member.subscriptionType),
    ),
    InfoRowModel(title: 'المدة', value: '${member.subscriptionMonths} شهر'),
    InfoRowModel(
      title: 'تاريخ البداية',
      value: formatDate(member.subscriptionStart),
    ),
    InfoRowModel(
      title: 'تاريخ الانتهاء',
      value: formatDate(member.subscriptionEnd),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final diff = member.subscriptionEnd?.difference(DateTime.now());
    final remainingDays = diff != null && diff.inDays > 0 ? diff.inDays : 0;

    return GlassWidget(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        children: [
          ..._infoRows.map((e) => _InfoRow(model: e)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: 'عدد الأيام المتبقية : '),
              CustomText(text: '$remainingDays  يوم', color: AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoRowModel {
  final String title;
  final String value;
  InfoRowModel({required this.title, required this.value});
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.model});
  final InfoRowModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: model.title,
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        CustomText(text: model.value, fontSize: 14),
      ],
    );
  }
}
