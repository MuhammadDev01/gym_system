import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';

class CustomEmptyList extends StatelessWidget {
  const CustomEmptyList({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(child: CustomText(text: "لا توجد $text"));
  }
}
