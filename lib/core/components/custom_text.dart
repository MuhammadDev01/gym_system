import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textDirection,
    this.textAlign,
  });
  final String text;
  final double? fontSize;
  final Color? color;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: textDirection,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize ?? 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
