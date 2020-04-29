import 'package:biplazma/plasma_requests.dart';
import 'package:biplazma/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/util/app_routes.dart';
import 'donate_plasma.dart';
import 'home_page.dart';
import 'request_plasma.dart';

void main() async {
  await Hive.initFlutter();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(BiPlazma());
}

class BiPlazma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      title: AppConstant.appName,
      theme: ThemeData(primaryColor: AppColors.colorPrimary),
      routes: {
        AppRoutes.pageHome: (context) => HomePage(),
        AppRoutes.pageDonatePlasma: (context) => DonatePlasma(),
        AppRoutes.pageRequestPlasma: (context) => RequestPlasma(),
        AppRoutes.pagePlasmaRequests: (context) => PlasmaRequests(),
      },
    );
  }
}
