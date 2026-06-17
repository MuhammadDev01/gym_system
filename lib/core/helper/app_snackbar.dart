import 'package:flutter/material.dart';

void appSnackbar(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.red[900],
      duration: const Duration(seconds: 3),
    ),
  );
}
