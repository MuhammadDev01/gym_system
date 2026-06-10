import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class GoldLine extends StatelessWidget {
  const GoldLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        color: ColorsApp.gold,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
