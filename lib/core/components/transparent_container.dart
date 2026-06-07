import 'package:flutter/material.dart';

class TransparentContainer extends StatelessWidget {
  const TransparentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.black.withValues(alpha: .8), Colors.transparent],
        ),
      ),
    );
  }
}
