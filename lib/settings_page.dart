import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:biplazma/auth_service.dart';
import 'package:biplazma/contributors_page.dart';
import 'package:biplazma/splash_page.dart';
import 'package:biplazma/util/helper.dart';
import 'package:biplazma/widget/appBar.dart';
import 'package:url_launcher/url_launcher.dart';
import "util/app_colors.dart";

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: CustomAppBar(title: "Ayarlar"),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).copyWith().size.width,
          child: FlatButton(
            child: Text(
              'Coded with 💙 in Turkey 🇹🇷',
              style: GoogleFonts.openSans(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              const url = 'https://www.youtube.com/watch?v=aULM7vv8llk';
              launchURL(url);
            },
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 120,
              child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  const url = 'https://github.com/biplazma';
                  launchURL(url);
                },
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Mdi.github,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('GitHub', style: GoogleFonts.openSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(color: Color(0xff0476C9), borderRadius: BorderRadius.circular(20.0)),
              height: 120,
              child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContributorsPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Mdi.accountGroup,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Katkıda Bulunanlar', style: GoogleFonts.openSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  authService.signOut();
                  Helper.setUserToken('');
                  Helper.setRegister(false);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashPage()), (r) => false);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[AppColors.gradient1, AppColors.gradient2],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.openSans(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
