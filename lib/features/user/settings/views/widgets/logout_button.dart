import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (_, state) {
        if (state is AuthLogoutedState) {
          context.go(AppRoutes.authView);
        }
      },
      builder: (_, state) {
        return CustomButton(
          onPressed: () => _showLogoutDialog(context),
          text: 'تسجيل الخروج',
          colorButton: AppColors.error.withValues(alpha: .15),
          colorText: AppColors.error,
          icon: Icon(Icons.logout, color: AppColors.error, size: 20),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xff282A36).withValues(alpha: .5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: .08)),
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (_, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: .15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout,
                          color: AppColors.error,
                          size: 34,
                        ),
                      ),
                      const Gap(20),
                      CustomText(text: 'تسجيل الخروج', color: AppColors.gold),
                      const Gap(12),
                      const CustomText(
                        text: 'هل أنت متأكد من تسجيل الخروج؟',
                        color: Colors.white70,
                      ),
                      const Gap(24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () => context.pop(),
                              text: 'إلغاء',
                              colorButton: Colors.white.withValues(alpha: .1),
                              colorText: Colors.white,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: CustomButton(
                              onPressed: () async {
                                await context.read<AuthCubit>().logoutMember();
                              },
                              text: 'تأكيد',
                              colorButton: AppColors.error.withValues(
                                alpha: .8,
                              ),
                              colorText: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (state is AuthLoadingState) ...[
                        const Gap(24),
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
