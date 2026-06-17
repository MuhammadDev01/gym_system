import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_appbar.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';

class SubscriptionHistoryView extends StatelessWidget {
  const SubscriptionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backround),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomAppBar(
                  title: 'سجل الاشتراكات',
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: ListView(
                    children: const [
                      _SubscriptionCard(
                        plan: 'باقة الجيم - 3 شهور',
                        date: '01/03/2026 - 01/06/2026',
                        price: '900 جنيه',
                      ),
                      Gap(16),
                      _SubscriptionCard(
                        plan: 'باقة الجيم - شهر',
                        date: '01/01/2026 - 01/02/2026',
                        price: '350 جنيه',
                      ),
                      Gap(16),
                      _SubscriptionCard(
                        plan: 'باقة الجيم - 6 شهور',
                        date: '01/07/2025 - 01/01/2026',
                        price: '1500 جنيه',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String plan;
  final String date;
  final String price;
  const _SubscriptionCard({
    required this.plan,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.fitness_center, color: AppColors.gold, size: 24),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: plan, fontSize: 15),
                const Gap(6),
                CustomText(text: date, fontSize: 13, color: Colors.white70),
                const Gap(8),
                CustomText(text: price, fontSize: 14, color: AppColors.gold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
