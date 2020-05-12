import 'package:flutter/material.dart';

class AppColors {
  static final Color colorPrimary = Color(0xFFF9025C);
  static final Color colorSplash = Color(0xFFFD667F);
  static final Color colorSubtitle = Color(0x50000000);
  static final Color colorHint = Color(0x80F9025C);
  static final Color gradient1 = Color(0xffD70652);
  static final Color gradient2 = Color(0xffFF025E);
  static final Color opacity20White = Color(0x20FFFFFF);

  static final Color githubBoxColor = Color(0xFF24292E);
  static final Color contributorsBoxColor = Color(0xFF2A5078);
  static final Color infoBoxColor = Color(0xFFFE3686);

  static LinearGradient get linearGradient => LinearGradient(colors: <Color>[gradient1, gradient2]);
}
