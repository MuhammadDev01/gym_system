import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_management_app/core/constants/text_app.dart';
import 'package:gym_management_app/core/theme/colors_app.dart';

class ThemeApp {
  static ThemeData defualtTheme = ThemeData(
    fontFamily: cairoFont,

    //scaffold
    scaffoldBackgroundColor: Color(0xff282A36),
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

    //appbar
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: ColorsApp.black,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    //bottom navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,

      selectedItemColor: Colors.yellow,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: TextStyle(fontFamily: cairoFont),
      unselectedLabelStyle: TextStyle(fontFamily: cairoFont),
      type: BottomNavigationBarType.fixed,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorsApp.gold,
      selectionColor: ColorsApp.gold,
      selectionHandleColor: ColorsApp.gold,
    ),
  );
}
