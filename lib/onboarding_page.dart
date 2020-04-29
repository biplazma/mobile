import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  PageDecoration pageDecoration = PageDecoration(
    titleTextStyle: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
    bodyTextStyle: TextStyle(fontSize: 19.0, color: Colors.white),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
    titlePadding: EdgeInsets.only(top: 30),
    pageColor: Colors.transparent,
    imagePadding: EdgeInsets.zero,
  );
  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent));
    return Stack(
      children: <Widget>[
        Container(height: double.infinity, width: double.infinity, color: Colors.white),
        buildPath(Screen5Painter()),
        IntroductionScreen(
          globalBackgroundColor: Colors.transparent,
          key: introKey,
          pages: [
            PageViewModel(
              title: "Plazma Bağışla",
              body: "Hayat ver! 1 saat bile sürmüyor.",
              image: Center(
                child: Lottie.asset("assets/json/anim/kanbagisi.json", fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height * 0.25),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Sosyal Mesafeni Koru",
              body: "Hastalığı yenmiş olsan bile, tekrar kapmayacağın anlamına gelmez. En az 2 metre uzak dur!",
              image: AspectRatio(
                aspectRatio: 2,
                child: Center(
                  child: Lottie.asset("assets/json/anim/uzakdur.json", fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height * 0.25),
                ),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Yardım Et!",
              body: "Bu uygulama ile sana en yakın dönor ya da hastaları tek tıkla bulabilirsin.",
              image: AspectRatio(
                aspectRatio: 2,
                child: Center(
                  child: Lottie.asset("assets/json/anim/tektik.json", fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height * 0.25),
                ),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Aman Belirtilere Dikkat!",
              body: "Halsizlik, ateş, öksürük vb belirtiler varsa sakın evden çıkma ve hemen yetkilileri ara!",
              image: AspectRatio(
                aspectRatio: 2,
                child: Center(
                  child: Lottie.asset("assets/json/anim/belirti.json", fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height * 0.25),
                ),
              ),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Atla', style: TextStyle(color: Colors.white)),
          next: const Icon(Icons.arrow_forward, color: Colors.white),
          done: const Text('Bitir', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0x80FFFFFF),
            activeSize: Size(22.0, 10.0),
            activeColor: Color(0xFFFFFFFF),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
          ),
        ),
      ],
    );
  }

  Widget buildPath(CustomPainter customPainter) {
    return Column(
      children: <Widget>[
        CustomPaint(
          painter: customPainter,
          child: Container(height: MediaQuery.of(context).size.height),
        ),
      ],
    );
  }
}
