import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/features/profile/views/widgets/change_password_section.dart';
import 'package:gym_management_app/features/profile/views/widgets/personal_info_section.dart';
import 'package:gym_management_app/features/profile/views/widgets/profile_header.dart';
import 'package:gym_management_app/features/profile/views/widgets/save_changes_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const CustomText(text: "حسابي", fontSize: 24),
              const Gap(24),
              ProfileHeader(
                username: "محمد خالد عيسى",
                userphone: "01029036889",
              ),
              const Gap(24),
              PersonalInfoSection(
                userPhone: "0101010121",
                username3rd: "محمد خالد عيسى",
              ),
              ChangePasswordSection(),
              const Gap(24),
              SaveChangesButton(),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
