import 'package:flutter/material.dart';
import 'package:gym_management_app/core/utils/assets.dart';

import 'package:gym_management_app/features/auth/views/widgets/login_card.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(Assets.manHandADumbel, fit: BoxFit.cover),
            ),

            _backgroundImageEffect(),

            LoginCard(),
          ],
        ),
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
