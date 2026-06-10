import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/auth/views/widgets/gold_line.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Image.asset(Assets.logo, height: 120),
            const Gap(24),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: GlassWidget(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(text: "WELCOME BACK", fontSize: 28),
                      GoldLine(),

                      const Gap(16),
                      CustomText(
                        text: "سجل الدخول للوصول إلى حسابك",
                        color: Colors.white70,
                      ),

                      const Gap(32),

                      CustomTextField(
                        textInputType: TextInputType.phone,
                        labelText: "رقم الهاتف",
                        prefixIcon: Icons.phone,
                      ),

                      const Gap(16),

                      CustomTextField(
                        textInputType: TextInputType.visiblePassword,
                        labelText: "كلمة المرور",
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        suffixIcon: Icons.visibility_off_outlined,
                        onTapSufffix: () {},
                      ),

                      const Gap(8),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: CustomText(
                            text: "نسيت كلمة المرور؟",
                            color: ColorsApp.gold,
                          ),
                        ),
                      ),

                      const Gap(16),

                      CustomButton(onPressed: () {}, text: "تسجيل الدخول"),

                      const Gap(16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomText(
                            text: "ليس لديك حساب؟",
                            color: Colors.white70,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: CustomText(
                              text: "إنشاء حساب",
                              color: ColorsApp.gold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
