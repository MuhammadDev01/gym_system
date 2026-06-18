import 'package:flutter/material.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.manHandADumbel, fit: BoxFit.cover),
          ),
          _backgroundImageEffect(),
          Scaffold(backgroundColor: Colors.transparent, body: child),
        ],
      ),
    );
  }

  Positioned _backgroundImageEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: .15),
              Colors.black.withValues(alpha: .45),
              Colors.black.withValues(alpha: .92),
            ],
          ),
        ),
      ),
    );
  }
}
