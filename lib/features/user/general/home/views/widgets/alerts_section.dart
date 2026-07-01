import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';
import 'package:gym_management_app/features/user/general/home/views/widgets/alert_list_item.dart';

class AlertSection extends StatelessWidget {
  const AlertSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return cubit.alerts != null
            ? cubit.alerts!.isEmpty
                  ? Center(
                      child: CustomText(
                        text: 'لا توجد إعلانات',
                        color: AppColors.textSecondary,
                      ),
                    )
                  : ListView.separated(
                      // addAutomaticKeepAlives: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.alerts!.length,
                      separatorBuilder: (_, _) => const Gap(12),
                      itemBuilder: (_, index) {
                        return AlertListItem(alert: cubit.alerts![index]);
                      },
                    )
            : CircularProgressIndicator(color: AppColors.gold);
      },
    );
  }
}
