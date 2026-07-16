import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/alerts_section.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/home_banner.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/home_member_info.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (_, next) => next is HomeError,
      listener: (_, state) {
        if (state is HomeError) {
          appSnackbar(context, state.message);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: const [
              HomeBanner(),
              Center(child: HomeMemberInfo()),
              CustomText(text: 'تنبيهات من الكابتن', fontSize: 20),
              Center(child: AlertSection()),
            ],
          ),
        ),
      ),
    );
  }
}
