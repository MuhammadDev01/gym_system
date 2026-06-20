import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_back_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({super.key, this.title, this.actions});
  final String? title;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      borderRaduis: 4,
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        actions: actions,
        centerTitle: true,
        title: CustomText(text: title ?? '', fontSize: 24),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
