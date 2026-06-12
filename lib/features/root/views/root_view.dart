import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/auth/views/registration_view.dart';
import 'package:gym_management_app/features/general/views/gerenal_view.dart';
import 'package:gym_management_app/features/root/cubit/root_cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});
  static Widget currentView = SizedBox.shrink();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RootCubit, RootState>(
      listener: (context, state) {
        if (state is RootSuccessLogin) {
          currentView = GerenalView();
        }
        if (state is RootFailLogin) {
          currentView = RegistrationView();
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RootLoading,
          child: currentView,
        );
      },
    );
  }
}
