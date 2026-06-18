import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';

class AdminCard extends StatelessWidget {
  const AdminCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassWidget(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color ?? const Color(0xFFFDCD03), size: 28),
            const SizedBox(width: 16),
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
