import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';

void appSnackbar(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: CustomText(text: message),
      backgroundColor: color ?? Colors.red[900],
      duration: const Duration(seconds: 3),
    ),
  );
}
