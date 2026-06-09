import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/core/utils/assets.dart';
import 'package:gym_management_app/features/profile/cubit/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.username,
    required this.userphone,
  });
  final String username;
  final String userphone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: _containerDecoration(),

      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(Assets.profilePic),
              ),

              _editPicIcon(),
            ],
          ),

          const Gap(16),

          CustomText(text: username, fontSize: 20),

          const Gap(4),

          CustomText(text: userphone, fontSize: 14, color: Colors.white70),
        ],
      ),
    );
  }

  Positioned _editPicIcon() {
    return Positioned(
      bottom: 0,
      right: 0,

      child: Container(
        padding: const EdgeInsets.all(6),

        decoration: BoxDecoration(
          color: ColorsApp.gold,
          shape: BoxShape.circle,
        ),

        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return InkWell(
              onTap: () => context.read<ProfileCubit>().pickImage(),
              child: Icon(Icons.edit, size: 18, color: ColorsApp.black),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: .05),
      borderRadius: BorderRadius.circular(20),

      border: Border.all(color: Colors.white.withValues(alpha: .08)),
    );
  }
}
