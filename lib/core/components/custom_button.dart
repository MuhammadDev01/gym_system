import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius = 10,
    this.icon,
    this.colorButton,
    this.colorText,
    this.size,
    this.fontSize,
  });
  final VoidCallback? onPressed;
  final String text;
  final double borderRadius;
  final Widget? icon;
  final Color? colorButton;
  final Color? colorText;
  final Size? size;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorText,
          fontSize: fontSize,
        ),
      ),
      style: FilledButton.styleFrom(
        fixedSize: size,
        backgroundColor: colorButton ?? AppColors.gold,
        foregroundColor: colorButton ?? AppColors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
