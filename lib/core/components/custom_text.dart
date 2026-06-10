import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textDirection,
    this.textAlign,
    this.style,
  });
  final String text;
  final double? fontSize;
  final Color? color;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: textDirection,
      textAlign: textAlign,
      style:
          style ??
          TextStyle(
            color: color ?? Colors.white,
            fontSize: fontSize ?? 15,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
