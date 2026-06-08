import 'package:flutter/material.dart';
import 'package:gym_management_app/core/utils/assets.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الصورة الخلفية
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            Assets.cardsGymCard, // أو Image.network()

            fit: BoxFit.cover,
          ),
        ),
        // الطبقة الشفافة + البلور
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.black.withValues(alpha: 0.2), // شفافية
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '300 جنيه ف الشهر',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
