import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/cubit/gerenal_cubit.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GlassWidget(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Row(
              children: [
                _navItem(
                  index: 0,
                  icon: FontAwesomeIcons.houseChimney,
                  label: 'الرئيسية',
                  context,
                ),

                _navItem(
                  index: 1,
                  icon: FontAwesomeIcons.solidCreditCard,
                  label: 'اشتراكي',
                  context,
                ),

                _navItem(
                  index: 2,
                  icon: FontAwesomeIcons.solidUser,
                  label: 'حسابي',
                  context,
                ),

                _navItem(
                  index: 3,
                  icon: FontAwesomeIcons.bagShopping,
                  label: 'المتجر',
                  context,
                ),

                _navItem(
                  index: 4,
                  icon: FontAwesomeIcons.gear,
                  label: 'الإعدادات',
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required int index,
    required FaIconData icon,
    required String label,
  }) {
    final cubit = context.read<GerenalCubit>();

    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.changePage(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: cubit.currentIndex == index
                ? AppColors.gold
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 18,
                color: cubit.currentIndex == index
                    ? Colors.black
                    : Colors.white,
              ),

              Gap(6),

              FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cubit.currentIndex == index
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
