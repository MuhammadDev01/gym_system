import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textDirection,
  });
  final String text;
  final double? fontSize;
  final Color? color;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: textDirection,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize ?? 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
