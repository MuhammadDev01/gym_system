import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.obscureText,
    this.onTapSufffix,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
    this.validator,
    this.hintText,
    this.maxLines,
    this.onChanged,
    this.enabled,
    this.enabledColorBorder,
  });
  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final bool? enabled;
  final VoidCallback? onTapSufffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int? maxLines;
  final TextInputType? textInputType;
  final Color? enabledColorBorder;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      keyboardType: textInputType,
      initialValue: controller != null ? null : initialValue,
      obscureText: obscureText ?? false,
      enabled: enabled ?? true,
      validator: validator,
      cursorColor: AppColors.gold,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIconColor: AppColors.gold.withValues(alpha: 0.75),
        suffixIconColor: AppColors.gold.withValues(alpha: 0.75),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: onTapSufffix, icon: Icon(suffixIcon))
            : null,
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.gray),
        focusColor: AppColors.gold,
        errorStyle: const TextStyle(color: AppColors.gold),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enabledColorBorder ?? AppColors.gray),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.gold),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .04),
      ),
    );
  }
}
