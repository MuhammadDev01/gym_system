import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_management_app/core/constants/images_app.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(ImagesApp.logo, height: 80),
      centerTitle: true,
      leading: IconButton(
        icon: IconButton(
          icon: Icon(CupertinoIcons.qrcode_viewfinder, size: 30),
          onPressed: () {},
        ),
        onPressed: () {
          // Handle menu button press
        },
      ),
    );
  }
}
