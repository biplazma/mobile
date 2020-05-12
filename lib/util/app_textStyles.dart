import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final Shader linearGradient = LinearGradient(
    colors: <Color>[AppColors.gradient1, AppColors.gradient2],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static TextStyle get titleStyle => GoogleFonts.openSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle get subtitleStyle => GoogleFonts.openSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle get selectTextStyle => GoogleFonts.openSans(color: AppColors.colorPrimary, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle get containerTextStyle => GoogleFonts.openSans(color: Colors.white, fontSize: 14);
  static TextStyle get buttonTextStyle => GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, foreground: Paint()..shader = linearGradient);
  static TextStyle get appBarTextStyle => GoogleFonts.openSans(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle get logoutBTNTextStyle => GoogleFonts.openSans(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);

  static TextStyle get h3TextStyle => GoogleFonts.openSans(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w500);
  static TextStyle get h3BoldTextStyle => GoogleFonts.openSans(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold);
  static TextStyle get h6TextStyle => GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle get onboardingTitleStyle => GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get onboardingBodyStyle => GoogleFonts.openSans(fontSize: 19, color: Colors.white);

  static TextStyle get snackBarTextStyle => GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold);
  static TextStyle get snackBarUrlTextStyle =>
      GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.colorPrimary, decoration: TextDecoration.underline);
}
