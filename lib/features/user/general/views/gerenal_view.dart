import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';
import 'package:gym_management_app/features/user/general/cubit/gerenal_cubit.dart';
import 'package:gym_management_app/features/user/general/views/widgets/custom_nav_bar.dart';

class GerenalView extends StatelessWidget {
  const GerenalView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GerenalCubit(),
      child: BlocBuilder<GerenalCubit, GerenalState>(
        builder: (context, _) {
          final cubit = context.read<GerenalCubit>();
          final brightness = MediaQuery.platformBrightnessOf(context);
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                extendBody: true,
                body: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.backround),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: cubit.views[cubit.currentIndex],
                ),

                bottomNavigationBar: CustomNavBar(),
              ),
            ),
          );
        },
      ),
    );
  }
}
