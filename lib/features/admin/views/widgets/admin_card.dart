import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class AdminCard extends StatelessWidget {
  const AdminCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.iconColor,
  });
  final FaIconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassWidget(
        borderRaduis: 8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            FaIcon(icon, color: iconColor ?? AppColors.gold),
            Gap(16),
            CustomText(text: title, fontSize: 17, color: color),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: (color ?? Colors.white).withValues(alpha: .5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
