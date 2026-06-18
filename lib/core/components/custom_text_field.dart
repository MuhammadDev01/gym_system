import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    required this.labelText,
    this.obscureText,
    this.onTapSufffix,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
    this.validator,
  });
  final TextEditingController? controller;
  final String? initialValue;
  final String labelText;
  final bool? obscureText;
  final VoidCallback? onTapSufffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: textInputType,
      initialValue: controller != null ? null : initialValue,
      obscureText: obscureText ?? false,
      validator: validator,
      cursorColor: AppColors.gold,
      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        prefixIconColor: AppColors.gold.withValues(alpha: 0.75),
        suffixIconColor: AppColors.gold.withValues(alpha: 0.75),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: onTapSufffix, icon: Icon(suffixIcon))
            : null,
        labelText: labelText,
        focusColor: AppColors.gold,
        errorStyle: TextStyle(color: AppColors.gold),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.gold),
        ),
        labelStyle: TextStyle(color: AppColors.gray, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .04),
      ),
    );
  }
}
