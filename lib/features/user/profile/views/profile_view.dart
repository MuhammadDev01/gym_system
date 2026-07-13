import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';
import 'package:gym_management_app/features/user/profile/views/widgets/qr_icon.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Stack(
          children: [
            GlassWidget(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                spacing: 16,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 50,
                    child: Icon(Icons.person, color: Colors.white38, size: 40),
                  ),
                  CustomText(
                    text: 'البيانات الشخصية',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  CustomTextField(
                    labelText: 'الاسم ثلاثي',
                    enabled: false,
                    initialValue: context.read<HomeCubit>().member!.name,
                  ),
                  CustomTextField(
                    labelText: 'رقم الهاتف',
                    enabled: false,
                    initialValue: context.read<HomeCubit>().member!.phone,
                  ),
                ],
              ),
            ),
            QrIcon(),
          ],
        ),
      ),
    );
  }
}
