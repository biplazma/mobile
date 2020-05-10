import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biplazma/home_page.dart';
import 'package:biplazma/onboarding_page.dart';
import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/util/helper.dart';
import 'package:connectivity/connectivity.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  ConnectivityResult connectivityResult;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectionSubscription;

  void startTimeout() {
    Future.delayed(Duration(seconds: 2), () {
      if (AppConstant.userToken.length > 0 && AppConstant.isRegistered) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
      }
    });
  }

  void checkConnection() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      startTimeout();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uyarı'),
            content: Text('İnternet bağlantın olmadan uygulamayı kullanmaya devam edemezsin. Lütfen internete bağlandıktan sonra tekrar dene...'),
            actions: <Widget>[
              FlatButton(
                child: Text('Tamam'),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (e) {}
    Helper.getConstansFromShared();
    _connectionSubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkConnection();
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffD70652), Color(0xffFF025E)])),
            child: Center(
              child: Text(
                AppConstant.appName,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
