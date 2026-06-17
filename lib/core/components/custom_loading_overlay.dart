import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CustomLoadingOverlay extends StatefulWidget {
  const CustomLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.color,
    this.indicator,
  });
  final bool isLoading;
  final Widget child;
  final Color? color;
  final Widget? indicator;

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
    return LoadingOverlay(
      progressIndicator:
          widget.indicator ??
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Transform.rotate(
                angle: _controller.value * 6.28,
                child: child,
              ),
              child: DecoratedIcon(
                icon: FaIcon(
                  FontAwesomeIcons.dumbbell,
                  color: AppColors.gold,
                  size: 30,
                ),
                decoration: IconDecoration(
                  border: IconBorder(
                    color: AppColors.black, // لون إطار الأيقونة
                    width: 3.0, // عرض الإطار
                  ),
                ),
              ),
            ),
          ),
      color:
          widget.color ??
          const Color.fromRGBO(0, 0, 0, 1).withValues(alpha: 0.5),
      isLoading: widget.isLoading,
      child: widget.child,
    );
  }
}
