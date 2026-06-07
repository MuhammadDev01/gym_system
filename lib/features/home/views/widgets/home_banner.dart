import 'package:flutter/material.dart';
import 'package:gym_management_app/core/utils/assets.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width > 650 ? 300 : 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const AssetImage(Assets.banner),
          fit: MediaQuery.of(context).size.width > 650
              ? BoxFit.fill
              : BoxFit.cover,
        ),
      ),
    );
  }
}
