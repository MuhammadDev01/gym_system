import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class FailedTraining extends StatelessWidget {
  const FailedTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: const CustomText(
                text: 'لم يتم تسجيل حضورك اليوم',
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        const Gap(16),
        GlassWidget(
          padding: EdgeInsets.all(6),
          child: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: ColorsApp.gold),
              const Gap(10),
              const Expanded(
                child: CustomText(text: 'سجل حضورك وابدأ التمرين'),
              ),
              const Gap(10),
              CustomButton(
                icon: FaIcon(FontAwesomeIcons.expand, size: 18),
                onPressed: () {},
                text: 'مسح الكود',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
