import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';

class CustomGlassAlert extends StatelessWidget {
  const CustomGlassAlert({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
  });
  final String text;
  final Color color;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(
        children: [
          icon,
          const Gap(12),
          Expanded(child: CustomText(text: text, fontSize: 16)),
        ],
      ),
    );
  }
}
