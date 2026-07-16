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
    this.textOverflow,
    this.maxLines,
    this.height,
  });
  final String text;
  final double? fontSize;
  final Color? color;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextStyle? style;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: textDirection,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
      style:
          style ??
          TextStyle(
            color: color ?? Colors.white,
            height: height,
            fontSize: fontSize ?? 15,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
