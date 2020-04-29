import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/util/app_textStyles.dart';

import 'app_colors.dart';

class Helper {
  //region SharedPref Keys
  static final String _sharedFileName = 'sharedPref';
  static final String _userToken = 'userToken';
  static final String _isRegistered = 'isRegistered';
  static final String _isPlasmaRequested = 'isPlasmaRequested';
  static final String _donateAgreement = 'donateAgreement';

  static Future<bool> getConstansFromShared() async {
    var prefs = await Hive.openBox(_sharedFileName);
    AppConstant.userToken = prefs.get(_userToken) ?? '';
    AppConstant.isRegistered = prefs.get(_isRegistered);
    AppConstant.isPlasmaRequested = prefs.get(_isPlasmaRequested) ?? false;
    AppConstant.donateAgreement = prefs.get(_donateAgreement) ?? false;
    return true;
  }

  static setUserToken(String token) async {
    var prefs = await Hive.openBox(_sharedFileName);
    AppConstant.userToken = token;
    prefs.put(_userToken, token);
  }

  static setRegister(bool isRegistered) async {
    var prefs = await Hive.openBox(_sharedFileName);
    AppConstant.isRegistered = isRegistered;
    prefs.put(_isRegistered, isRegistered);
  }

  static setPlasmaRequested(bool isPlasmaRequested) async {
    var prefs = await Hive.openBox(_sharedFileName);
    AppConstant.isPlasmaRequested = isPlasmaRequested;
    prefs.put(_isPlasmaRequested, isPlasmaRequested);
  }

  static setDonateAgreement(bool donateAgreement) async {
    var prefs = await Hive.openBox(_sharedFileName);
    AppConstant.donateAgreement = donateAgreement;
    prefs.put(_donateAgreement, donateAgreement);
  }

  static bool isInBetween<T extends num>(T value, {T min, T max}) {
    if (min != null && value < min) {
      return false;
    }
    if (max != null && value >= max) {
      return false;
    }

    return true;
  }

  static String getGreetingForCurrentTime() {
    final hour = DateTime.now().hour;
    if (isInBetween(hour, min: 5, max: 6)) {
      return 'Güneş Doğmak Üzere 🌅';
    } else if (isInBetween(hour, min: 6, max: 12)) {
      return 'Günaydın ☀️';
    } else if (isInBetween(hour, min: 12, max: 18)) {
      return 'İyi Günler 💙';
    } else if (isInBetween(hour, min: 18, max: 22)) {
      return 'İyi Akşamlar 🌃';
    } else {
      return 'İyi Geceler 🌙';
    }
  }

  static SizedBox get sizedBoxH10 => SizedBox(height: 10);
  static SizedBox get sizedBoxH20 => SizedBox(height: 20);
  static SizedBox get sizedBoxH30 => SizedBox(height: 30);
  static SizedBox get sizedBoxH50 => SizedBox(height: 50);
  static SizedBox get sizedBoxH100 => SizedBox(height: 100);
  static SizedBox get sizedBoxW10 => SizedBox(width: 10);
  static SizedBox get sizedBoxW20 => SizedBox(width: 20);

  static InputDecoration appInputDecoration(String _hintText, bool isEnabled) {
    return InputDecoration(
        suffixIcon: isEnabled ? Icon(Icons.arrow_drop_down) : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: AppColors.colorPrimary, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: AppColors.colorPrimary, width: 1.0),
        ),
        hintText: _hintText,
        hintStyle: TextStyle(color: AppColors.colorHint));
  }

  static TextFieldConfiguration appTextFConfig(TextEditingController _controller, String text) {
    return TextFieldConfiguration(
      keyboardType: TextInputType.text,
      style: AppTextStyles.selectTextStyle,
      controller: _controller,
      cursorColor: AppColors.colorPrimary,
      autocorrect: true,
      decoration: Helper.appInputDecoration("$text seçiniz...", true),
    );
  }
}
