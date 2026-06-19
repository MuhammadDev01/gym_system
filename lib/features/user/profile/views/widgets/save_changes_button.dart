import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/features/user/profile/views/widgets/dialog_message.dart';

class SaveChangesButton extends StatelessWidget {
  const SaveChangesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DialogMessage(),
                ),
              );
            },
          );
        },
        text: "حفظ التغييرات",
        size: Size(130, 55),
        fontSize: 14,
      ),
    );
  }
}
