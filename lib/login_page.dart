import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mdi/mdi.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/home_page.dart';
import 'package:biplazma/register_page.dart';
import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/webview_page.dart';
import 'package:toast/toast.dart';

import 'util/app_colors.dart';
import 'util/app_textStyles.dart';
import 'util/helper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool agreement = false;
  bool isGoogleLogin = true;
  String password;
  String fullName;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        persistentFooterButtons: <Widget>[buildSnackBar()],
        body: Center(
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.linearGradient),
            child: isLoading
                ? Center(child: _buildLoadingIndicator)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Helper.sizedBoxH100,
                            AutoSizeText(AppConstant.appName + '\'ya', textAlign: TextAlign.center, style: AppTextStyles.h3TextStyle),
                            Text(AppConstant.loginWelcome, textAlign: TextAlign.center, style: AppTextStyles.h3TextStyle),
                            Visibility(
                              visible: !isGoogleLogin,
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 100.0),
                                      child: TextFormField(
                                        cursorColor: Colors.white,
                                        cursorRadius: Radius.circular(20),
                                        controller: emailController,
                                        validator: (String text) {
                                          String pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regExp = RegExp(pattern);
                                          if (text.length == 0) {
                                            return 'Bu alan gerekli';
                                          } else if (!regExp.hasMatch(text)) {
                                            return 'Hatalı email';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        decoration: InputDecoration(
                                          focusedBorder: buildOutlineInputBorder(),
                                          enabledBorder: buildOutlineInputBorder(),
                                          prefixIcon: Icon(Mdi.at, color: Colors.white),
                                          hintText: "E-mail adresinizi giriniz",
                                          hintStyle: TextStyle(color: Colors.white60),
                                          errorStyle: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        cursorColor: Colors.white,
                                        cursorRadius: Radius.circular(20),
                                        onChanged: (value) {
                                          setState(() {
                                            password = value;
                                          });
                                        },
                                        validator: (String text) {
                                          if (text.length <= 5) {
                                            return 'Şifreniz 6 karakterden küçük olamaz';
                                          } else if (text.length == 0) {
                                            return 'Bu alan gerekli';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.visiblePassword,
                                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        decoration: InputDecoration(
                                          focusedBorder: buildOutlineInputBorder(),
                                          enabledBorder: buildOutlineInputBorder(),
                                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                                          hintText: "Şifrenizi giriniz",
                                          hintStyle: TextStyle(color: Colors.white60),
                                          errorStyle: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: FlatButton(
                                            child: Text(
                                              'Şifremi Unuttum',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () {
                                              String pattern =
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regExp = RegExp(pattern);
                                              if (emailController.text.length == 0) {
                                                Toast.show('Geçerli bir e-mail girmelisiniz.', context, duration: 3);
                                              } else if (!regExp.hasMatch(emailController.text)) {
                                                Toast.show('Hatalı email!', context, duration: 3);
                                              } else {
                                                authService.resetPassword(emailController.text);
                                                Toast.show('E-mail adresinize sıfırlama maili gönderildi.', context, duration: 3);
                                              }
                                            },
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: MaterialButton(
                                          minWidth: double.infinity,
                                          height: 42,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                          color: Colors.white,
                                          child: Text("Giriş Yap / Kayıt Ol", style: AppTextStyles.buttonTextStyle),
                                          onPressed: () {
                                            if (_formKey.currentState.validate()) {
                                              final user = authService.signInWithEmailAndPassword(fullName, emailController.text, password);
                                              if (user != null) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => RegisterPage(
                                                              username: emailController.text,
                                                              isGoogleLogin: false,
                                                            )),
                                                    (r) => false);
                                              }
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 30.0, bottom: 10),
                                      child: MaterialButton(
                                        minWidth: double.infinity,
                                        height: 42,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                        color: Colors.white,
                                        child: Text("Geri Dön", style: AppTextStyles.buttonTextStyle),
                                        onPressed: () {
                                          setState(() {
                                            isGoogleLogin = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ])),
                            ),
                            Helper.sizedBoxH100,
                            buildButton(AppConstant.loginEmailButton, isEmailLoginFunc, false),
                            buildButton(AppConstant.loginGoogleButton, isGoogleLoginFunc, true),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void isEmailLoginFunc() => setState(() {
        isGoogleLogin = false;
      });

  Future<void> isGoogleLoginFunc() async {
    print("test");
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authService.googleSignIn();
      if (user != null) {
        var userData = await Firestore.instance.collection("users").document(user.uid).get();
        var age = userData.data['age'];
        setState(() {
          isLoading = false;
        });
        if (age != null) {
          Helper.setRegister(true);
          Helper.setUserToken(user.uid);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (r) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterPage(
                        username: user.displayName,
                        isGoogleLogin: true,
                      )),
              (r) => false);
        }
      }
    } catch (e) {}
  }

  Widget buildButton(String _buttonTitle, void _function, bool _isGoogle) {
    return Visibility(
      visible: isGoogleLogin,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 42,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(visible: _isGoogle, child: SvgPicture.asset(AppConstant.svgGoogleLogo, height: 20)),
              Padding(padding: const EdgeInsets.only(left: 20), child: Text(_buttonTitle, style: AppTextStyles.buttonTextStyle))
            ],
          ),
          onPressed: () => _function,
        ),
      ),
    );
  }

  Visibility buildSnackBar() {
    return Visibility(
      visible: !isLoading,
      child: Container(
          width: MediaQuery.of(context).copyWith().size.width,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  children: [
                    buildTextNoPush(AppConstant.loginSnackBarDevam),
                    buildTextPush(AppConstant.loginSnackBarGizlilik, AppConstant.loginSnackBarSartUrl),
                    buildTextNoPush(' ve '),
                    buildTextPush(AppConstant.loginSnackBarKullanim, AppConstant.loginSnackBarKosulUrl),
                    buildTextNoPush(AppConstant.loginSnackBarKabul),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  TextSpan buildTextPush(String _text, String _webUrl) {
    return TextSpan(
      text: _text,
      style: AppTextStyles.snackBarUrlTextStyle,
      recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(_webUrl, _text))),
    );
  }

  TextSpan buildTextNoPush(String _text) => TextSpan(text: _text, style: AppTextStyles.snackBarTextStyle);
  LoadingIndicator get _buildLoadingIndicator => LoadingIndicator(indicatorType: Indicator.ballScaleMultiple, color: Colors.white);

  OutlineInputBorder buildOutlineInputBorder() =>
      OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(30.0)), borderSide: BorderSide(color: Colors.white));
}
