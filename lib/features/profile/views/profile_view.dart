import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/features/profile/views/widgets/change_password_section.dart';
import 'package:gym_management_app/features/profile/views/widgets/personal_info_section.dart';
import 'package:gym_management_app/features/profile/views/widgets/profile_header.dart';
import 'package:gym_management_app/features/profile/views/widgets/save_changes_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(username: "محمد خالد عيسى", userphone: "01029036889"),
        const Gap(18),
        PersonalInfoSection(
          userPhone: "0101010121",
          username3rd: "محمد خالد عيسى",
        ),
        const Gap(18),
        ChangePasswordSection(),
        const Gap(18),
        SaveChangesButton(),
        const Gap(18),
      ],
    );
  }
}
