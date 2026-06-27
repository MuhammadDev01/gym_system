import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class ThemeApp {
  static ThemeData defualtTheme = ThemeData(
    fontFamily: AppConstants.cairoFont,

    //*scaffold
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    //*appbar
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    //bottom navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,

      selectedItemColor: Colors.yellow,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: TextStyle(fontFamily: AppConstants.cairoFont),
      unselectedLabelStyle: TextStyle(fontFamily: AppConstants.cairoFont),
      type: BottomNavigationBarType.fixed,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.gold,
      selectionColor: AppColors.gold,
      selectionHandleColor: AppColors.gold,
    ),
  );
}
