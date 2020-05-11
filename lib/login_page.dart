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
  String password, fullName;
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
        persistentFooterButtons: <Widget>[_buildSnackBar],
        body: Center(
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.linearGradient),
            child: isLoading ? Center(child: _buildLoadingIndicator) : _buildBody,
          ),
        ),
      ),
    );
  }

  Widget get _buildBody {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Helper.sizedBoxH100,
              AutoSizeText(AppConstant.appName + '\'ya', textAlign: TextAlign.center, style: AppTextStyles.h3TextStyle),
              Text(AppConstant.welcome, textAlign: TextAlign.center, style: AppTextStyles.h3TextStyle),
              Visibility(
                visible: !isGoogleLogin,
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Helper.sizedBoxH100,
                      _buildEmailFormField,
                      Helper.sizedBoxH20,
                      _buildPasswordFormField,
                      _buildForgetPasswordButton,
                      buildButton(AppConstant.loginRegister, loginFunc, false, !isGoogleLogin),
                      buildButton(AppConstant.back, isGoogleLoginTFunc, false, !isGoogleLogin),
                    ])),
              ),
              Helper.sizedBoxH100,
              buildButton(AppConstant.loginEmailButton, isGoogleLoginFFunc, false, isGoogleLogin),
              buildButton(AppConstant.loginGoogleButton, isGoogleLoginFunc, true, isGoogleLogin),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField get _buildEmailFormField {
    return TextFormField(
      cursorColor: Colors.white,
      cursorRadius: Radius.circular(20),
      controller: emailController,
      validator: (String text) {
        RegExp regExp = RegExp(AppConstant.regexRegister);
        if (text.length == 0)
          return AppConstant.fieldRequired;
        else if (!regExp.hasMatch(text))
          return AppConstant.errorEmail;
        else
          return AppConstant.error;
      },
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      decoration: buildInputDecoration(AppConstant.enterEmail, Mdi.at),
    );
  }

  TextFormField get _buildPasswordFormField {
    return TextFormField(
      obscureText: true,
      cursorColor: Colors.white,
      cursorRadius: Radius.circular(20),
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      validator: (String text) {
        if (text.length <= 7)
          return AppConstant.errorPassword;
        else if (text.length == 0)
          return AppConstant.fieldRequired;
        else
          return AppConstant.error;
      },
      keyboardType: TextInputType.visiblePassword,
      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      decoration: buildInputDecoration(AppConstant.enterPassword, Icons.lock),
    );
  }

  Align get _buildForgetPasswordButton {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(AppConstant.forgetPassword, style: TextStyle(color: Colors.white)),
        onPressed: () {
          RegExp regExp = RegExp(AppConstant.regexRegister);
          if (emailController.text.length == 0) {
            Toast.show(AppConstant.noFindMail, context, duration: 3);
          } else if (!regExp.hasMatch(emailController.text)) {
            Toast.show(AppConstant.wrongMail, context, duration: 3);
          } else {
            authService.resetPassword(emailController.text);
            Toast.show(AppConstant.sentMail, context, duration: 3);
          }
        },
      ),
    );
  }

  Widget buildButton(String _buttonTitle, Function _function, bool _isGoogleButton, bool _visible) {
    return Visibility(
      visible: _visible,
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
              Visibility(visible: _isGoogleButton, child: SvgPicture.asset(AppConstant.svgGoogleLogo, height: 20)),
              Visibility(visible: _isGoogleButton, child: Helper.sizedBoxW10),
              Text(_buttonTitle, style: AppTextStyles.buttonTextStyle),
            ],
          ),
          onPressed: () => _function(),
        ),
      ),
    );
  }

  Visibility get _buildSnackBar {
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

  InputDecoration buildInputDecoration(String _hintText, IconData _icons) {
    return InputDecoration(
      focusedBorder: _buildOutlineInputBorder,
      enabledBorder: _buildOutlineInputBorder,
      prefixIcon: Icon(_icons, color: Colors.white),
      hintText: _hintText,
      hintStyle: TextStyle(color: Colors.white70),
      errorStyle: TextStyle(color: Colors.white),
    );
  }

  OutlineInputBorder get _buildOutlineInputBorder =>
      OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(30.0)), borderSide: BorderSide(color: Colors.white));
  void isGoogleLoginFFunc() => setState(() {
        isGoogleLogin = false;
      });

  void isGoogleLoginTFunc() => setState(() {
        isGoogleLogin = true;
      });

  void onChangedPassword(String value) => setState(() {
        password = value;
      });

  void loginFunc() {
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
  }

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
}
