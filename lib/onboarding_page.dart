import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/util/app_textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:biplazma/login_page.dart';

import 'widget/painter/painter5.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent));
    return Stack(
      children: <Widget>[
        Container(height: double.infinity, width: double.infinity, color: Colors.white),
        buildPath(Screen5Painter()),
        buildIntroductionScreen,
      ],
    );
  }

  PageViewModel buildPageViewModel(String _title, String _body, String _animation) {
    return PageViewModel(
      title: _title,
      body: _body,
      image: Center(child: Lottie.asset(_animation, fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height * 0.25)),
      decoration: pageDecoration,
    );
  }

  PageDecoration pageDecoration = PageDecoration(
    titleTextStyle: AppTextStyles.onboardingTitleStyle,
    bodyTextStyle: AppTextStyles.onboardingBodyStyle,
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
    titlePadding: EdgeInsets.only(top: 30),
    pageColor: Colors.transparent,
    imagePadding: EdgeInsets.zero,
  );

  DotsDecorator dotDecorator = DotsDecorator(
    size: Size(10.0, 10.0),
    color: Color(0x80FFFFFF),
    activeSize: Size(22.0, 10.0),
    activeColor: Colors.white,
    activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
  );

  Widget buildPath(CustomPainter customPainter) =>
      Column(children: <Widget>[CustomPaint(painter: customPainter, child: Container(height: MediaQuery.of(context).size.height))]);

  Widget get buildIntroductionScreen {
    return IntroductionScreen(
      globalBackgroundColor: Colors.transparent,
      key: introKey,
      pages: [
        buildPageViewModel(AppConstant.onboardingTitle1, AppConstant.onboardingBody1, AppConstant.onboardingAnimation1),
        buildPageViewModel(AppConstant.onboardingTitle2, AppConstant.onboardingBody2, AppConstant.onboardingAnimation2),
        buildPageViewModel(AppConstant.onboardingTitle3, AppConstant.onboardingBody3, AppConstant.onboardingAnimation3),
        buildPageViewModel(AppConstant.onboardingTitle4, AppConstant.onboardingBody4, AppConstant.onboardingAnimation4),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(AppConstant.skip, style: TextStyle(color: Colors.white)),
      next: Icon(Icons.arrow_forward, color: Colors.white),
      done: Text(AppConstant.done, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      dotsDecorator: dotDecorator,
    );
  }
}
