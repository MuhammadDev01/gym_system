import 'dart:ui';

import 'package:flutter/material.dart';

class GlassWidget extends StatelessWidget {
  const GlassWidget({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.borderRaduis,
  });
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double? borderRaduis;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRaduis ?? 20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(borderRaduis ?? 20),
            border: Border.all(color: Colors.white.withValues(alpha: .1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
