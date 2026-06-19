import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class DetailsMemberShipCard extends StatelessWidget {
  const DetailsMemberShipCard({
    super.key,
    required this.price,
    required this.color,
  });

  final int price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          gymNameOnCard(),

          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Column(
              children: [
                CustomText(
                  text: "$price جنيه / الشهر",
                  fontSize: 16,
                  color: Colors.white,
                ),
                Gap(12),
                CustomButton(
                  text: "اشترك الآن",
                  colorText: Colors.black,
                  size: Size(double.infinity, 35),
                  onPressed: () {},
                  colorButton: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Align gymNameOnCard() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'KONGI ',
              style: TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'GYM',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
