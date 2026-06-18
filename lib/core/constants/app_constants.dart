import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management_app/core/constants/app_assets.dart';

class AppConstants {
  AppConstants._();

  //*Fonts
  static final String? cairoFont = GoogleFonts.cairo().fontFamily;

  //*App
  static const String gymName = "KONGI GYM";
  static const String logo = AppAssets.logo;
  static const String iconApp = AppAssets.manHandADumbel;

  //*Network
  static const String token = 'token';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String image = 'image';
  static const String role = 'role';
  static const String member = 'member';
  static const String admin = 'admin';
  static const String adminEmail = 'admin_email';
  static const String adminPassword = 'admin_password';
}
