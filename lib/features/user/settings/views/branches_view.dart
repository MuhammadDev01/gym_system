import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';

class BranchesView extends StatelessWidget {
  const BranchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: GlassAppBar(title: "الفروع"),
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
                const Gap(16),
                Expanded(
                  child: ListView(
                    children: const [
                      _BranchCard(
                        name: 'فرع مدينة نصر',
                        address: 'شارع عباس العقاد',
                        phone: '01012345678',
                        landline: '0223456789',
                        workingHours: '8 ص - 12 ص',
                      ),
                      Gap(16),
                      _BranchCard(
                        name: 'فرع الشيخ زايد',
                        address: 'شارع المحور المركزي',
                        phone: '01012345679',
                        landline: '0234567890',
                        workingHours: '8 ص - 12 ص',
                      ),
                      Gap(16),
                      _BranchCard(
                        name: 'فرع التجمع الخامس',
                        address: 'شارع التسعين الجنوبي',
                        phone: '01012345680',
                        landline: '0245678901',
                        workingHours: '9 ص - 11 ص',
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

class _BranchCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String landline;
  final String workingHours;
  const _BranchCard({
    required this.name,
    required this.address,
    required this.phone,
    required this.landline,
    required this.workingHours,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.location_on, color: AppColors.gold, size: 24),
              ),
              const Gap(14),
              CustomText(text: name, fontSize: 16),
            ],
          ),
          const Gap(16),
          const Divider(color: Colors.white12, height: 1),
          const Gap(16),
          _InfoRow(icon: Icons.map, text: address),
          const Gap(10),
          _InfoRow(icon: Icons.phone, text: phone),
          const Gap(10),
          _InfoRow(icon: Icons.call, text: landline),
          const Gap(10),
          _InfoRow(icon: Icons.access_time, text: workingHours),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 18),
        const Gap(10),
        CustomText(text: text, fontSize: 13, color: Colors.white70),
      ],
    );
  }
}
