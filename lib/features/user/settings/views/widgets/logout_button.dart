import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/settings/cubit/settings_cubit.dart';
import 'package:gym_management_app/features/user/settings/views/widgets/settings_item.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return NavCard(
      icon: Icons.logout,
      title: 'تسجيل الخروج',
      onTap: () => onConfirmLogout(
        context,
        onConfirm: () async {
          context.pop();
          await context.read<SettingsCubit>().logoutMember();
        },
      ),
      iconColor: AppColors.error,
    );
  }
}
