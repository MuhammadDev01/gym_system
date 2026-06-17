import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          leading ?? const SizedBox(width: 44),
          const Gap(8),
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(8),
          actions != null
              ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
              : const SizedBox(width: 44),
        ],
      ),
    );
  }
}
