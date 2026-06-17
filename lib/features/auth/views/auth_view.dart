import 'package:flutter/material.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/auth/views/widgets/auth_view_body.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppAssets.manHandADumbel, fit: BoxFit.cover),
        ),
        _backgroundImageEffect(),
        AuthViewbody(),
      ],
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
