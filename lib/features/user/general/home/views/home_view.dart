import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_loading_overlay.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/announcement_section.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/home_banner.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/home_member_info.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/training_today_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (_, state) {
        if (state is HomeError) {
          appSnackbar(context, state.message);
        }
      },
      builder: (_, state) {
        return CustomLoadingOverlay(
          isLoading: state is HomeLoading,
          child: state is HomeLoaded
              ? SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      spacing: 16,
                      children: [
                        const HomeBanner(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            spacing: 16,
                            children: [
                              HomeMemberInfo(
                                member: state.member,
                                remainingDays: state.remainingDays,
                              ),
                              TrainingTodaySection(
                                isAttendToday: state.member.attendedToday,
                                lastAttendance: state.member.lastAttendance,
                              ),
                              AlertSection(alerts: state.alerts),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
