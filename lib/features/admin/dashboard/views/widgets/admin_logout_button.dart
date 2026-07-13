import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/routes/app_routes.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/dashboard/views/widgets/admin_card.dart';
import 'package:gym_management_app/features/auth/cubit/auth_cubit.dart';

class AdminLogoutButton extends StatelessWidget {
  const AdminLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutedState) {
          context.go(AppRoutes.authView);
        }
      },
      child: AdminCard(
        icon: FontAwesomeIcons.arrowRightFromBracket,
        title: 'تسجيل الخروج',
        onTap: () => onConfirmLogout(
          context,
          onConfirm: () => context.read<AuthCubit>().logoutAdmin(),
        ),
        color: AppColors.snackError,
        iconColor: AppColors.snackError,
      ),
    );
  }
}
