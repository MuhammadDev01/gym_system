import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.initialValue,
    required this.labelText,
    this.obscureText,
  });
  final String? initialValue;
  final String labelText;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      cursorColor: ColorsApp.gold,

      decoration: InputDecoration(
        labelText: labelText,
        focusColor: ColorsApp.gold,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsApp.gold),
        ),
        labelStyle: TextStyle(color: ColorsApp.gray),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .04),
      ),
    );
  }
}
