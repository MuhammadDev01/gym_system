import 'package:flutter/material.dart';

class MemberhipCard extends StatelessWidget {
  const MemberhipCard({super.key, required this.picCard});

  final String picCard;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(image: AssetImage(picCard), fit: BoxFit.fill),
          // color: color.withValues(alpha: .5),
        ),
      ),
    );
  }
}
