import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.initialValue,
    required this.labelText,
    this.obscureText,
    this.onTapSufffix,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
  });
  final String? initialValue;
  final String labelText;
  final bool? obscureText;
  final VoidCallback? onTapSufffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      cursorColor: ColorsApp.gold,
      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        prefixIconColor: ColorsApp.gold.withValues(alpha: 0.75),
        suffixIconColor: ColorsApp.gold.withValues(alpha: 0.75),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(onPressed: onTapSufffix, icon: Icon(suffixIcon)),
        labelText: labelText,
        focusColor: ColorsApp.gold,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsApp.gold),
        ),
        labelStyle: TextStyle(color: ColorsApp.gray, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .04),
      ),
    );
  }
}
