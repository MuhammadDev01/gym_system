import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class FailedTraining extends StatelessWidget {
  const FailedTraining({super.key, required this.onScanPressed});

  final VoidCallback onScanPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.cancel, color: Colors.red, size: 35),
        ),

        const Gap(16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: 'حالة الحضور اليوم', fontSize: 18),

              const SizedBox(height: 6),

              const CustomText(
                text: 'لم يتم تسجيل حضورك اليوم',
                fontSize: 14,
                color: Colors.white70,
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorsApp.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorsApp.gold.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.qr_code_scanner, color: ColorsApp.gold),

                    const Gap(10),

                    const Expanded(
                      child: CustomText(
                        text: 'سجل حضورك وابدأ التمرين',
                        fontSize: 14,
                      ),
                    ),

                    CustomButton(
                      icon: FaIcon(FontAwesomeIcons.expand, size: 18),
                      onPressed: onScanPressed,
                      text: 'مسح الكود',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
