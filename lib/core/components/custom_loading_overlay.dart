import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class CustomLoadingOverlay extends StatefulWidget {
  const CustomLoadingOverlay({super.key, this.height, this.width});
  final double? height;
  final double? width;
  @override
  State<CustomLoadingOverlay> createState() => _CustomLoadingOverlayState();
}

class _CustomLoadingOverlayState extends State<CustomLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 40,
      width: widget.width ?? 64,
      color: ColorsApp.gold,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) =>
              Transform.rotate(angle: _controller.value * 6.28, child: child),
          child: FaIcon(
            FontAwesomeIcons.dumbbell,
            color: ColorsApp.black,
            size: 40,
          ),
        ),
      ),
    );
  }
}
