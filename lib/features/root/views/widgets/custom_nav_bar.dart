import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';
import 'package:gym_management_app/features/root/cubit/root_cubit.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: _containerDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.black.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white.withValues(alpha: .08)),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required int index,
    required FaIconData icon,
    required String label,
  }) {
    final cubit = context.read<RootCubit>();

    return GestureDetector(
      onTap: () => cubit.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: cubit.currentIndex == index
              ? ColorsApp.gold
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 18,
              color: cubit.currentIndex == index ? Colors.black : Colors.white,
            ),

            Gap(6),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: cubit.currentIndex == index
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
