import 'package:flutter/material.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width > 650 ? 300 : 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: const AssetImage(AppAssets.banner),
          fit: MediaQuery.of(context).size.width > 650
              ? BoxFit.fill
              : BoxFit.cover,
        ),
      ),
    );
  }
}
