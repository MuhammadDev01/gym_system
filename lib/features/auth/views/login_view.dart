import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:gym_management_app/features/auth/views/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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

          Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocBuilder<AuthCubit, AuthState>(
              builder: (_, state) {
                return CustomLoadingOverlay(
                  isLoading: state is AuthLoadingState,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppAssets.logo, height: 120),
                          const Gap(24),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 12,
                                  sigmaY: 12,
                                ),
                                child: GlassWidget(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 32,
                                  ),
                                  child: LoginViewBody(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
